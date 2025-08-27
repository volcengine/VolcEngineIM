//
//  VEIMDemoTabbarController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//

#import "VEIMDemoTabbarController.h"
#import "BDIMDebugManager.h"
#if __has_include("VEIMDemoLiveGroupListController.h")
#import "VEIMDemoLiveGroupListController.h"
#endif

#import "VEIMDemoDefine.h"
#import "VEIMDemoUserManager.h"

#import "VEIMDemoNavigationViewController.h"
#import "VEIMDemoConversationListController.h"
#import "VEIMDemoMyinfoController.h"
#import "VEIMDemoFriendListController.h"
#import "VEIMDemoIMManager.h"

@interface VEIMDemoTabbarController ()

@end

@implementation VEIMDemoTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLoginNotification object:nil];
    
}

- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification]) {
        [self setSelectedIndex:0];
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = self.selectedViewController;
            [nav popToRootViewControllerAnimated:NO];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[VEIMDemoUserManager sharedManager] showLoginVCIfNeed];
}

- (void)setupTabBarItems
{
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    VEIMDemoConversationListController *conversationVC = [[VEIMDemoConversationListController alloc] init];
    [self addChildVc:conversationVC title:@"消息" image:@"tabbar_conversation_normal" selectedImage:@"tabbar_conversation_sel"];
    
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType == VEIMDemoAccountTypeInternal) {
#if __has_include("VEIMDemoLiveGroupListController.h")
    VEIMDemoLiveGroupListController *liveGroupVC = [[VEIMDemoLiveGroupListController alloc] init];
    [self addChildVc:liveGroupVC title:@"直播群" image:@"tabbar_livegroup_normal" selectedImage:@"tabbar_livegroup_sel"];
#endif
    }
    
    VEIMDemoFriendListController *friendListVC = [[VEIMDemoFriendListController alloc] init];
    [self addChildVc:friendListVC title:@"通讯录" image:@"tabbar_friendlist_normal" selectedImage:@"tabbar_friendlist_sel"];
    
    VEIMDemoMyinfoController *myInfo = [[VEIMDemoMyinfoController alloc] init];
    [self addChildVc:myInfo title:@"我的" image:@"tabbar_me_normal" selectedImage:@"tabbar_me_sel"];

    self.selectedIndex = 0;
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIImage *img = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImg = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (childVc.tabBarItem) {
        [childVc.tabBarItem setTitle:title];
        [childVc.tabBarItem setImage:img];
        [childVc.tabBarItem setSelectedImage:selectImg];
    } else {
        childVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:img selectedImage:selectImg];
    }
    VEIMDemoNavigationViewController *navController = [[VEIMDemoNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navController];
}

@end
