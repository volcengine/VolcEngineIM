//
//  VEIMDemoIMManager.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/2.
//

#import "VEIMDemoIMManager.h"
#import "VEIMDemoDefine.h"
#import "BDIMDebugNetworkManager.h"
#import "VEIMDemoUserManager.h"
#if __has_include("SSDebugManager.h")
#import "SSDebugManager.h"
#endif
#import "VEIMDemoAccountManager.h"

#import <OneKit/UIDevice+BTDAdditions.h>

@interface VEIMDemoIMManager ()

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *installID;
@property (nonatomic, weak) id<VEIMDemoAccountProtocol> accountProvider;

@end


@implementation VEIMDemoIMManager

+ (instancetype)sharedManager{
    static VEIMDemoIMManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[VEIMDemoIMManager alloc] init];
        }
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self updateAccountProvider];
    }
    return self;
}

- (void)updateAccountProvider
{
    Class cls;
    BOOL isUidLogin = NO;
    
#if __has_include("SSDebugManager.h")
    isUidLogin = [SSDebugManager sharedInstance].uidLogin;
#endif
    if (isUidLogin) {
        cls = NSClassFromString(@"VEIMDemoUIDAccountManager");
    } else {
        cls = NSClassFromString(@"VEIMDemoSMSAccountManager");
    }
    if (cls) {
        self.accountProvider = [cls performSelector:@selector(sharedManager)];
    } else {
        self.accountProvider = [VEIMDemoAccountManager sharedManager];
    }
}
@end
