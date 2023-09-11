//
//  VEIMDemoChatViewController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/4.
//

#import "VEIMDemoChatViewController.h"
#import "BIMChatViewController.h"
#import <imsdk-tob/BIMSDK.h>
#import "VEIMDemoDefine.h"
#import "VEIMDemoConversationSettingController.h"
#import "VEIMDemoUserManager.h"

@interface VEIMDemoChatViewController ()
@property (nonatomic, strong) BIMConversation *conversation;
@end

@implementation VEIMDemoChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreInfoClicked:)];
    self.navigationItem.rightBarButtonItem = moreBtn;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked:)];
    
    BIMChatViewController *chatVC = [BIMChatViewController chatVCWithConversation:self.conversation];
    chatVC.anchorMessage = self.anchorMessage; // 搜索时指定目标message
    [self addChildViewController:chatVC];
    [self.view addSubview:chatVC.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        self.title = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:self.conversation.oppositeUserID];
    } else {
        self.title = [NSString stringWithFormat:@"%@", kValidStr(self.conversation.name) ? self.conversation.name : @"未命名群聊"];
    }
}

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation
{
    VEIMDemoChatViewController *vc = [[VEIMDemoChatViewController alloc] init];
    vc.conversation = conversation;
    return vc;
}

#pragma mark - Interaction

- (void)dismiss{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backItemClicked: (id)sender{
    [self dismiss];
}

- (void)moreInfoClicked:(id)sender{
    if (!self.conversation.isMember || self.conversation.isDissolved) {
        return;
    }
    VEIMDemoConversationSettingController *settingVC = [[VEIMDemoConversationSettingController alloc] initWithConversation:self.conversation];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
