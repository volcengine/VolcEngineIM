//
//  BIMFriendListDataSource.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMFriendListDataSource.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BTDMacros.h>

@interface BIMFriendListDataSource () <BIMFriendListener>

@property (nonatomic, copy) NSArray<BIMUserFullInfo *> *friendList;

@property (nonatomic, strong) NSMutableArray<BIMUserFullInfo *> *p_friendList;

@property (nonatomic, strong) NSMutableDictionary *p_friendDict;

@property (atomic, assign) NSInteger unreadCount;

@property (nonatomic, strong) dispatch_queue_t friendListQueue;

@end

@implementation BIMFriendListDataSource

- (instancetype)init
{
    if (self = [super init]) {
        _p_friendList = [[NSMutableArray alloc] init];
        _p_friendDict = [[NSMutableDictionary alloc] init];
        
        _friendListQueue = dispatch_queue_create("friendList.operateQueue", DISPATCH_QUEUE_SERIAL);
        
        [[BIMClient sharedInstance] addFriendListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendListener:self];
}

- (void)loadFriendListWithCompletion:(void(^)(NSError *_Nullable))completion
{
    [self p_loadFriendListWithCompletion:completion];
}

- (void)getFriendApplyUnreadCount
{
    [self p_getFriendApplyUnreadCount];
}

#pragma mark - BIMFriendListener

// 同意好友申请回调
- (void)onFriendAdd:(BIMUserFullInfo *)info
{
    [self p_addFriendToListWithFriendInfo:@[info]];
}

// 好友申请未读变化回调
- (void)onFriendApplyUnreadCountChanged:(long long)count {
    if (self.unreadCount == count) {
        return;
    }
    self.unreadCount = count;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(friendListDataSource:onApplyUnreadCountChanged:)]) {
            [self.delegate friendListDataSource:self onApplyUnreadCountChanged:count];
        }
    });
}

// 删除好友回调
- (void)onFriendDelete:(long long)uid {
    [self p_removeFriendFromWithFriendId:uid];
}

// 修改好友信息回调
- (void)onFriendUpdate:(BIMUserFullInfo *)info
{
    [self p_updateFriendWithFriendInfo:info];
}

#pragma mark - Private
// 获取全部好友列表
- (void)p_loadFriendListWithCompletion:(void(^)(NSError *_Nullable))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getFriendListCompletion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {
        @strongify(self);
        [self p_addFriendToListWithFriendInfo:infos];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(error);
            }
        });
    }];
    
}

// 获取好友申请未读
- (void)p_getFriendApplyUnreadCount
{
    @weakify(self);
    [[BIMClient sharedInstance] getFriendApplyUnreadCount:^(long long unreadCount, BIMError * _Nullable error) {
        @strongify(self);
        if (!error) {
            self.unreadCount = unreadCount;
        }
    }];
}

- (void)p_addFriendToListWithFriendInfo:(NSArray<BIMUserFullInfo *> *)friendInfo
{
    dispatch_async(self.friendListQueue, ^{
        for (BIMUserFullInfo *info in friendInfo) {
            if ([[self.p_friendDict allKeys] containsObject:@(info.uid).stringValue]) {
                continue;
            }
            [self.p_friendList addObject:info];
            [self.p_friendDict setObject:info forKey:@(info.uid).stringValue];
        }

        self.friendList = [self.p_friendList copy];
        if ([self.delegate respondsToSelector:@selector(friendListDataSourceDidReloadFriendList:)]) {
            [self.delegate friendListDataSourceDidReloadFriendList:self];
        }
    });
}

- (void)p_removeFriendFromWithFriendId:(long long)friendId
{
    dispatch_async(self.friendListQueue, ^{
        if (![[self.p_friendDict allKeys] containsObject:@(friendId).stringValue]) {
            return;
        }
        BIMUserFullInfo *friendInfo = self.p_friendDict[@(friendId).stringValue];
        [self.p_friendList removeObject:friendInfo];
        [self.p_friendDict removeObjectForKey:@(friendId).stringValue];
        
//        NSArray *list = [self.p_friendList copy];

        self.friendList = [self.p_friendList copy];
        if ([self.delegate respondsToSelector:@selector(friendListDataSourceDidReloadFriendList:)]) {
            [self.delegate friendListDataSourceDidReloadFriendList:self];
        }
    });
}

- (void)p_updateFriendWithFriendInfo:(BIMUserFullInfo *)friendInfo
{
    dispatch_async(self.friendListQueue, ^{
        if (!self.p_friendDict[@(friendInfo.uid).stringValue]) {
            return;
        }
        BIMUserFullInfo *oldFriendInfo = self.p_friendDict[@(friendInfo.uid).stringValue];
        [self.p_friendDict setObject:friendInfo forKey:@(friendInfo.uid).stringValue];
        [self.p_friendList removeObject:oldFriendInfo];
        [self.p_friendList addObject:friendInfo];
        
        self.friendList = [self.p_friendList copy];
        if ([self.delegate respondsToSelector:@selector(friendListDataSourceDidReloadFriendList:)]) {
            [self.delegate friendListDataSourceDidReloadFriendList:self];
        }
    });
}

@end
