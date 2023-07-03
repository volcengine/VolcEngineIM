//
//  BIMChatViewDataSource.m
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/16.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMChatViewDataSource.h"
#import "BIMUIDefine.h"
#import <imsdk-tob/BIMSDK.h>

@interface BIMChatViewDataSource () <BIMMessageListener>
@property (nonatomic, strong) BIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray<BIMMessage *> *p_messageList;
@property (nonatomic, strong) NSArray<BIMMessage *> *messageList;
@property (nonatomic, strong) NSMutableDictionary *messageDict;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) BIMMessage *earliestMessage;
@end

@implementation BIMChatViewDataSource

- (instancetype)initWithConversation:(BIMConversation *)conversation
{
    if (self = [super init]) {
        _conversation = conversation;
        _p_messageList = [NSMutableArray array];
        _messageDict = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
        if (_conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
            [[BIMClient sharedInstance] addLiveGroupMessageListener:self];
        } else {
            [[BIMClient sharedInstance] addMessageListener:self];
        }
    }
    return self;
}

- (void)dealloc
{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] removeLiveGroupMessageListener:self];
    } else {
        [[BIMClient sharedInstance] removeMessageListener:self];
    }
}

- (NSUInteger)numberOfItems
{
    NSUInteger count = self.messageList.count;
    return count;
}

- (BIMMessage *)itemAtIndex:(NSUInteger)index
{
    NSInteger reverseIndex = self.messageList.count - index - 1;
    BIMMessage *message = kSafeArrayIndex(self.messageList, reverseIndex);
    if (!message) {
        return nil;
    }
    return message;
}

- (NSUInteger)indexOfItem:(BIMMessage *)item {
    NSUInteger index;
    if ([self.messageList containsObject:item]) {
        index = [self.messageList indexOfObject:item];
    }
    for (int i = 0; i<self.messageList.count; i++) {
        BIMMessage *msg = kSafeArrayIndex(self.messageList, i);
        if ([msg.uuid isEqualToString:item.uuid]) {
            index = i;
            break;
        }
    }
    return self.messageList.count - index - 1;
}

- (void)loadOlderMessagesWithCompletionBlock:(void (^)(NSError * _Nullable))completion
{
    BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
    option.limit = self.pageSize ?: 20;
    option.earliestMessage = self.earliestMessage;
    kWeakSelf(self);
    [[BIMClient sharedInstance] getHistoryMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable earliestMessage, BIMError * _Nullable error) {
        if (!error) {
            weakself.earliestMessage = earliestMessage;
            [weakself.lock lock];
            [weakself.p_messageList addObjectsFromArray:messages];
            [messages enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                weakself.messageDict[obj.uuid] = obj;
            }];
            [weakself.lock unlock];
            weakself.hasMore = hasMore;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageList = [self.p_messageList copy];
            if (completion) {
                completion(error);
            }
        });
    }];
}

#pragma mark - BIMMessageListener

/// 收到新消息
- (void)onReceiveMessage:(BIMMessage *)message
{
    // 非当前会话过滤
    if (![self isCurrentConversationMessage:message]) {
        return;
    }
    
    [self p_insertMessage:message];
}

/// 收到消息被删除
- (void)onDeleteMessage:(NSString *)msgID
{
    [self p_deleteMessage:msgID];
}

/// 收到消息撤回
- (void)onRecallMessage:(BIMMessage *)message
{
    if (![self isCurrentConversationMessage:message]) {
        return;
    }
    [self p_updateMessage:message];
}

/// 消息被修改（内容+扩展）
- (void)onUpdateMessage:(BIMMessage *)message
{
    if (![self isCurrentConversationMessage:message]) {
        return;
    }
    [self p_updateMessage:message];
}

/// 发送消息入库完成
- (void)onSendMessage:(BIMMessage *)message
{
    if (![self isCurrentConversationMessage:message]) {
        return;
    }
    [self p_insertMessage:message];
}

- (void)p_insertMessage:(BIMMessage *)message
{
    [self.lock lock];
    if (self.messageDict[message.uuid]) { // update
        [self.messageList enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.uuid isEqualToString:message.uuid]) {
                [self.p_messageList replaceObjectAtIndex:idx withObject:message];
                *stop = YES;
            }
        }];
    } else { // insert
        [self.p_messageList insertObject:message atIndex:0];
    }
    self.messageDict[message.uuid] = message;
    [self.lock unlock];
    [self sortMessageListWithScrollToBottom:YES];
}

- (void)p_updateMessage:(BIMMessage *)message
{
    [self.messageList enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uuid isEqualToString:message.uuid]) {
            [self.lock lock];
            [self.p_messageList replaceObjectAtIndex:idx withObject:message];
            self.messageDict[message.uuid] = obj;
            [self.lock unlock];
            [self sortMessageListWithScrollToBottom:NO];
            *stop = YES;
        }
    }];
}

- (void)p_deleteMessage:(NSString *)msgID
{
    for (BIMMessage *msg in self.messageList) {
        if ([msg.uuid isEqualToString:msgID]) {
            [self.lock lock];
            [self.p_messageList removeObject:msg];
            self.messageDict[msgID] = nil;
            [self.lock unlock];
            [self sortMessageListWithScrollToBottom:NO];
            return;
        }
    }
}

#pragma mark -

- (void)sortMessageListWithScrollToBottom:(BOOL)scrollToBottom
{
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [self.lock lock];
        [self.p_messageList sortUsingComparator:^NSComparisonResult(BIMMessage *obj1, BIMMessage *obj2) {
            return [@(obj2.orderIndex) compare:@(obj1.orderIndex)];
        }];
        [self.lock unlock];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageList = [self.p_messageList copy];
        if ([self.delegate respondsToSelector:@selector(chatViewDataSourceDidReloadAllMessage:scrollToBottom:)]) {
            [self.delegate chatViewDataSourceDidReloadAllMessage:self scrollToBottom:scrollToBottom];
        }
    });
}

- (BOOL)isCurrentConversationMessage:(BIMMessage *)message {
    return [message.conversationID isEqualToString:self.conversation.conversationID];
}

@end
