//
//  VEIMDemoFriendApplyListDataSource.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/28.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendApplyListDataSource.h"

#import <imsdk-tob/BIMClient+Friend.h>
#import <imsdk-tob/BIMClient+conversation.h>
#import <imsdk-tob/BIMConversation.h>
#import <OneKit/BTDMacros.h>

@interface VEIMDemoFriendApplyListDataSource () <BIMFriendListener>

@property (nonatomic, assign) long long currCursor;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, copy) NSArray<BIMFriendApplyInfo *> *friendApplyList;

@property (nonatomic, strong) NSMutableArray<BIMFriendApplyInfo *> *applyData;

@property (nonatomic, strong) NSMutableDictionary *applyDict;

@end

@implementation VEIMDemoFriendApplyListDataSource

- (instancetype)init
{
    if (self = [super init]) {
        _currCursor = INTMAX_MAX;
        _applyData = [NSMutableArray array];
        _applyDict = [NSMutableDictionary dictionary];
        [[BIMClient sharedInstance] addFriendListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendListener:self];
}

- (void)loadFriendApplyWithCompletion:(void (^)(NSError * _Nullable))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getFriendApplyList:self.currCursor limit:self.pageSize completion:^(NSArray<BIMFriendApplyInfo *> * _Nullable infos, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        @strongify(self);
        
        if (infos.count) {
            self.currCursor = nextCursor;
        }
        self.hasMore = hasMore;
        
        [self addToApplyDataWithFirendApplyInfos:infos position:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.friendApplyList = [self.applyData copy];
            if ([self.delegate respondsToSelector:@selector(friendApplyDataSourceDidReloadFriendApplyList:)]) {
                [self.delegate friendApplyDataSourceDidReloadFriendApplyList:self];
            }
            
            if (completion) {
                completion(error);
            }
        });
            
    }];
}

// 后续BOOL改成枚举,现状：yES：插到尾部。NO：插到头部
- (void)addToApplyDataWithFirendApplyInfos:(NSArray<BIMFriendApplyInfo *> *)friendApplyInfos position:(BOOL)position
{
    if (friendApplyInfos.count == 0) {
        return;
    }
    for (BIMFriendApplyInfo *info in friendApplyInfos) {
        if (!info.isSelf) {
            if ([[self.applyDict allKeys] containsObject:@(info.fromUid)]) {
                BIMFriendApplyInfo *oldInfo = [self.applyDict objectForKey:@(info.fromUid)];
                [self.applyData removeObject:oldInfo];
                [self.applyDict removeObjectForKey:@(info.fromUid)];
            }
            [self.applyDict setObject:info forKey:@(info.fromUid)];
            if (position) {
                [self.applyData addObject:info];
            } else {
                [self.applyData insertObject:info atIndex:0];
            }
        }
    }
}

- (void)updateApplyDataListWithFriendApplyInofos:(NSArray<BIMFriendApplyInfo *> *)friendApplyInfos
{
    if (friendApplyInfos.count == 0) {
        return;
    }
    for (BIMFriendApplyInfo *info in friendApplyInfos) {
        if (!info.isSelf) {
            BIMFriendApplyInfo *oldInfo = [self.applyDict objectForKey:@(info.fromUid)];
            NSInteger index = [self.applyData indexOfObject:oldInfo];
            [self.applyData replaceObjectAtIndex:index withObject:info];
            [self.applyDict setObject:info forKey:@(info.fromUid)];
        }
    }
}

#pragma mark - BIMFriendListener
- (void)onFriendApply:(BIMFriendApplyInfo *)applyInfo
{
    if (applyInfo.isSelf) {
        return;
    }
    [self addToApplyDataWithFirendApplyInfos:@[applyInfo] position:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.friendApplyList = [self.applyData copy];
        if ([self.delegate respondsToSelector:@selector(friendApplyDataSourceDidReloadFriendApplyList:)]) {
            [self.delegate friendApplyDataSourceDidReloadFriendApplyList:self];
        }
    });
}

- (void)onFriendApplyAgree:(BIMFriendApplyInfo *)applyInfo
{
    if (applyInfo.isSelf) {
        return;
    }
    [self updateApplyDataListWithFriendApplyInofos:@[applyInfo]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.friendApplyList = [self.applyData copy];
        if ([self.delegate respondsToSelector:@selector(friendApplyDataSourceDidReloadFriendApplyList:)]) {
            [self.delegate friendApplyDataSourceDidReloadFriendApplyList:self];
        }
        // 向对方发送一条消息 TODO: 后面这里可以移到别的位置
        [[BIMClient sharedInstance] createSingleConversation:@(applyInfo.fromUid) completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
            [[BIMClient sharedInstance] sendMessage:[[BIMClient sharedInstance] createTextMessage:@"我已通过你的好友申请"]  conversationId:conversation.conversationID saved:nil progress:nil completion:nil];
        }];
    });
    
}

- (void)onFriendApplyRefuse:(BIMFriendApplyInfo *)applyInfo
{
    if (applyInfo.isSelf) {
        return;
    }
    [self updateApplyDataListWithFriendApplyInofos:@[applyInfo]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.friendApplyList = [self.applyData copy];
        if ([self.delegate respondsToSelector:@selector(friendApplyDataSourceDidReloadFriendApplyList:)]) {
            [self.delegate friendApplyDataSourceDidReloadFriendApplyList:self];
        }
    });
}

@end
