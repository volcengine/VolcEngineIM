//
//  BIMUIClient.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/2/21.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMUIClient.h"
#import "BIMUIDefine.h"

@implementation BIMUIClient

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userProvider = ^BIMUser * _Nullable(long long userID) {
            return nil;
        };
    }
    return self;
}


- (BOOL)initSDK:(int)sdkAppID config:(BIMSDKConfig *)config
{
    if (sdkAppID == 0) {
        NSAssert(sdkAppID != 0, @"从[控制台](https://console.volcengine.com/rtc/im/appManage)获取的应用 ID");
        return NO;
    }
    return [[BIMClient sharedInstance] initSDK:sdkAppID config:config];
}


- (void)unInitSDK
{
    [[BIMClient sharedInstance] unInitSDK];
}


- (void)login:(NSString *)userID token:(NSString *)token completion:(BIMCompletion)completion
{
    [[BIMClient sharedInstance] login:userID token:token completion:^(BIMError * _Nullable error) {
        if (completion) {
            completion(error);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLoginNotification object:nil];
    }];
}

/**
 * @type api
 * @brief 登出服务器。
 * @param completion 登出完成回调，其中 `error` 参看 BIMErrorCode{@link #BIMErrorCode}。
 */
- (void)logoutWithCompletion:(BIMCompletion)completion
{
    [[BIMClient sharedInstance] logoutWithCompletion:^(BIMError * _Nullable error) {
        if (completion) {
            completion(error);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotification object:nil];
    }];
}
@end
