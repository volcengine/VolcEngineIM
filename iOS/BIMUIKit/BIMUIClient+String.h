//
//  BIMUIClient+String.h
//  im-uikit-tob
//
//  Created by yangzhanjiang on 2025/4/8.
//

#import "BIMUIClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface BIMUIClient ()
/**
 * @type api
 * @brief 登录服务器。
 * @param userIDSting 用户 ID。
 * @param token 用户 Token。
 * @param completion 登录完成回调，其中 `error` 参看 BIMErrorCode{@link #BIMErrorCode}。
 */
- (void)loginWithUIDString:(NSString *)userIDSting token:(NSString *)token completion:(BIMCompletion)completion;
@end

NS_ASSUME_NONNULL_END
