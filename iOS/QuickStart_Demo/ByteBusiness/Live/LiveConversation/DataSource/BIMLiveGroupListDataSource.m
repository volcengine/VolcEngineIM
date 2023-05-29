//
//  BIMLiveGroupListDataSource.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMLiveGroupListDataSource.h"
#import "VEIMDemoDefine.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BTDMacros.h>

@interface BIMLiveGroupListDataSource () <BIMLiveConversationListener>

@property(nonatomic, assign) long long currentSortOrder;

@property(nonatomic, assign) BOOL hasMore;

@property(nonatomic, strong) NSMutableArray<BIMConversation *> *chatList;

@property(nonatomic, strong) NSMutableDictionary *chatDict;

@property(nonatomic, copy) NSArray<BIMConversation *> *liveGroupList;

@end

@implementation BIMLiveGroupListDataSource

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _pageSize = 100;
//        _chatList = [[NSMutableArray alloc] init];
//        _chatDict = [[NSMutableDictionary alloc] init];
//        [[BIMClient sharedInstance] addConversationListener:self];
//    }
//    return self;
//}

- (instancetype)initWithType:(VEIMDemoLiveGroupListType)type
{
    if (self = [super init]) {
        _type = type;
        _pageSize = 100;
        _chatList = [[NSMutableArray alloc] init];
        _chatDict = [[NSMutableDictionary alloc] init];
        [[BIMClient sharedInstance] addLiveConversationListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeLiveConversationListener:self];
}

#pragma mark - BIMConversationListListener
- (void)loadNexPageLiveGroupWithCompletion:(void(^)(NSError *_Nullable))completion
{
    if (self.type == VEIMDemoLiveGroupListMain) {
        [self p_getLiveGroupListWithCompletion:completion];
    } else {
        [self p_getAllLiveGroupListWithCompletion:completion];
    }
}

- (void)updateLiveGroupWithConv:(BIMConversation *)conv
{
    @weakify(self);
    [[BIMClient sharedInstance] getLiveGroup:[NSString stringWithFormat:@"%@", conv.conversationShortID] completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        @strongify(self);
        if (!error) {
//            NSArray<BIMConversation *> *list = [NSArray arrayWithObject:conversation];
//            [self p_binaryInsertChatList:list];
            BIMConversation * oldChat = self.chatDict[conversation.conversationID];
            [self.chatDict setValue:conversation forKey:conversation.conversationID];
            NSInteger index = [self.chatList indexOfObjectIdenticalTo:oldChat];
            [self.chatList removeObject:oldChat];
            [self.chatList insertObject:conversation atIndex:index];
            
            NSArray *list = [self.chatList copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.liveGroupList = list;
                if ([self.delegate respondsToSelector:@selector(liveGroupDataSourceDidReloadAllLiveGroup:)]) {
                    [self.delegate liveGroupDataSourceDidReloadAllLiveGroup:self];
                }
            });
        }
    }];
}

- (void)addLiveGroupToListWithConv:(BIMConversation *)conv
{
    [self p_binaryInsertChat:conv];
    NSArray *list = [self.chatList copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.liveGroupList = [list copy];
        if ([self.delegate respondsToSelector:@selector(liveGroupDataSourceDidReloadAllLiveGroup:)]) {
            [self.delegate liveGroupDataSourceDidReloadAllLiveGroup:self];
        }
    });
}

- (void)removeLiveGroupFromListWith:(BIMConversation *)conv
{
    [self p_removeChatWithIdentifiers:@[conv.conversationID]];
}

//- (void)onNewConversation:(NSArray<BIMConversation *> *)conversationList
//{
//    [self p_binaryInsertChatList:conversationList];
//}
//
//- (void)onConversationChanged:(NSArray<BIMConversation *> *)conversationList
//{
//    [self p_binaryInsertChatList:conversationList];
//}
//
//- (void)onConversationDeleted:(NSArray<NSString *> *)conversationIdList
//{
//    [self p_removeChatWithIdentifiers:conversationIdList];
//}

- (void)onConversationChanged:(BIMConversation *)conversation
{
    if (conversation.isDissolved) {
        [self p_removeChatWithIdentifiers:@[conversation.conversationID]];
    }
}

// 获取直播群列表
- (void)p_getLiveGroupListWithCompletion:(void(^)(NSError *_Nullable))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getOwnerLiveGroupList:self.currentSortOrder count:self.pageSize completion:^(NSArray<BIMConversation *> * _Nullable conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        @strongify(self);
        if (conversations.count) {
            self.currentSortOrder = nextCursor;
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

// 获取全部直播群列表
- (void)p_getAllLiveGroupListWithCompletion:(void(^)(NSError *_Nullable))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getALLLiveGroupList:self.currentSortOrder count:self.pageSize completion:^(NSArray<BIMConversation *> * _Nullable conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        @strongify(self);
        if (conversations.count) {
            self.currentSortOrder = nextCursor;
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
        self.liveGroupList = list;
        if ([self.delegate respondsToSelector:@selector(liveGroupDataSourceDidReloadAllLiveGroup:)]) {
            [self.delegate liveGroupDataSourceDidReloadAllLiveGroup:self];
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
    return chatA.sortOrder > chatB.sortOrder;
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
        self.liveGroupList = list;
        if ([self.delegate respondsToSelector:@selector(liveGroupDataSourceDidReloadAllLiveGroup:)]) {
            [self.delegate liveGroupDataSourceDidReloadAllLiveGroup:self];
        }
    });
}



@end
