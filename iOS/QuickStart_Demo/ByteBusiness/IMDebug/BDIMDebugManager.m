//
//  BDIMDebugManager.m
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugManager.h"
#import "BDIMDebugDragButton.h"
#import "BDIMDebugMenuController.h"
#import "BDIMDebugNetworkEnvironmentController.h"
#if __has_include(<FLEX/FLEX.h>)
#import <FLEX/FLEX.h>
#endif
#import "BDIMDebugNetworkManager.h"
#import <imsdk-tob/BIMSDK.h>

#if __has_include("SSDebugViewController")
#import "SSDebugViewController.h"
#endif


@interface BDIMDebugManager ()
@property (nonatomic, strong) BDIMDebugDragButton *entrance;

@property (nonatomic, weak) UIViewController *showingVC;

@property (nonatomic, strong) UIWindow *topWindow;

@end

@implementation BDIMDebugManager

+ (instancetype)sharedManager{
    static BDIMDebugManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BDIMDebugManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [BDIMDebugNetworkManager sharedManager];
    }
    return self;
}


- (void)showDebugEntrance:(UIViewController *)vc{
    if (self.entrance) {
        [self.entrance removeFromSuperview];
    }else{
        BDIMDebugDragButton *entrance = [BDIMDebugDragButton buttonWithType:UIButtonTypeCustom];
        entrance.frame = CGRectMake(8, 100, 60, 45);
        [entrance addTarget:self action:@selector(didClickEntrance:) forControlEvents:UIControlEventTouchUpInside];
        self.entrance = entrance;
    }
    self.showingVC = vc;

    [vc.view addSubview:self.entrance];
    self.entrance.hidden = NO;
}

- (void)didClickEntrance: (UIButton *)btn{
    [self showDebugVC];
}

- (void)showDebugVC
{
#if __has_include("SSDebugViewController")
    [SSDebugViewController showDebugVC];
#endif
}

@end
