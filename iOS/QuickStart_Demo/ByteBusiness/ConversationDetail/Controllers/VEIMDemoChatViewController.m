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
#import "BIMUIClient.h"
#import "VEIMDemoProfileEditViewController.h"
#import "VEIMDemoMessageReadDetailViewController.h"
#import <im-uikit-tob/BIMUICommonUtility.h>

NSString * const DEFAULT_CONV_TITLE = @"defaultTitle";

@interface VEIMDemoChatViewController ()<BIMChatViewControllerDelegate, BIMP2PMessageListener, BIMMessageListener>
@property (nonatomic, strong) BIMConversation *conversation;
@property (nonatomic, strong) NSTimer *timer;
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
    chatVC.delegate = self;
    [self addChildViewController:chatVC];
    [self.view addSubview:chatVC.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setConvTitle:DEFAULT_CONV_TITLE];
}

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation
{
    VEIMDemoChatViewController *vc = [[VEIMDemoChatViewController alloc] init];
    vc.conversation = conversation;
    [vc addListener];
    return vc;
}

- (void)dealloc
{
    [self removeLisener];
    [self clearTimer];
}

- (void)setConvTitle:(NSString *)title
{
    if (title && title != DEFAULT_CONV_TITLE) {
        self.title = title;
        return;
    }
    
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        long long oppositeUserID = self.conversation.oppositeUserID;
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(oppositeUserID);
        /// 可能是刚创建会话还没有用户资料，需要主动拉一次更新 title
        if (!user) {
            @weakify(self);
            // 获取会话信息
            if ([[BIMUIClient sharedInstance].userInfoDataSource respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
                [[BIMUIClient sharedInstance].userInfoDataSource getUserInfoWithUserId:oppositeUserID completion:^(BIMUser *u) {
                    @strongify(self);
                    if (self.conversation.oppositeUserID != oppositeUserID) {
                        return;
                    }
                    self.title = [BIMUICommonUtility getShowNameWithConversation:self.conversation];
                }];
            }
        }
    }
    
    self.title = [BIMUICommonUtility getShowNameWithConversation:self.conversation];
}

- (void)clearTimer
{
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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

#pragma mark - BIMChatViewControllerDelegate

- (void)chatViewController:(BIMChatViewController *)controller didClickAvatar:(BIMMessage *)message
{
    BIMUserProfile *profile = [[VEIMDemoUserManager sharedManager] fullInfoWithUserID:message.senderUID].userProfile;
    if (!profile) {
        profile = [[BIMUserProfile alloc] init];
        profile.uid = message.senderUID;
    }
    VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserProfile:profile];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatViewController:(BIMChatViewController *)controller didClickReadDetailWithMessage:(BIMMessage *)message
{
    VEIMDemoMessageReadDetailViewController *vc = [[VEIMDemoMessageReadDetailViewController alloc] initWithMessage:message];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 消息监听
- (void)addListener
{
    [[BIMClient sharedInstance] addP2PMessageListener:self];
    [[BIMClient sharedInstance] addMessageListener:self];
}

- (void)removeLisener
{
    [[BIMClient sharedInstance] removeP2PMessageListener:self];
    [[BIMClient sharedInstance] removeMessageListener:self];
}

#pragma mark - 收发消息回调
- (void)onSendP2PMessage:(BIMMessage *)p2pMessage
{
    
}

- (void)onReceiveP2PMessage:(BIMMessage *)p2pMessage
{
    if (![p2pMessage.conversationID isEqualToString:self.conversation.conversationID]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        BIMP2PElement *element = (BIMP2PElement *)p2pMessage.element;
        BIMMessageType messageType = [[element.dataDict objectForKey:@"message_type"] longLongValue];
        if (messageType == BIM_MESSAGE_TYPE_TEXT) {
            [self setConvTitle:@"对方正在输入中"];
        } else if (messageType == BIM_MESSAGE_TYPE_AUDIO) {
            [self setConvTitle:@"对方正在讲话......"];
        }
        [self clearTimer];
        @weakify(self);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            @strongify(self);
            [self setConvTitle:DEFAULT_CONV_TITLE];
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    });
}

- (void)onReceiveMessage:(BIMMessage *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.title != DEFAULT_CONV_TITLE) {
            [self clearTimer];
            [self setConvTitle:DEFAULT_CONV_TITLE];
        }
    });
}

@end
