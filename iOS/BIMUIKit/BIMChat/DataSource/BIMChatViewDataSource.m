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
@property (nonatomic, strong) NSObject *lock;
@property (nonatomic, strong) BIMMessage *earliestMessage;
@property (nonatomic, strong) BIMMessage *searchAnchorMessage;

@property (nonatomic, assign) long long liveGroupNextCursor;

@property (nonatomic, strong) NSMutableDictionary *userDict;

@end

@implementation BIMChatViewDataSource

- (instancetype)initWithConversation:(BIMConversation *)conversation joinMessageCursor:(long long)joinMessageCursor anchorMessage:(BIMMessage *)anchorMessage
{
    if (self = [super init]) {
        _conversation = conversation;
        _p_messageList = [NSMutableArray array];
        _messageDict = [NSMutableDictionary dictionary];
        _lock = [[NSObject alloc] init];
        _liveGroupNextCursor = joinMessageCursor;
        //        _earliestMessage = anchorMessage;
        _searchAnchorMessage = anchorMessage;
        _hasOlderMessages = YES;
        _hasNewerMessages = NO;
        if (_conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
            [[BIMClient sharedInstance] addLiveGroupMessageListener:self];
            _userDict = [NSMutableDictionary dictionary];
            id<BIMMember> member = self.conversation.currentMember;
            [self.userDict setObject:@{kAliasName: member.alias?:@"",kAvatarUrl: member.avatarURL ?:@""} forKey:@(member.userID)];
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
    NSUInteger count;
    @synchronized (self.lock) {
        count = self.messageList.count;
    }
    return count;
}

- (BIMMessage *)itemAtIndex:(NSUInteger)index
{
    BIMMessage *message;
    @synchronized (self.lock) {
        NSInteger reverseIndex = self.messageList.count - index - 1;
        message = kSafeArrayIndex(self.messageList, reverseIndex);
    }
    if (!message) {
        return nil;
    }
    return message;
}

- (NSUInteger)indexOfItem:(BIMMessage *)item {
    NSUInteger indexOfItem;
    @synchronized (self.lock) {
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
        indexOfItem = self.messageList.count - index - 1;
    }
    return indexOfItem;
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
                @synchronized (self.lock) {
                    self.messageList = [self.p_messageList copy];
                }
                if (completion) {
                    completion(error);
                }
            });
        }];
    } else {
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = limit;
        @synchronized (self.lock) {
            option.anchorMessage = self.earliestMessage ?: self.messageList.lastObject;
        }
        [[BIMClient sharedInstance] getHistoryMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable earliestMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                self.earliestMessage = earliestMessage;
                [self addOlderMessages:messages];
                self.hasOlderMessages = hasMore;
            }
            [self getMessagesReadReceipt:messages];
            dispatch_async(dispatch_get_main_queue(), ^{
                @synchronized (self.lock) {
                    self.messageList = [self.p_messageList copy];
                }
                if (completion) {
                    completion(error);
                }
            });
        }];
    }
}

- (void)addOlderMessages:(NSArray<BIMMessage *> *)messages {
    
    for (BIMMessage *message in messages) {
        NSDictionary *user = self.userDict[@(message.senderUID)];
        if (!user) {
            user = @{kAliasName: message.ext[kAliasName]?:@"",kAvatarUrl: message.ext[kAvatarUrl] ?:@""};
            [self.userDict setObject:user forKey:@(message.senderUID)];
        }
    }
    
    @synchronized (self.lock) {
        [self.p_messageList addObjectsFromArray:messages];
        [messages enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.messageDict[obj.uuid] = obj;
        }];
    }
}

- (void)loadNewerMessagesWithCompletionBlock:(void (^)(BIMError * _Nullable))completion
{
    int limit = self.pageSize ?: 20;
    @weakify(self);
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = limit;
        @synchronized (self.lock) {
            option.anchorMessage = self.messageList.firstObject ?: self.searchAnchorMessage;
        }
        [[BIMClient sharedInstance] getNewerMessageList:self.conversation.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (!error) {
                [self addNewerMessages:messages];
                self.hasNewerMessages = hasMore;
            }
            [self getMessagesReadReceipt:messages];
            dispatch_async(dispatch_get_main_queue(), ^{
                @synchronized (self.lock) {
                    self.messageList = [self.p_messageList copy];
                }
                if (completion) {
                    completion(error);
                }
            });
        }];
    }
}

- (void)addNewerMessages:(NSArray<BIMMessage *> *)messages {
    @synchronized (self.lock) {
        self.p_messageList = [messages arrayByAddingObjectsFromArray:self.p_messageList].mutableCopy;
        [messages enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.messageDict[obj.uuid] = obj;
        }];
    }
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
            [self getMessagesReadReceipt:messages];
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
            [self getMessagesReadReceipt:messages];
        }];
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @synchronized (self.lock) {
            [self.p_messageList addObjectsFromArray:newers];
            [self.p_messageList addObject:searchMessage];
            [self.p_messageList addObjectsFromArray:olders];
            [self.p_messageList enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                self.messageDict[obj.uuid] = obj;
            }];

            self.messageList = [self.p_messageList copy];
        }
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
    
    NSDictionary *oldUser = self.userDict[@(message.senderUID)];
    NSDictionary *newUser = @{kAliasName: message.ext[kAliasName]?:@"",kAvatarUrl: message.ext[kAvatarUrl] ?:@""};
    if (![oldUser isEqualToDictionary:newUser]) {
        [self.userDict setObject:newUser forKey:@(message.senderUID)];
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
    [self p_updateMessage:message];
}

/// 消息被修改（内容+扩展）
- (void)onUpdateMessage:(BIMMessage *)message
{
    [self p_updateMessage:message];
}

/// 发送消息入库完成
- (void)onSendMessage:(BIMMessage *)message
{
    [self p_insertMessage:message];
}

/// 收到消息已读回执
- (void)onReceiveReadReceipt:(NSArray<BIMReadReceipt *> *)receiptList
{
    [receiptList enumerateObjectsUsingBlock:^(BIMReadReceipt * _Nonnull receipt, NSUInteger idx, BOOL * _Nonnull stop) {
        [self p_updateMessage:receipt.message];
    }];
}

#pragma mark - Private

- (void)p_insertMessage:(BIMMessage *)message
{
    if (![self isCurrentConversationMessage:message]) {
        return;
    }
    @synchronized (self.lock) {
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
                return;
            }
            [self.p_messageList insertObject:message atIndex:0];
        }
        self.messageDict[message.uuid] = message;
    }
    [self sortMessageListWithScrollToBottom:YES];
}

- (void)p_updateMessage:(BIMMessage *)message
{
    if (![self isCurrentConversationMessage:message]) {
        return;
    }
    @synchronized (self.lock) {
        [self.messageList enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.uuid isEqualToString:message.uuid]) {
                [self.p_messageList replaceObjectAtIndex:idx withObject:message];
                self.messageDict[message.uuid] = obj;
                [self sortMessageListWithScrollToBottom:NO];
                *stop = YES;
            }
        }];
    }
}

- (void)p_deleteMessage:(NSString *)msgID
{
    @synchronized (self.lock) {
        for (BIMMessage *msg in self.messageList) {
            if ([msg.uuid isEqualToString:msgID]) {
                [self.p_messageList removeObject:msg];
                self.messageDict[msgID] = nil;
                [self sortMessageListWithScrollToBottom:NO];
                return;
            }
        }
    }
}

/// 获取消息已读回执
- (void)getMessagesReadReceipt:(NSArray<BIMMessage *> *)messages
{
    NSMutableArray<BIMMessage *> *needGetReceiptMessages = [NSMutableArray array];
    [messages enumerateObjectsUsingBlock:^(BIMMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 群聊消息在有已读情况下且没人未读时，不需要获取已读回执
        if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT && message.readCount != 0 && message.unReadCount == 0) {
            return;
        }
        [needGetReceiptMessages addObject:message];
    }];
    if (BTD_isEmptyArray(needGetReceiptMessages)) {
        return;
    }

    @weakify(self);
    [[BIMClient sharedInstance] getMessagesReadReceipt:[needGetReceiptMessages copy] completion:^(NSArray<BIMMessageReadReceipt *> * _Nullable receiptList, BIMError * _Nullable error) {
        @strongify(self);
        for (BIMMessageReadReceipt *receipt in receiptList) {
            @autoreleasepool {
                [self p_updateMessage:receipt.message];
            }
        }
    }];
}

#pragma mark -

- (void)sortMessageListWithScrollToBottom:(BOOL)scrollToBottom
{
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        @synchronized (self.lock) {
            [self.p_messageList sortUsingComparator:^NSComparisonResult(BIMMessage *obj1, BIMMessage *obj2) {
                return [@(obj2.orderIndex) compare:@(obj1.orderIndex)];
            }];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self.lock) {
            self.messageList = [self.p_messageList copy];
        }
        if ([self.delegate respondsToSelector:@selector(chatViewDataSourceDidReloadAllMessage:scrollToBottom:)]) {
            [self.delegate chatViewDataSourceDidReloadAllMessage:self scrollToBottom:scrollToBottom];
        }
    });
}

- (BOOL)isCurrentConversationMessage:(BIMMessage *)message {
    return [message.conversationID isEqualToString:self.conversation.conversationID];
}

@end
