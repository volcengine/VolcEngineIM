//
//ConversationListDataSource.m
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMConversationListDataSource.h"
#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BTDMacros.h>

@interface BIMConversationListDataSource () <BIMConversationListListener>

@property (nonatomic, assign) long long currentCursor;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) NSUInteger totalUnreadCount;

@property (nonatomic, strong) NSMutableArray<BIMConversation *> *chatList;

@property (nonatomic, strong) NSMutableDictionary *chatDict;

@property (nonatomic, strong) NSArray<BIMConversation *> *conversationList;

@end

@implementation BIMConversationListDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageSize = 100;
        _chatDict = [NSMutableDictionary dictionary];
        _chatList = [NSMutableArray array];
        [[BIMClient sharedInstance] addConversationListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeConversationListener:self];
    
}

#pragma mark - BIMConversationListListener

- (void)loadNexPageConversationsWithCompletion:(void (^)(NSError * _Nullable))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getConversationList:self.currentCursor count:self.pageSize completion:^(NSArray<BIMConversation *> * _Nonnull conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        @strongify(self);
        if (conversations.count) {
            self.currentCursor = nextCursor;
        }
        self.hasMore = hasMore;
        [self p_binaryInsertChatList:conversations];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(error);
            }
        });
    }];
}


- (void)onNewConversation:(NSArray<BIMConversation *> *)conversationList
{
    [self p_binaryInsertChatList:conversationList];
}

- (void)onConversationChanged:(NSArray<BIMConversation *> *)conversationList
{
    [self p_binaryInsertChatList:conversationList];
}

- (void)onConversationDeleted:(NSArray<NSString *> *)conversationIdList
{
    [self p_removeChatWithIdentifiers:conversationIdList];
}

- (void)onTotalUnreadMessageCountChanged:(UInt64)totalUnreadCount
{
    if (_totalUnreadCount == totalUnreadCount) {
        return;
    }
    _totalUnreadCount = totalUnreadCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(conversationDataSource:onTotalUnreadMessageCountChanged:)]) {
            [self.delegate conversationDataSource:self onTotalUnreadMessageCountChanged:totalUnreadCount];
        }
    });
}

#pragma mark -

- (void)p_binaryInsertChatList:(NSArray<BIMConversation *> *)conversationList
{
    if (!conversationList.count) {
        return;
    }
    //TODO:可以将增删改区分出来，更方便的做增量刷新
    for (BIMConversation *con in conversationList) {
        [self p_binaryInsertChat:con];
    }
    
    NSArray *list = [self.chatList copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.conversationList = list;
        if ([self.delegate respondsToSelector:@selector(conversationDataSourceDidReloadAllConversations:)]) {
            [self.delegate conversationDataSourceDidReloadAllConversations:self];
        }
    });
}

- (void)p_binaryInsertChat:(BIMConversation *)chat
{
    if (!chat || chat.conversationID == 0) {
        return;
    }
    
    BIMConversation *oldChat = self.chatDict[chat.conversationID];
    [self.chatDict setValue:chat forKey:chat.conversationID];
    [self.chatList removeObject:oldChat];
    NSInteger index = [self p_locationOfChatAtChatArray:chat];
    [self.chatList insertObject:chat atIndex:index];
}

- (NSInteger)p_locationOfChatAtChatArray:(BIMConversation *)chat {
    NSInteger left = 0;
    NSInteger right = self.chatList.count - 1;
    while (left <= right) {
        NSInteger mid = (left + right) / 2;
        BIMConversation *c = [self.chatList objectAtIndex:mid];
        if ([self p_chatA:chat greaterThanOrEqualToChatB:c]) {
            right = mid - 1;
        } else {
            left = mid +1;
        }
    }
    return left;
}

- (BOOL)p_chatA:(BIMConversation *)chatA greaterThanOrEqualToChatB:(BIMConversation *)chatB
{
    return chatA.sortOrder >= chatB.sortOrder;
}

- (void)p_removeChatWithIdentifiers:(NSArray<NSString *> *)conversationIdList
{
    for (NSString *conversationId in conversationIdList) {
        BIMConversation *con = self.chatDict[conversationId];
        [self.chatDict removeObjectForKey:conversationId];
        [self.chatList removeObject:con];
    }
    
    NSArray *list = [self.chatList copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.conversationList = list;
        if ([self.delegate respondsToSelector:@selector(conversationDataSourceDidReloadAllConversations:)]) {
            [self.delegate conversationDataSourceDidReloadAllConversations:self];
        }
    });
}

@end
