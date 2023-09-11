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
#import <OneKit/BTDMacros.h>

@interface BIMChatViewDataSource () <BIMMessageListener>
@property (nonatomic, strong) BIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray<BIMMessage *> *p_messageList;
@property (nonatomic, strong) NSArray<BIMMessage *> *messageList;
@property (nonatomic, strong) NSMutableDictionary *messageDict;
@property (nonatomic, assign) BOOL hasOlderMessages;
@property (nonatomic, assign) BOOL hasNewerMessages;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) BIMMessage *earliestMessage;
@property (nonatomic, strong) BIMMessage *searchAnchorMessage;

@property (nonatomic, assign) long long liveGroupNextCursor;
@end

@implementation BIMChatViewDataSource

- (instancetype)initWithConversation:(BIMConversation *)conversation joinMessageCursor:(long long)joinMessageCursor anchorMessage:(BIMMessage *)anchorMessage
{
    if (self = [super init]) {
        _conversation = conversation;
        _p_messageList = [NSMutableArray array];
        _messageDict = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
        _liveGroupNextCursor = joinMessageCursor;
        //        _earliestMessage = anchorMessage;
        _searchAnchorMessage = anchorMessage;
        _hasOlderMessages = YES;
        _hasNewerMessages = NO;
        if (_conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
            [[BIMClient sharedInstance] addLiveGroupMessageListener:self];
        } else {
            [[BIMClient sharedInstance] addMessageListener:self];
        }
    }
    return self;
}

- (instancetype)initWithConversation:(BIMConversation *)conversation joinMessageCursor:(long long)joinMessageCursor
{
    return [self initWithConversation:conversation joinMessageCursor:joinMessageCursor anchorMessage:nil];
}

- (instancetype)initWithConversation:(BIMConversation *)conversation
{
    return [self initWithConversation:conversation joinMessageCursor:0];
}

- (instancetype)initWithConversation:(BIMConversation *)conversation anchorMessage:(BIMMessage *)anchorMessage
{
    return [self initWithConversation:conversation joinMessageCursor:0 anchorMessage:anchorMessage];
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

- (void)loadOlderMessagesWithCompletionBlock:(void (^)(BIMError * _Nullable))completion
{
    int limit = self.pageSize ?: 20;
    @weakify(self);
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] getLiveGroupHistoryMessageList:self.conversation.conversationID cursor:self.liveGroupNextCursor limit:limit completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                self.liveGroupNextCursor = nextCursor;
                [self addOlderMessages:messages];
                self.hasOlderMessages = hasMore;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageList = [self.p_messageList copy];
                if (completion) {
                    completion(error);
                }
            });
        }];
    } else {
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = limit;
        option.anchorMessage = self.earliestMessage ?: self.messageList.lastObject;
        [[BIMClient sharedInstance] getHistoryMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable earliestMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                self.earliestMessage = earliestMessage;
                [self addOlderMessages:messages];
                self.hasOlderMessages = hasMore;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageList = [self.p_messageList copy];
                if (completion) {
                    completion(error);
                }
            });
        }];
    }
}

- (void)addOlderMessages:(NSArray<BIMMessage *> *)messages {
    [self.lock lock];
    [self.p_messageList addObjectsFromArray:messages];
    [messages enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.messageDict[obj.uuid] = obj;
    }];
    [self.lock unlock];
}

- (void)loadNewerMessagesWithCompletionBlock:(void (^)(BIMError * _Nullable))completion
{
    int limit = self.pageSize ?: 20;
    @weakify(self);
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = limit;
        option.anchorMessage = self.messageList.firstObject ?: self.searchAnchorMessage;
        [[BIMClient sharedInstance] getNewerMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                [self addNewerMessages:messages];
                self.hasNewerMessages = hasMore;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageList = [self.p_messageList copy];
                if (completion) {
                    completion(error);
                }
            });
        }];
    }
}

- (void)addNewerMessages:(NSArray<BIMMessage *> *)messages {
    [self.lock lock];
    self.p_messageList = [messages arrayByAddingObjectsFromArray:self.p_messageList].mutableCopy;
    [messages enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.messageDict[obj.uuid] = obj;
    }];
    [self.lock unlock];
}

- (void)loadMessagesWithSearchMsg:(BIMMessage *)searchMessage completionBlock:(void (^)(NSIndexPath * _Nonnull, BIMError * _Nullable))completion
{
    self.searchAnchorMessage = searchMessage;
    if (!searchMessage) {
        return;
    }
    
    __block BIMError *e;
    __block NSArray *olders = @[];
    __block NSArray *newers = @[];
    int limit = self.pageSize ?: 20;
    @weakify(self);
    dispatch_group_t group = dispatch_group_create();
    {
        dispatch_group_enter(group);
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = limit;
        option.anchorMessage = searchMessage;
        [[BIMClient sharedInstance] getNewerMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                self.hasNewerMessages = hasMore;
                newers = messages ?: @[];
            } else {
                e = error;
            }
            dispatch_group_leave(group);
        }];
    }
    
    {
        dispatch_group_enter(group);
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = limit;
        option.anchorMessage = searchMessage;
        [[BIMClient sharedInstance] getHistoryMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable earliestMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                self.earliestMessage = earliestMessage;
                self.hasOlderMessages = hasMore;
                olders = messages ?: @[];
            } else {
                e = error;
            }
            dispatch_group_leave(group);
        }];
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.lock lock];
        [self.p_messageList addObjectsFromArray:newers];
        [self.p_messageList addObject:searchMessage];
        [self.p_messageList addObjectsFromArray:olders];
        [self.p_messageList enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.messageDict[obj.uuid] = obj;
        }];
        [self.lock unlock];
        
        self.messageList = [self.p_messageList copy];
        if (completion) {
            completion([NSIndexPath indexPathForRow:olders.count inSection:0], e);
        }
    });
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
    if (self.p_messageList.count == 0) {
        self.earliestMessage = message;
    }
    if (self.messageDict[message.uuid]) { // update
        [self.messageList enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.uuid isEqualToString:message.uuid]) {
                [self.p_messageList replaceObjectAtIndex:idx withObject:message];
                *stop = YES;
            }
        }];
    } else { // insert
        if (self.hasNewerMessages) {
            [self.lock unlock];
            return;
        }
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
