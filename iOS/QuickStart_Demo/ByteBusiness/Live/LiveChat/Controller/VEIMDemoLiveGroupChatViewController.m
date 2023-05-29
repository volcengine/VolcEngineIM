//
//  VEIMDemoLiveGroupChatViewController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/24.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoLiveGroupChatViewController.h"
#import "VEIMDemoDefine.h"
#import "BIMChatViewController.h"
#import "VEIMDemoLiveGroupChatTitleView.h"
#import "VEIMDemoLiveGroupSettingViewController.h"
#import "VEIMDemoUserManager.h"

#import <imsdk-tob/BIMSDK.h>

@interface VEIMDemoLiveGroupChatViewController ()<BIMLiveConversationListener, BIMLiveMessageListener>

@property(nonatomic, strong) BIMConversation *conversation;

@end

@implementation VEIMDemoLiveGroupChatViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[BIMClient sharedInstance] addLiveConversationListener:self];
        
        [[BIMClient sharedInstance] addLiveGroupMessageListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeLiveConversationListener:self];
    [[BIMClient sharedInstance] removeLiveGroupMessageListener:self];
    [[BIMClient sharedInstance] leaveLiveGroup:self.conversation.conversationID completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreInfoClicked:)];
    self.navigationItem.rightBarButtonItem = moreBtn;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked:)];
    
    self.navigationItem.titleView = [[VEIMDemoLiveGroupChatTitleView alloc] initWithTitle:self.conversation.name onlineUsrNum:self.conversation.onlineMemberCount];
    
    // 创建BIMLiveGroupChatVC
    BIMChatViewController *liveGroupChatVC = [BIMChatViewController chatVCWithConversation:self.conversation];
    [self addChildViewController:liveGroupChatVC];
    [self.view addSubview:liveGroupChatVC.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

+ (instancetype)liveGroupChatVCWithConversation:(BIMConversation *)conversation
{
    VEIMDemoLiveGroupChatViewController *vc = [[VEIMDemoLiveGroupChatViewController alloc] init];
    vc.conversation = conversation;
    return vc;
}


#pragma mark -Interaction

- (void)dismiss
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backItemClicked: (id)sender
{
    [[BIMClient sharedInstance] leaveLiveGroup:self.conversation.conversationID completion:^(BIMError * _Nullable error) {
        
    }];
    [self dismiss];
}

- (void)moreInfoClicked:(id)sender
{
    // 直播群设置页
    VEIMDemoLiveGroupSettingViewController *liveGroupSettingVC = [[VEIMDemoLiveGroupSettingViewController alloc] initWithConversation:self.conversation];
    [self.navigationController pushViewController:liveGroupSettingVC animated:YES];
}

#pragma mark - BIMLiveConversationListener

- (void)onConversationChanged:(BIMConversation *)conversation
{
    self.navigationItem.titleView = [[VEIMDemoLiveGroupChatTitleView alloc] initWithTitle:self.conversation.name onlineUsrNum:conversation.onlineMemberCount];
}

#pragma mark - BIMLiveMessageListener

- (void)onReceiveMessage:(BIMMessage *)message
{
    NSString *nickName = message.ext[@"a:live_group_nick_name"];
    [[VEIMDemoUserManager sharedManager] setNickName:nickName forUID:message.senderUID];
}

@end
