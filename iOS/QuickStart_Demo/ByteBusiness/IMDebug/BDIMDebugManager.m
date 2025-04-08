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
#import "BDIMDebugDatabaseController.h"
#import <imsdk-tob/BIMSDK.h>
#import "SSDebugViewController.h"

@interface BDIMDebugManager ()
@property (nonatomic, strong) BDIMDebugDragButton *entrance;

//@property (nonatomic, strong) BDIMDebugMenuController *menu;
//
//@property (nonatomic, strong) NSMutableArray *itemModels;
//
@property (nonatomic, weak) UIViewController *showingVC;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [vc.view addSubview:self.entrance];
        self.entrance.hidden = NO;
    });
}

- (void)didClickEntrance: (UIButton *)btn{
//    [self prepareData];
//    [self showMenu];
    [SSDebugViewController showDebugVC];
}

//- (void)prepareData{
//    if (!self.itemModels) {
//        self.itemModels = [NSMutableArray array];
//        [self.itemModels addObject:[BDIMDebugMenuIconModel modelWithTitle:@"更改网络环境" icon:@"net" description:@"更改网络设置" enable:YES click:^{
//            BDIMDebugNetworkEnvironmentController *netVC = [[BDIMDebugNetworkEnvironmentController alloc] init];
//            [self.menu.navigationController pushViewController:netVC animated:YES];
//        }]];
//        
//#if __has_include(<FLEX/FLEX.h>)
//        [self.itemModels addObject:[BDIMDebugMenuIconModel modelWithTitle:@"Flex" icon:@"flex" description:@"打开flex调试" enable:YES click:^{
//            [[FLEXManager sharedManager] showExplorer];
//        }]];
//#endif
//        
//    }
//}

//- (void)showMenu{
//    if (!self.menu) {
//        self.menu = [[BDIMDebugMenuController alloc] init];
//    }
//    if (self.menu.view) {
//        [self.menu refreshWithItemModels:self.itemModels];
//    }
//    if ([self.showingVC isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *nav = (UINavigationController *)self.showingVC;
//        [nav pushViewController:self.menu animated:YES];
//    }else{
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.menu];
//        [self.showingVC presentViewController:nav animated:YES completion:nil];
//    }
//}

@end
