//
//  VEIMDemoConversationListController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//


#import "VEIMDemoConversationListController.h"
#import "BIMConversationListController.h"
#import "VEIMDemoCommonMenu.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoUserSelectionController.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoChatViewController.h"
#import "VEIMDemoSelectUserViewController.h"
#import "BIMToastView.h"
#import <imsdk-tob/BIMSDK.h>

@interface VEIMDemoConversationListController () <VEIMDemoUserSelectionControllerDelegate, BIMConversationListControllerDelegate>
@property (nonatomic, strong) VEIMDemoCommonMenu *menu;
@end

@implementation VEIMDemoConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"IM Demo";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    
    BIMConversationListController *conListController = [[BIMConversationListController alloc] init];
    conListController.delegate = self;
    [self addChildViewController:conListController];
    [self.view addSubview:conListController.view];
}

- (void)rightBarItemClicked: (UIBarButtonItem *)item{
    if (!self.menu) {
        VEIMDemoCommonMenuItemModel *oneModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        oneModel.titleStr = @"发起单聊";
        oneModel.imgStr = @"icon_oneToOne";
        
        VEIMDemoCommonMenuItemModel *groupModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        groupModel.titleStr = @"发起群聊";
        groupModel.imgStr = @"icon_group";
        
        NSArray *ary = @[ oneModel, groupModel ];
        
        kWeakSelf(self);
        self.menu = [[VEIMDemoCommonMenu alloc] initWithListArray:ary selectBlock:^(NSInteger index) {
            [weakself clickMenu:index];
        }];
    }
    
    [self.menu show];
}

- (void)clickMenu: (NSInteger)index{
    VEIMDemoSelectUserViewController *vc = [[VEIMDemoSelectUserViewController alloc] init];
    vc.showType = VEIMDemoSelectUserShowTypeCreateChat;
    if (index == 0) {
        vc.conversationType = BIM_CONVERSATION_TYPE_ONE_CHAT;
        vc.title = @"发起单聊";
    } else if (index == 1) {
        vc.conversationType = BIM_CONVERSATION_TYPE_GROUP_CHAT;
        vc.title = @"发起群聊";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BIMConversationListControllerDelegate

- (void)conversationListController:(BIMConversationListController *)controller didSelectConversation:(BIMConversation *)conversation {
    VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)conversationListController:(BIMConversationListController *)controllerr onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount
{
    NSInteger total = totalUnreadCount;
    BOOL exceed = NO;
    if (total>99) {
        total = 99;
        exceed = YES;
    }
    
    self.tabBarItem.badgeValue = total>0?[NSString stringWithFormat:@"%zd%@",total,exceed?@"+":@""]:nil;
}

@end

