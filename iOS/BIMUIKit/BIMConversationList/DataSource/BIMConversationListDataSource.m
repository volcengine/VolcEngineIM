//
//ConversationListDataSource.m
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMConversationListDataSource.h"
#import "BIMConversationListManager.h"
#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BTDMacros.h>
#import <OneKit/NSArray+BTDAdditions.h>

@interface BIMConversationListDataSource () <BIMConversationListListener, BIMConversationListManagerDelegate, BIMMessageListener>

@property (nonatomic, assign) long long currentCursor;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) NSUInteger totalUnreadCount;

@property (nonatomic, strong) NSArray<BIMConversation *> *conversationList;

@property (nonatomic, strong) BIMConversationListManager *conversationListManager;

@end

@implementation BIMConversationListDataSource

@synthesize delegate = _delegate, pageSize = _pageSize, filterBlock = _filterBlock;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageSize = 100;
        _conversationListManager = [[BIMConversationListManager alloc] init];
        _conversationListManager.delegate = self;
        [[BIMClient sharedInstance] addConversationListener:self];
        [[BIMClient sharedInstance] addMessageListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeConversationListener:self];
    [[BIMClient sharedInstance] removeMessageListener:self];
}

#pragma mark - BIMConversationListDataSourceProtocol

- (void)loadNexPageConversationsWithCompletion:(void (^)(BIMError * _Nullable))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getConversationList:self.currentCursor count:self.pageSize completion:^(NSArray<BIMConversation *> * _Nonnull conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        @strongify(self);
        if (conversations.count) {
            self.currentCursor = nextCursor;
        }
        self.hasMore = hasMore;
        [self.conversationListManager binaryInsertChatList:conversations];

        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(error);
        });
    }];
}

#pragma mark - BIMConversationListListener

- (void)onNewConversation:(NSArray<BIMConversation *> *)conversationList
{
    [self.conversationListManager binaryInsertChatList:conversationList];
}

- (void)onConversationChanged:(NSArray<BIMConversation *> *)conversationList
{
    [self.conversationListManager binaryInsertChatList:conversationList];
}

- (void)onConversationDeleted:(NSArray<NSString *> *)conversationIdList
{
    [self.conversationListManager removeChatWithIdentifiers:conversationIdList];
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

#pragma mark - BIMConversationListManagerDelegate

- (void)chatListDidProcessed:(NSArray<BIMConversation *> *)chatList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.conversationList = chatList;
        if ([self.delegate respondsToSelector:@selector(conversationDataSourceDidReloadAllConversations:)]) {
            [self.delegate conversationDataSourceDidReloadAllConversations:self];
        }
    });
}

- (BOOL)filterConversation:(BIMConversation *)conversation
{
    if (!self.filterBlock) {
        return YES;
    }
    return self.filterBlock(conversation);
}

#pragma mark - BIMMessageListener

- (void)onUpdateMessage:(BIMMessage *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(conversationDataSourceDidReloadAllConversations:)]) {
            [self.delegate conversationDataSourceDidReloadAllConversations:self];
        }
    });
}

@end
