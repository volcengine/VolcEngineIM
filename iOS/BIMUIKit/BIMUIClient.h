//
//  BIMUIClient.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/2/21.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <imsdk-tob/BIMSDK.h>
#import "BIMUser.h"

typedef BIMUser *_Nullable(^BIMUserProvider)(long long userID);

NS_ASSUME_NONNULL_BEGIN

@interface BIMUIClient : NSObject
/**
 *  获取 BIMUIClient 单例
 *
 *  @return BIMClient 单例
 */
+ (instancetype)sharedInstance;

/**
 * @type api
 * @brief 初始化 SDK。
 * @param sdkAppID 从[控制台](https://console.volcengine.com/rtc/im/appManage)获取的应用 ID。
 *                 不同应用 ID 无法进行互通。
 * @param config 配置信息，参看 BIMSDKConfig{@link #BIMSDKConfig}。
 * @return  <br>
 *        + `true`: 成功。
 *        + `false`: 失败。
 */
- (BOOL)initSDK:(int)sdkAppID config:(BIMSDKConfig *)config;

/**
 * @type api
 * @brief 注销 SDK，释放内存缓存资源、注销监听等。
 */
- (void)unInitSDK;

/**
 * @type api
 * @brief 登录服务器。
 * @param userID 用户 ID。
 * @param token 用户 Token。
 * @param completion 登录完成回调，其中 `error` 参看 BIMErrorCode{@link #BIMErrorCode}。
 */
- (void)login:(NSString *)userID token:(NSString *)token completion:(BIMCompletion)completion;

/**
 * @type api
 * @brief 登出服务器。
 * @param completion 登出完成回调，其中 `error` 参看 BIMErrorCode{@link #BIMErrorCode}。
 */
- (void)logoutWithCompletion:(BIMCompletion)completion;

/**
 * @brief 用户信息provider。
 */
@property (nonatomic, copy) BIMUserProvider userProvider;

@end

NS_ASSUME_NONNULL_END


