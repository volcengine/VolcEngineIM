//
//  VEIMDemoDefine.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import "BIMUIDefine.h"
#import <OneKit/BTDMacros.h>

#ifndef VEIMDemoDefine_h
#define VEIMDemoDefine_h


///IM config
//////从[控制台](https://console.volcengine.com/rtc/im/appManage)获取的应用 ID。
#define kVEIMDemoAppID  @""
#define kVEIMDemoToken @""
#define kVEIMDemoUserID @""

///Error
#define kVEIMDemoErrorDomain @"VEIMDemoErrorDomain"

///Account
#define kVEIMDemoUserDidLoginNotification @"kVEIMDemoUserDidLoginNotification"
#define kVEIMDemoUserDidLogoutNotification @"kVEIMDemoUserDidLogoutNotification"
#define kVEIMDemoUserUserdefaultKey @"kVEIMDemoUserUserdefaultKey"

/// Agreement
#define kVEIMDemoUserAgreement @"https://www.volcengine.com/docs/6348/975891"
#define kVEIMDemoPrivacyAgreement @"https://www.volcengine.com/docs/6348/975890"
#define kVEIMDemoPermissionList @"https://www.volcengine.com/docs/6348/975909"
#define kVEIMDemoICP @"https://beian.miit.gov.cn"

#define kVEIMDemoUIDLength 19


typedef enum : NSUInteger {
    VEIMDemoErrorTypeFormatError = 3200,
    VEIMDemoErrorTypeNetworkError,
    VEIMDemoErrorTypeParamsError,
    VEIMDemoErrorTypeRequestError,
} VEIMDemoErrorType;

typedef NS_ENUM(NSInteger, VEIMDemoChatType) {
    VEIMDemoChatTypeSingle,       /// 单聊
    VEIMDemoChatTypeGroup,       /// 群聊
};

typedef NS_ENUM(NSUInteger, VEIMDemoLiveGroupListType) {
    VEIMDemoLiveGroupListMain = 0,
    VEIMDemoLiveGroupListAll = 1,
};

#endif /* VEIMDemoDefine_h */
