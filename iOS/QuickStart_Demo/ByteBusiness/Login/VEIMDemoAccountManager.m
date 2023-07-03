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

- (void)showLoginVC
{
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
