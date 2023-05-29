//
//  VEIMDemoTabbarController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//

#import "VEIMDemoTabbarController.h"
#import "VEIMDemoNavigationViewController.h"
#import "BDIMDebugManager.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoConversationListController.h"
#import "VEIMDemoMyinfoController.h"
#import "VEIMDemoDefine.h"
#import "BIMUnreadLabel.h"
//#import "VEIMDemoLiveGroupListController.h"

#import <Masonry/Masonry.h>

@interface VEIMDemoTabbarController ()

@property (nonatomic, strong) BIMUnreadLabel *totalUnread;

@end

@implementation VEIMDemoTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarItems];
    
    
//    [[BDIMDebugManager sharedManager] showDebugEntrance:self];
    
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
    //    IM_PagingConversationViewController *pagingConversationVC = [[IM_PagingConversationViewController alloc] init];
    //    [self addChildVc:pagingConversationVC title:@"分页会话" image:@"tabbar_conversation_normal" selectedImage:@"buhuangtabbar_conversation_sel"];
    
    VEIMDemoConversationListController *conversationVC = [[VEIMDemoConversationListController alloc] init];
    [self addChildVc:conversationVC title:@"消息" image:@"tabbar_conversation_normal" selectedImage:@"tabbar_conversation_sel"];
    
//    VEIMDemoLiveGroupListController *liveGroupVC = [[VEIMDemoLiveGroupListController alloc] init];
//    [self addChildVc:liveGroupVC title:@"直播群" image:@"tabbar_livegroup_normal" selectedImage:@"tabbar_livegroup_sel"];
    
    VEIMDemoMyinfoController *myInfo = [[VEIMDemoMyinfoController alloc] init];
    [self addChildVc:myInfo title:@"我的" image:@"tabbar_me_normal" selectedImage:@"tabbar_me_sel"];
//
//    IM_FriendViewController *friendVC = [[IM_FriendViewController alloc] init];
//    [self addChildVc:friendVC title:@"好友" image:@"tabbar_conversation_normal" selectedImage:@"tabbar_conversation_sel"];
//
//    IM_MineViewController *meVC = [[IM_MineViewController alloc] init];
//    [self addChildVc:meVC title:@"我的" image:@"tabbar_me_normal" selectedImage:@"tabbar_me_sel"];

    self.selectedIndex = 0;
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    ////    childVc.title = title;
    UIImage *img = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImg = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:img selectedImage:selectImg];
    //    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    VEIMDemoNavigationViewController *navController = [[VEIMDemoNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navController];
}

@end
