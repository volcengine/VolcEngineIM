//
//  VEIMDemoFriendBlackListDataSource.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/8/30.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendBlackListDataSource.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMClient+Friend.h>

@interface VEIMDemoFriendBlackListDataSource () <BIMFriendListener>

@property (nonatomic, copy) NSArray<BIMBlackListFriendInfo *> *blackList;

@property (nonatomic, strong) NSMutableArray<BIMBlackListFriendInfo *> *p_blackList;

@property (nonatomic, strong) NSMutableDictionary *p_blackListDict;

@property (nonatomic, strong) dispatch_queue_t blackListQueue;

@end

@implementation VEIMDemoFriendBlackListDataSource

- (instancetype)init
{
    if (self = [super init]) {
        _p_blackList = [[NSMutableArray alloc] init];
        _p_blackListDict = [[NSMutableDictionary alloc] init];
        
        _blackListQueue = dispatch_queue_create("blackList.operateQueue", DISPATCH_QUEUE_SERIAL);
        
        [[BIMClient sharedInstance] addFriendListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendListener:self];
}

- (void)loadBlackListWithCompletion:(void (^ _Nullable)(BIMError *_Nullable e))completion
{
    [self p_loadFriendBlackListWithCompletion:completion];
}


#pragma mark - BIMFriendListener

- (void)onBlackListAdd:(BIMBlackListFriendInfo *)blacklistFriendInfo
{
    [self p_addToBlackListWithBlackFriendInfo:@[blacklistFriendInfo]];
}

- (void)onBlackListDelete:(long long)uid
{
    [self p_removeFromBlackListWithBlackFriendId:uid];
}

//- (void)onBlackListUpdate:(BIMBlackListFriendInfo *)blacklistFriendInfo
//{
//
//}

#pragma mark - Private

// 获取全量黑名单列表
- (void)p_loadFriendBlackListWithCompletion:(void (^)(BIMError *_Nullable error))completion
{
    @weakify(self);
    [[BIMClient sharedInstance] getBlackListCompletion:^(NSArray<BIMBlackListFriendInfo *> * _Nullable infos, BIMError * _Nullable error) {
        @strongify(self);
        [self p_addToBlackListWithBlackFriendInfo:infos];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(error);
            }
        });
    }];
}

- (void)p_addToBlackListWithBlackFriendInfo:(NSArray<BIMBlackListFriendInfo *> *)blackFriendInfo
{
    dispatch_async(self.blackListQueue, ^{
        for (BIMBlackListFriendInfo *info in blackFriendInfo) {
            if ([[self.p_blackListDict allKeys] containsObject:@(info.uid)] ){
                continue;
            }
            [self.p_blackList addObject:info];
            [self.p_blackListDict setObject:info forKey:@(info.uid)];
        }
        
        self.blackList = [self.p_blackList copy];
        if ([self.delegate respondsToSelector:@selector(blackListDataSourceDidReloadBlackList:)]) {
            [self.delegate blackListDataSourceDidReloadBlackList:self];
        }
    });
}

- (void)p_removeFromBlackListWithBlackFriendId:(long long)blackFriendId
{
    dispatch_async(self.blackListQueue, ^{
//        if (![[self.p_blackListDict allKeys] containsObject:@(blackFriendId)]) {
//            return;
//        }
        BIMBlackListFriendInfo *blackInfo = self.p_blackListDict[@(blackFriendId)];
        if (!blackInfo) {
            return;
        }
        
        [self.p_blackList removeObject:blackInfo];
        [self.p_blackListDict removeObjectForKey:@(blackFriendId)];
        
        self.blackList = [self.p_blackList copy];
        if ([self.delegate respondsToSelector:@selector(blackListDataSourceDidReloadBlackList:)]) {
            [self.delegate blackListDataSourceDidReloadBlackList:self];
        }
    });
}



@end
