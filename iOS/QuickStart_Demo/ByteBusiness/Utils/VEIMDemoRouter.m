//
//  VEIMDemoRouter.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/28.
//

#import "VEIMDemoRouter.h"
#import <OneKit/BTDResponder.h>
#import "VEIMDemoNavigationViewController.h"

@implementation VEIMDemoRouter

+ (instancetype)shared{
    static VEIMDemoRouter *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shared) {
            _shared = [[VEIMDemoRouter alloc] init];
        }
    });
    return _shared;
}

- (void)presentViewController:(UIViewController *)controller fullScreen:(BOOL)fullScreen animated:(BOOL)animated{
    if (fullScreen) {
        controller.modalPresentationStyle = 0;
    }
    
    UIViewController *vc = [BTDResponder topViewController];
    [vc presentViewController:controller animated:YES completion:nil];
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated{
    UINavigationController *nav = [BTDResponder topNavigationControllerForResponder:controller];
    if (!nav) {
        nav = [[VEIMDemoNavigationViewController alloc] initWithRootViewController:controller];
        [self presentViewController:nav fullScreen:YES animated:animated];
    }else{
        [nav pushViewController:controller animated:animated];
    }
}

- (void)dismiss:(UIViewController *)controller animated: (BOOL)animated{
    [controller closeWithAnimated:animated];
}
@end
