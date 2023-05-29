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
#import "BIMToastView.h"

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
    NSMutableArray *users = [NSMutableArray array];
    for (int i = 1; i<11; i++) {
        long long userID = i+10000;
        if ([VEIMDemoUserManager sharedManager].currentUser.userID != userID) {
            VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
            user.userID = userID;
            user.isNeedSelection = YES;
            user.name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:userID];
            user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:userID];
            [users addObject:user];
        }
    }
    VEIMDemoUserSelectionController *userSelectionVC = [[VEIMDemoUserSelectionController alloc] initWithUsers:users];
    userSelectionVC.delegate = self;
    if (index == 0) {//发起单聊
        userSelectionVC.style = VEIMDemoUserSelectionStyleChoose;
    }else if (index == 1){
        userSelectionVC.style = VEIMDemoUserSelectionStyleMultiSelection;
    }
    userSelectionVC.title = @"选择用户发起聊天";
    [self.navigationController pushViewController:userSelectionVC animated:YES];
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

#pragma mark - VEIMDemoUserSelectionControllerDelegate

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didChooseUser:(VEIMDemoUser *)user{
    [self createConversationWithConversationType:BIM_CONVERSATION_TYPE_ONE_CHAT systemMsg:nil participants:[NSSet setWithObject:@(user.userID)]];
}

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didSelectUsers:(NSArray<VEIMDemoUser *> *)users{
    if (users.count) {
        NSMutableSet *usersSet = [NSMutableSet set];
        for (VEIMDemoUser *user in users) {
            if (user.userID>0) {
                [usersSet addObject:@(user.userID)];
            }
        }
        NSString *msgStr = [NSString stringWithFormat:@"%@邀请", [VEIMDemoUserManager sharedManager].currentUser.name];
        
        for (int i = 0; i < users.count; i++) {
            VEIMDemoUser *user = users[i];
            if (i == (users.count - 1)) {
                msgStr = [msgStr stringByAppendingFormat:@"%@",user.name];
            } else {
                msgStr = [msgStr stringByAppendingFormat:@"%@、",user.name];
            }
        }
        msgStr = [msgStr stringByAppendingFormat:@"加入群聊"];
        [self createConversationWithConversationType:BIM_CONVERSATION_TYPE_GROUP_CHAT systemMsg:msgStr participants:usersSet];
    }
    
}

- (void)createConversationWithConversationType: (BIMConversationType)type systemMsg: (NSString *)msgStr participants: (NSSet <NSNumber *> *)participants{
    
    kWeakSelf(self);
    if (type == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        [[BIMClient sharedInstance] createSingleConversation:[participants anyObject] completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"创建聊天失败: %@",error.localizedDescription]];
            } else {
                VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
                [weakself.navigationController pushViewController:chatVC animated:YES];
            }
        }];
    }else{
        [[BIMClient sharedInstance] createGroupConversation:participants completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
            if (error) {
                NSString *toast = error.code == BIM_SERVER_ERROR_CREATE_CONVERSATION_MORE_THAN_LIMIT ? @"加群个数超过上限" : [NSString stringWithFormat:@"创建群聊失败: %@",error.localizedDescription];
                [BIMToastView toast:toast];
            }else{
                BIMMessage *msg = [[BIMClient sharedInstance] createCustomMessage:@{@"text":msgStr,@"type":@(2)}];
                
                [[BIMClient sharedInstance] sendMessage:msg conversationId:conversation.conversationID saved:nil progress:nil  completion:nil];
                
                VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
                [weakself.navigationController pushViewController:chatVC animated:YES];
            }
        }];
    }
}

@end

