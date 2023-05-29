//
//  VEIMDemoLiveGroupListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoLiveGroupListController.h"

#import "VEIMDemoUserSelectionController.h"
#import "BIMConversationListController.h"
#import "BIMLiveGroupListController.h"
#import "VEIMDemoCommonMenu.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoCreateLiveGroupController.h"
#import "BIMToastView.h"
#import "VEIMDemoLiveGroupChatViewController.h"
#import "VEIMDemoAllLiveGroupListController.h"

#import <imsdk-tob/BIMClient+liveGroup.h>
#import <OneKit/BTDMacros.h>

@interface VEIMDemoLiveGroupListController () <VEIDemoCreateLiveGroupControllerDelegate, BIMLiveGroupListControllerDelegate>

@property (nonatomic, strong) VEIMDemoCommonMenu *menu;

@end

@implementation VEIMDemoLiveGroupListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"IMDemo 直播群";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    
    // TODO
    BIMLiveGroupListController *liveGroupListController = [[BIMLiveGroupListController alloc] initWithType:VEIMDemoLiveGroupListMain];
    liveGroupListController.delegate = self;
    [self addChildViewController:liveGroupListController];
    [self.view addSubview:liveGroupListController.view];
}

#pragma mark - 右上角“+”菜单
- (void)rightBarItemClicked:(UIBarButtonItem *)item
{
    if (!self.menu) {
        // 查看全部item
        VEIMDemoCommonMenuItemModel *checkALlModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        checkALlModel.titleStr = @"查看全部";
        checkALlModel.imgStr = @"icon_search2";
        
        // 创建直播群item
        VEIMDemoCommonMenuItemModel *createLiveGroupModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        createLiveGroupModel.titleStr = @"创建直播群";
        createLiveGroupModel.imgStr = @"icon_group";
        
        NSArray *arry = @[checkALlModel, createLiveGroupModel];
        
        kWeakSelf(self);
        self.menu = [[VEIMDemoCommonMenu alloc] initWithListArray:arry selectBlock:^(NSInteger index) {
            kStrongSelf(self);
            [self clickMenu:index];
        }];
    }
    [self.menu show];
}

- (void)clickMenu:(NSInteger)index
{
    // 创建直播群VC
    if (index == 1) {
        VEIMDemoCreateLiveGroupController *createLiveGroupVC = [[VEIMDemoCreateLiveGroupController alloc] init];
        createLiveGroupVC.delegate = self;
        [self.navigationController pushViewController:createLiveGroupVC animated:YES];
    }
    // 查看全部直播群VC
    else {
        VEIMDemoAllLiveGroupListController *allLiveGroupVC = [[VEIMDemoAllLiveGroupListController alloc] init];
        [self.navigationController pushViewController:allLiveGroupVC animated:YES];
//        VEIMDemoAllLiveGroupListController *allLiveGroupVC = [[VEIMDemoAllLiveGroupListController alloc] initWithLiveGroups:];
//        [self.navigationController pushViewController:allLiveGroupVC animated:YES];
    }
}

#pragma mark - VEIMDemoCreateLiveGroupControllerDelegat

- (void)createLiveGroupWithInfo:(BIMGroupInfo *)groupInfo
{
    @weakify(self);
    [[BIMClient sharedInstance] createLiveGroup:groupInfo completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"创建直播群失败：%@", error.localizedDescription]];
        } else {
            // 更新直播群tab list
            [[NSNotificationCenter defaultCenter] postNotificationName:@"createLiveGroupSucess" object:conversation];
            // 加入直播群
            [self joinLiveGroup:conversation];
        }
    }];
}

#pragma mark - BIMLiveGroupListControllerDelegate
 - (void)liveGroupListController:(BIMLiveGroupListController *)controller didSelectLiveGroup:(BIMConversation *)liveGroup
{
    [self joinLiveGroup:liveGroup];
}

- (void)joinLiveGroup:(BIMConversation *)liveGroup
{
    [[BIMClient sharedInstance] joinLiveGroup:liveGroup.conversationID completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"加入直播群失败：%@", error.localizedDescription]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 跳入直播群聊天页面
                VEIMDemoLiveGroupChatViewController *chatVC = [VEIMDemoLiveGroupChatViewController liveGroupChatVCWithConversation:conversation];
                [self.navigationController pushViewController:chatVC animated:YES];
            });
        }
    }];
}

@end
