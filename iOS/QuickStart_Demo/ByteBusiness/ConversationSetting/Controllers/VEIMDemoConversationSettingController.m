//
//  VEIMDemoConversationSettingController.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoConversationSettingController.h"
#import "VEIMDemoUserListCell.h"
#import "VEIMDemoUserSelectionController.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoSettingModel.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoConversationSettingCell.h"
#import "VEIMDemoInputController.h"
#import "BIMToastView.h"
#import "VEIMDemoIMManager+Message.h"
#import "VEIMDemoIMManager+Conversation.h"
#import "VEIMDemoSelectUserViewController.h"
#import "VEIMDemoFTSViewController.h"
#import "BIMUIClient.h"
#import "VEIMDemoProfileEditViewController.h"
#import "VEIMDemoConversationExtController.h"

typedef enum : NSUInteger {
    VEIMDemoConversationActionTypeDefault = 0,
    VEIMDemoConversationActionTypeAddParticipant = 1,
    VEIMDemoConversationActionTypeRemoveParticipant = 2,
    VEIMDemoConversationActionTypeManageParticipants = 3,
} VEIMDemoConversationActionType;

@interface VEIMDemoConversationSettingController () <VEIMDemoUserSelectionControllerDelegate, BIMConversationListListener>
@property (nonatomic, strong) BIMConversation *conversation;

@property (nonatomic, strong) id <BIMMember> currentParticant;

@property (nonatomic, assign) VEIMDemoConversationActionType actionType;

@property (nonatomic, strong) NSMutableArray <VEIMDemoSettingModel *> *settings;

@property (nonatomic, strong) NSMutableArray *oldManagers;
@end

@implementation VEIMDemoConversationSettingController

- (instancetype)initWithConversation:(BIMConversation *)conversation
{
    self = [super init];
    if (self) {
        self.conversation = conversation;
        self.currentParticant = conversation.currentMember;
//        [self createSettingModels];

    }
    return self;
}

- (void)createSettingModels{
    self.settings = [NSMutableArray array];
    kWeakSelf(self);
    
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_ONE_CHAT) {
        //群聊名称
        NSString *detail = self.conversation.name.length ? self.conversation.name : @"未命名群聊";
        VEIMDemoSettingModel *nameSetting = [VEIMDemoSettingModel settingWithTitle:@"群聊名称" detail:detail isNeedSwitch:NO switchOn:NO];
        nameSetting.clickHandler = ^() {
            VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群聊名称" text:detail maxWordCount:10 editable:weakself.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
                [[BIMClient sharedInstance] setGroupName:weakself.conversation.conversationID name:text completion:^(BIMError * _Nullable error) {
                    if (error) {
                        if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                            [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                        } else {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群聊名称失败: %@",error.localizedDescription]];
                        }
                    } else {
                        [weakself createSettingModels];
                    }
                }];
            }];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        [self.settings addObject:nameSetting];
        
        //群公告
        VEIMDemoSettingModel *noticeSetting = [VEIMDemoSettingModel settingWithTitle:@"群公告" detail:weakself.conversation.notice.length?weakself.conversation.notice:@"未设置公告" isNeedSwitch:NO switchOn:NO];
        noticeSetting.clickHandler = ^() {
            VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群公告" text:weakself.conversation.notice maxWordCount:100 editable:self.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
                [[BIMClient sharedInstance] setGroupNotice:weakself.conversation.conversationID notice:text completion:^(BIMError * _Nullable error) {
                    if (error) {
                        if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                            [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                        } else {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群聊名称失败: %@",error.localizedDescription]];
                        }
                    } else {
                        [weakself createSettingModels];
                    }
                }];
            }];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        [self.settings addObject:noticeSetting];
        
        //群主管理
        if (self.currentParticant.role == BIM_MEMBER_ROLE_OWNER) {
            VEIMDemoSettingModel *ownerSetting = [VEIMDemoSettingModel settingWithTitle:@"设置管理员" detail:@"" isNeedSwitch:NO switchOn:NO];
            ownerSetting.clickHandler = ^() {
                weakself.actionType = VEIMDemoConversationActionTypeManageParticipants;
                weakself.oldManagers = [NSMutableArray array];
                NSMutableArray *users = [NSMutableArray array];
                NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
                for (id <BIMMember> participant in participants) {
                    VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
                    BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
                    NSString *alias = u.alias;
                    alias = alias.length ? alias : (participant.alias.length ? participant.alias : u.nickName);
                    user.name = alias;
                    user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
                    user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
                    user.userID = participant.userID;
                    user.isNeedSelection = YES;
                    if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
                        user.role = @"管理员";
                        user.isSelected = YES;
                        [weakself.oldManagers addObject:user];
                    }else if (participant.role == BIM_MEMBER_ROLE_OWNER){
                        user.role = @"群主";
                        user.isSelected = YES;
                        user.isNeedSelection = NO;
                    }
                    [users addObject:user];
                    
                }
                
                users = [self sortUsers: users];
                
                VEIMDemoUserSelectionController *userController = [[VEIMDemoUserSelectionController alloc] initWithUsers:users];
                userController.style = VEIMDemoUserSelectionStyleMultiSelection;
                userController.delegate = self;
                userController.title = @"设置群管理员";
                [weakself.navigationController pushViewController:userController animated:YES];
            };
            [self.settings addObject:ownerSetting];
        }

        
    }
    //置顶
    VEIMDemoSettingModel *stickTop = [VEIMDemoSettingModel settingWithTitle:@"置顶聊天" detail:@"" isNeedSwitch:YES switchOn:self.conversation.isStickTop];
    stickTop.switchHandler = ^(UISwitch * _Nonnull swt) {
        [[BIMClient sharedInstance] stickTopConversation:weakself.conversation.conversationID isStickTop:swt.on completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"置顶失败：%@",error.localizedDescription]];
            }
        }];
    };
    [self.settings addObject:stickTop];
    
    //消息免打扰
    VEIMDemoSettingModel *mute = [VEIMDemoSettingModel settingWithTitle:@"消息免打扰" detail:@"" isNeedSwitch:YES switchOn:self.conversation.isMute];
    mute.switchHandler = ^(UISwitch * _Nonnull swt) {
        [[BIMClient sharedInstance] muteConversation:weakself.conversation.conversationID mute:swt.on completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"设置失败：%@",error.localizedDescription]];
                }
        }];
    };
    [self.settings addObject:mute];
    
    //搜索消息记录
    VEIMDemoSettingModel *searchMessage = [VEIMDemoSettingModel settingWithTitle:@"搜索消息记录" detail:@"" isNeedSwitch:NO switchOn:NO];
    searchMessage.clickHandler = ^{
        VEIMDemoFTSViewController *vc = [VEIMDemoFTSViewController new];
        vc.conversationID = weakself.conversation.conversationID;
        [weakself.navigationController pushViewController:vc animated:YES];
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:weakself.navigationController.viewControllers];
        [controllers removeObjectAtIndex:1];
        weakself.navigationController.viewControllers = controllers;
    };
    [self.settings addObject:searchMessage];

    
    //解散群聊
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT && self.currentParticant.role == BIM_MEMBER_ROLE_OWNER) {
        VEIMDemoSettingModel *dismiss = [VEIMDemoSettingModel settingWithTitle:@"解散群聊" detail:@"" isNeedSwitch:NO switchOn:NO];
        dismiss.clickHandler = ^() {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"解散群聊" message:@"确定要解散群聊吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[VEIMDemoIMManager sharedManager] dismissCon:weakself.conversation completion:^(NSError * _Nullable error) {
                    if (!error) {
                        [[BIMClient sharedInstance] deleteConversation:weakself.conversation.conversationID completion:nil];
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }];
            [alertVC addAction:sure];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [weakself presentViewController:alertVC animated:YES completion:nil];
        };
        [self.settings addObject:dismiss];
    }
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        //退出群聊
        VEIMDemoSettingModel *quit = [VEIMDemoSettingModel settingWithTitle:@"退出群聊" detail:@"" isNeedSwitch:NO switchOn:NO];
        quit.clickHandler = ^() {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出群聊" message:@"确定要退出群聊吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[VEIMDemoIMManager sharedManager] quitCon:self.conversation completion:^(NSError * _Nullable error) {
                    if (!error) {
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [BIMToastView toast:[NSString stringWithFormat:@"退出群聊失败：%@",error.localizedDescription]];
                    }
                }];
            }];
            [alertVC addAction:sure];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [weakself presentViewController:alertVC animated:YES completion:nil];
        };
        [self.settings addObject:quit];
    }

    VEIMDemoSettingModel *setExt = [VEIMDemoSettingModel settingWithTitle:@"自定义字段" detail:@"" isNeedSwitch:NO switchOn:NO];
    setExt.clickHandler = ^() {
        VEIMDemoConversationExtController *vc = [[VEIMDemoConversationExtController alloc] initWithConversation:self.conversation];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    [self.settings addObject:setExt];

    [self.tableview reloadData];
}

- (UITableViewStyle)tableviewStyle{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *members = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
    NSArray *uidList = [members valueForKey:@"userID"];
    @weakify(self);
    [[VEIMDemoUserManager sharedManager] getUserFullInfoList:uidList syncServer:NO completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            return;
        }
        [self createSettingModels];
    }];
}

- (void)setupUIElements{
    [super setupUIElements];
    
    self.title = @"聊天详情";
    
    [self.tableview registerClass:[VEIMDemoUserListCell class] forCellReuseIdentifier:@"VEIMDemoUserListCell"];
    
    [self.tableview registerClass:[VEIMDemoConversationSettingCell class] forCellReuseIdentifier:@"VEIMDemoConversationSettingCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.settings.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        VEIMDemoUserListCell *userListCell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoUserListCell"];
        NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
        [userListCell refreshWithConversationParticipants:participants];
        BOOL canAdd = self.currentParticant.role == BIM_MEMBER_ROLE_OWNER;
        BOOL canRemove = self.currentParticant.role == BIM_MEMBER_ROLE_OWNER || self.currentParticant.role == BIM_MEMBER_ROLE_ADMIN;
        userListCell.canAdd = canAdd;
        userListCell.canRemove = canRemove;
        @weakify(self);
        userListCell.addHandler = ^{
            @strongify(self);
            self.actionType = VEIMDemoConversationActionTypeAddParticipant;
            
            VEIMDemoSelectUserViewController *vc = [[VEIMDemoSelectUserViewController alloc] init];
            vc.conversationType = BIM_CONVERSATION_TYPE_GROUP_CHAT;
            vc.conversation = self.conversation;
            vc.showType = VEIMDemoSelectUserShowTypeAddParticipants;
            vc.title = @"添加成员";
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        
        userListCell.minusHandler = ^{
            @strongify(self);
            self.actionType = VEIMDemoConversationActionTypeRemoveParticipant;
            
            NSMutableArray *users = [@[] mutableCopy];
            NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
            
            NSMutableArray *admins = [NSMutableArray array];
            BIMMemberRole currentUserRole;
            
            for (id<BIMMember> participant in participants) {
                if (participant.userID != [VEIMDemoUserManager sharedManager].currentUser.userID) {
                    if (participant.role == BIM_MEMBER_ROLE_OWNER) {
//                        user.role = @"群主";
//                        user.isNeedSelection = NO;
                        continue;
                    }
                    VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
                    user.userID = participant.userID;
                    BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
                    NSString *alias = u.alias;
                    alias = alias.length ? alias : (participant.alias.length ? participant.alias : u.nickName);
                    user.name = alias;
                    user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
                    user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
                    user.isNeedSelection = YES;
                    if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
                        user.role = @"管理员";
                        [admins addObject:user];
                    } else {
                        [users addObject:user];
                    }
                } else {
                    currentUserRole = participant.role;
                }
            }
            if (currentUserRole == BIM_MEMBER_ROLE_OWNER) {
                [users addObjectsFromArray:admins];
            }
            
            users = [self sortUsers:users];
            
            VEIMDemoUserSelectionController *userController = [[VEIMDemoUserSelectionController alloc] initWithUsers:users];
            userController.style = VEIMDemoUserSelectionStyleMultiSelection;
            userController.delegate = self;
            userController.title = @"移出群成员";
            [self.navigationController pushViewController:userController animated:YES];
        };
        
        
        userListCell.clickHandler = ^{
            @strongify(self);
            self.actionType = VEIMDemoConversationActionTypeDefault;
            NSMutableArray *users = [NSMutableArray array];
            NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
            for (id <BIMMember> participant in participants) {
                VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
                BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
                NSString *alias = u.alias;
                alias = alias.length ? alias : (participant.alias.length ? participant.alias : u.nickName);
                user.name = alias;
                user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
                user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
                user.userID = participant.userID;
                user.isNeedSelection = YES;
                if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
                    user.role = @"管理员";
                }else if (participant.role == BIM_MEMBER_ROLE_OWNER){
                    user.role = @"群主";
                }
                [users addObject:user];
            }
            users = [self sortUsers:users];
            VEIMDemoUserSelectionController *userController = [[VEIMDemoUserSelectionController alloc] initWithUsers:users];
            userController.title = self.conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT ? @"成员列表" : @"群成员列表";
            userController.delegate = self;
            [self.navigationController pushViewController:userController animated:YES];
        };
        
        userListCell.itemClickHandler = ^(NSInteger index) {
            @strongify(self);
            id<BIMMember> member = participants[index];
            [self jumpToProfileViewControllerWithUid:member.userID];
        };
        return userListCell;
    }else{
        VEIMDemoSettingModel *setting = self.settings[indexPath.row];
        
        VEIMDemoConversationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoConversationSettingCell"];
        
        cell.model = setting;
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableArray *users = [NSMutableArray array];
        NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
        for (id <BIMMember> participant in participants) {
            VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
            BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
            NSString *alias = u.alias;
            alias = alias.length ? alias : (participant.alias.length ? participant.alias : u.nickName);
            user.name = alias;
            user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
            user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
            user.userID = participant.userID;
            user.isNeedSelection = NO;
            if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
                user.role = @"管理员";
            }else if (participant.role == BIM_MEMBER_ROLE_OWNER){
                user.role = @"群主";
            }
            [users addObject:user];
        }
        users = [self sortUsers:users];
        VEIMDemoUserSelectionController *userController = [[VEIMDemoUserSelectionController alloc] initWithUsers:users];
        userController.title = @"群成员列表";
        
        
        [self.navigationController pushViewController:userController animated:YES];
    }else if (indexPath.section == 1) {
        VEIMDemoSettingModel *model = self.settings[indexPath.row];
        if (model.clickHandler) {
            model.clickHandler();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 88;
    }
    
    return 80;
}

#pragma mark - User Selection Delegate

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didSelectUsers:(NSArray<VEIMDemoUser *> *)users{
    if (!users.count) {
        return;
    }
    kWeakSelf(self);
    switch (self.actionType) {
        case VEIMDemoConversationActionTypeDefault:
            break;
        case VEIMDemoConversationActionTypeAddParticipant:{
            [[VEIMDemoIMManager sharedManager] addUsers:users con:self.conversation completion:^(NSError * _Nullable error) {
                if (error) {
                    NSString *toast = [NSString stringWithFormat:@"添加失败: %@",error.localizedDescription];
                    if (error.code == BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT) {
                        toast = error.localizedDescription;
                    } else if (error.code == BIM_SERVER_ADD_MEMBER_TOUCH_LIMIT) {
                        toast = @"群成员已达上限";
                    }
                    [BIMToastView toast:toast];
                }
                [weakself.tableview reloadData];
            }];
            break;
        }
        case VEIMDemoConversationActionTypeRemoveParticipant:{
            [[VEIMDemoIMManager sharedManager] removeUsers:users con:self.conversation completion:^(NSError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:@"移除失败"];
                }
                [weakself.tableview reloadData];
            }];
            break;
        }
        case VEIMDemoConversationActionTypeManageParticipants:{
            //刨除自己
            [[VEIMDemoIMManager sharedManager] setAdmins:users con:self.conversation completion:nil];
            break;
        }
        default:
            break;
    }

}

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didChooseUser:(VEIMDemoUser *)user
{
    [self jumpToProfileViewControllerWithUid:user.userID];
}

- (void)jumpToProfileViewControllerWithUid:(long long)uid
{
    BIMUserProfile *profile = [[VEIMDemoUserManager sharedManager] fullInfoWithUserID:uid].userProfile;;
    if (!profile) {
        profile = [[BIMUserProfile alloc] init];
        profile.uid = uid;
    }
    VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserProfile:profile];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)sortUsers: (NSMutableArray <VEIMDemoUser *> *)users{
    NSMutableArray *sortedUsers = [NSMutableArray array];
    
    for (int i = 0; i<3; i++) {
        if (i == 0) {
            for (VEIMDemoUser *user in users) {
                if([user.role isEqualToString:@"群主"]){
                    [sortedUsers addObject:user];
                    break;
                }
            }
        } else if (i == 1){
            for (VEIMDemoUser *user in users) {
                if([user.role isEqualToString:@"管理员"]){
                    [sortedUsers addObject:user];
                }
            }
        }else{
            for (VEIMDemoUser *user in users) {
                if(!user.role.length){
                    [sortedUsers addObject:user];
                }
            }
        }
    }
    return sortedUsers;
}


@end
