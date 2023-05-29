//
//  VEIMDemoAllLiveGroupListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/24.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoAllLiveGroupListController.h"
#import "BIMLiveGroupListController.h"
#import "VEIMDemoLiveGroupChatViewController.h"
#import "BIMLiveGroupCell.h"
#import "VEIMDemoDefine.h"
#import "BIMToastView.h"

#import <imsdk-tob/BIMClient+liveGroup.h>
#import <imsdk-tob/BIMConversation.h>
#import <imsdk-tob/BIMSDK.h>

@interface VEIMDemoAllLiveGroupListController () <BIMLiveGroupListControllerDelegate>

@end

@implementation VEIMDemoAllLiveGroupListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"全部直播群";
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    BIMLiveGroupListController *liveGroupListController = [[BIMLiveGroupListController alloc] initWithType:VEIMDemoLiveGroupListAll];
    liveGroupListController.delegate = self;
    liveGroupListController.listType = VEIMDemoLiveGroupListAll;
    [self addChildViewController:liveGroupListController];
    [self.view addSubview:liveGroupListController.view];
}

- (void)backBtnClicked:(id)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
