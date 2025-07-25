//
//  AppDelegate.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/25.
//

#import "AppDelegate.h"
#import "VEIMDemoIMManager.h"
#import "VEIMDemoUserManager.h"
#import <OneKit/UIImage+BTDAdditions.h>
#import <OneKit/OneKitApp.h>
#import <RangersAppLog/BDAutoTrackSchemeHandler.h>

#if __has_include(<imsdk-tob/BIMDebugManager.h>)
#import <imsdk-tob/BIMDebugManager.h>
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[UINavigationController.class]];
    
    // 2.设置导航栏的背景图片
    UIImage *backgroundImage = [UIImage btd_imageWithColor:[UIColor whiteColor]];
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundImage = backgroundImage;
        appearance.backgroundImageContentMode = UIViewContentModeScaleToFill;
        appearance.titleTextAttributes = titleTextAttributes;
        
        navBar.scrollEdgeAppearance = appearance;
        navBar.standardAppearance = appearance;
    } else {
        [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        // 3.标题
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    
    
    // 同意了隐私协议才能初始化SDK
    if ([VEIMDemoIMManager sharedManager].accountProvider.isAgreeUserPirvacyAgreement) {
        [self agreeUserPirvacyAgreement];
    } else {
        __weak typeof(self) weakSelf = self;
        [VEIMDemoIMManager sharedManager].accountProvider.agreeUserPirvacyAgreementCompletion = ^{
            [weakSelf agreeUserPirvacyAgreement];
        };
    }
    
    return YES;
}

- (void)agreeUserPirvacyAgreement {
    [OneKitApp startWithLaunchOptions:nil];
    [[VEIMDemoUserManager sharedManager] initSDK];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
#if __has_include(<imsdk-tob/BIMDebugManager.h>)
    if ([[BDAutoTrackSchemeHandler sharedHandler] handleURL:url appID:[BIMDebugManager sharedInstance].trackAppID scene:nil]) {
        return YES;
    }
#endif
    return NO;
}
@end
