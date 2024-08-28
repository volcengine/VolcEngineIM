//
//  VEIMDemoAccountManager.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/6/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoAccountManager.h"
#import "VEIMDemoLoginViewController.h"
#import "VEIMDemoRouter.h"
#import <OneKit/BTDResponder.h>

@interface VEIMDemoAccountManager ()

@end

@implementation VEIMDemoAccountManager

+ (instancetype)sharedManager{
    static VEIMDemoAccountManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[VEIMDemoAccountManager alloc] init];
        }
    });
    return _sharedInstance;
}

- (BOOL)isAgreeUserPirvacyAgreement
{
    return YES;
}

- (void)agreeUserPirvacyAgreement
{
    
}

- (void)showLoginVC
{
    if ([[BTDResponder topViewController] isKindOfClass:VEIMDemoLoginViewController.class]) {//迁移debug按钮到登录页
        return;
    }
    VEIMDemoLoginViewController *loginVC = [[VEIMDemoLoginViewController alloc] init];
    [[VEIMDemoRouter shared] presentViewController:loginVC fullScreen:YES animated:YES];
}

- (void)checkUserExist:(long long)uid completion:(void (^)(BOOL exist, NSError *error))completion;
{
    if (completion) {
        completion(YES, nil);
    }
}

@end
