//
//  BIMFriendConversationListDataSource.m
//  Bolts
//
//  Created by hexi on 2023/11/19.
//

#import "BIMFriendConversationListDataSource.h"

#import "BIMConversationListManager.h"
#import "BIMConversationListDataSource.h"

#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMSDK.h>

@interface BIMFriendConversationListDataSource () <BIMConversationListListener, BIMConversationListManagerDelegate>

@property (nonatomic, assign) long long currentCursor;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) NSUInteger totalUnreadCount;

@property (nonatomic, strong) NSArray<BIMConversation *> *conversationList;

@property (nonatomic, strong) BIMConversationListManager *conversationListManager;

@end

@implementation BIMFriendConversationListDataSource 

@synthesize delegate = _delegate, pageSize = _pageSize;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageSize = 100;
        _conversationListManager = [[BIMConversationListManager alloc] init];
        _conversationListManager.delegate = self;
        [[BIMClient sharedInstance] addFriendConversationListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendConversationListener:self];
}

#pragma mark - BIMConversationListDataSourceProtocol

- (void)loadNexPageConversationsWithCompletion:(void (^ _Nullable)(BIMError * _Nullable))completion {
    @weakify(self);
    [[BIMClient sharedInstance] getFriendConversationList:self.currentCursor count:self.pageSize completion:^(NSArray<BIMConversation *> * _Nonnull conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
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

- (void)onNewConversation:(nonnull NSArray<BIMConversation *> *)conversationList {
    [self.conversationListManager binaryInsertChatList:conversationList];
}

- (void)onConversationChanged:(nonnull NSArray<BIMConversation *> *)conversationList { 
    [self.conversationListManager binaryInsertChatList:conversationList];
}

- (void)onConversationDeleted:(nonnull NSArray<NSString *> *)conversationIdList { 
    [self.conversationListManager removeChatWithIdentifiers:conversationIdList];
}

- (void)onTotalUnreadMessageCountChanged:(UInt64)totalUnreadCount { 
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

- (void)chatListDidProcessed:(NSArray<BIMConversation *> * _Nullable)chatList {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.conversationList = chatList;
        if ([self.delegate respondsToSelector:@selector(conversationDataSourceDidReloadAllConversations:)]) {
            [self.delegate conversationDataSourceDidReloadAllConversations:self];
        }
    });
}

@end
