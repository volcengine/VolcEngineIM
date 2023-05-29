//
//  VEIMDemoLiveGroupSettingViewController.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/25.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoLiveGroupSettingViewController.h"
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
#import "VEIMDemoSilentListViewController.h"
#import "VEIMDemoBlockListViewController.h"
#import "VEIMDemoOnlineListViewController.h"

typedef enum : NSUInteger {
    VEIMDemoLiveGroupActionTypeDefault = 0,
    VEIMDemoLiveGroupActionTypeAddParticipant = 1,
    VEIMDemoLiveGroupActionTypeRemoveParticipant = 2,
    VEIMDemoLiveGroupActionTypeManageParticipants = 3,
} VEIMDemoLiveGroupActionType;

static int const kMaxOnlineCount = 5;

@interface VEIMDemoLiveGroupSettingViewController () <VEIMDemoUserSelectionControllerDelegate, BIMLiveConversationListener, BIMLiveGroupMemberEventListener>
@property (nonatomic, strong) BIMConversation *conversation;

@property (nonatomic, strong) id <BIMMember> currentParticant;

@property (nonatomic, assign) VEIMDemoLiveGroupActionType actionType;

@property (nonatomic, strong) NSMutableArray <VEIMDemoSettingModel *> *settings;

@property (nonatomic, strong) NSMutableArray *oldManagers;

@property (nonatomic, strong) NSArray *onlineMembers;
@end

@implementation VEIMDemoLiveGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithConversation:(BIMConversation *)conversation
{
    self = [super init];
    if (self) {
        self.conversation = conversation;
        self.currentParticant = conversation.currentMember;
        [self createSettingModels];
        
        if (self.currentParticant) {
            self.onlineMembers = @[self.currentParticant];
        }
        [self requestOnlineMembers];
        
        [[BIMClient sharedInstance] addLiveConversationListener:self];
        [[BIMClient sharedInstance] addLiveGroupMemberListener:self];

    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeLiveConversationListener:self];
}

- (void)requestOnlineMembers
{
    kWeakSelf(self)
    [[BIMClient sharedInstance] getLiveGroupMemberOnlineList:self.conversation.conversationID cursor:0 count:kMaxOnlineCount completion:^(NSArray<id<BIMMember>> * _Nullable members, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        weakself.onlineMembers = members;
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"获取在线成员失败:%@", error]];
        } else {
            [weakself.tableview reloadData];
        }
    }];
}

- (void)createSettingModels{
    self.settings = [NSMutableArray array];
    
    [self.settings addObject:[self createNameModel]];
    [self.settings addObject:[self createDescModel]];
    [self.settings addObject:[self createNoticeModel]];
    [self.settings addObject:[self createNickModel]];
    
    if (self.conversation.currentMember.role == BIM_MEMBER_ROLE_OWNER) {
        [self.settings addObject:[self createAvatarModel]];
        [self.settings addObject:[self createAllSilentSwtichModel]];
        [self.settings addObject:[self createSilentListModel]];
        [self.settings addObject:[self createBlackListModel]];
        [self.settings addObject:[self createOwnerModel]];
        [self.settings addObject:[self createDissmissModel]];
    }
    
    [self.settings addObject:[self createLeaveModel]];
    
    [self.tableview reloadData];
}

- (VEIMDemoSettingModel *)createNameModel
{
    kWeakSelf(self);
    //群聊名称
    NSString *detail = self.conversation.name.length?self.conversation.name:@"未命名群聊";
    VEIMDemoSettingModel *nameSetting = [VEIMDemoSettingModel settingWithTitle:@"群聊名称" detail:detail isNeedSwitch:NO switchOn:NO];
    nameSetting.clickHandler = ^() {
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群聊名称" text:detail maxWordCount:10 editable:weakself.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
            [[BIMClient sharedInstance] setLiveGroupName:weakself.conversation.conversationID name:text completion:^(BIMError * _Nullable error) {
                if (error) {
                    if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                        [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                    } else {
                        [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                    }
                } else {
                    [weakself createSettingModels];
                }
            }];
        }];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return nameSetting;
}

- (VEIMDemoSettingModel *)createDescModel
{
    kWeakSelf(self);
    //群公告
    VEIMDemoSettingModel *descSetting = [VEIMDemoSettingModel settingWithTitle:@"群简介" detail:weakself.conversation.introduction.length?weakself.conversation.introduction:@"未设置简介" isNeedSwitch:NO switchOn:NO];
    descSetting.clickHandler = ^() {
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群简介" text:weakself.conversation.introduction maxWordCount:100 editable:self.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
            [[BIMClient sharedInstance] setLiveGroupDescription:weakself.conversation.conversationID description:text completion:^(BIMError * _Nullable error) {
                if (error) {
                    if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                        [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                    } else {
                        [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                    }
                } else {
                    [weakself createSettingModels];
                }
            }];
        }];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return descSetting;
}

- (VEIMDemoSettingModel *)createNoticeModel
{
    kWeakSelf(self);
    //群公告
    VEIMDemoSettingModel *noticeSetting = [VEIMDemoSettingModel settingWithTitle:@"群公告" detail:weakself.conversation.notice.length?weakself.conversation.notice:@"未设置公告" isNeedSwitch:NO switchOn:NO];
    noticeSetting.clickHandler = ^() {
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群公告" text:weakself.conversation.notice maxWordCount:100 editable:self.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
            [[BIMClient sharedInstance] setLiveGroupNotice:weakself.conversation.conversationID notice:text completion:^(BIMError * _Nullable error) {
                if (error) {
                    if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                        [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                    } else {
                        [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                    }
                } else {
                    [weakself createSettingModels];
                }
            }];
        }];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return noticeSetting;
}

- (VEIMDemoSettingModel *)createNickModel
{
    kWeakSelf(self);
    //昵称
    long long currentUID = [VEIMDemoUserManager sharedManager].currentUser.userID;
    NSString *nickName = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:currentUID];
    VEIMDemoSettingModel *noticeSetting = [VEIMDemoSettingModel settingWithTitle:@"群昵称" detail:nickName isNeedSwitch:NO switchOn:NO];
    noticeSetting.clickHandler = ^() {
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群昵称" text:nickName maxWordCount:100 editable:YES handler:^(NSString * _Nonnull text) {
            // 更改全局
            [[VEIMDemoUserManager sharedManager] setNickName:text forUID:[VEIMDemoUserManager sharedManager].currentUser.userID];
            [weakself createSettingModels];
        }];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return noticeSetting;
}

- (VEIMDemoSettingModel *)createAllSilentSwtichModel
{
    kWeakSelf(self);
    //全员禁言
    VEIMDemoSettingModel *allSilent = [VEIMDemoSettingModel settingWithTitle:@"全员禁言" detail:@"" isNeedSwitch:YES switchOn:self.conversation.blockStatus == BIM_BLOCK_STATUS_BLOCK];
    allSilent.switchHandler = ^(UISwitch * _Nonnull swt) {
        [[BIMClient sharedInstance] setLiveGroupSilent:weakself.conversation.conversationID isSilent:swt.isOn completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"操作失败：%@",error.localizedDescription]];
            }
        }];
    };
    return allSilent;
}

- (VEIMDemoSettingModel *)createAvatarModel
{
    kWeakSelf(self);
    // 设置头像
    VEIMDemoSettingModel *avatarSetting = [VEIMDemoSettingModel settingWithTitle:@"群头像" detail:weakself.conversation.portraitURL isNeedSwitch:NO switchOn:NO];
    avatarSetting.clickHandler = ^() {
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群头像" text:weakself.conversation.portraitURL maxWordCount:1000 editable:YES handler:^(NSString * _Nonnull text) {
            [[BIMClient sharedInstance] setLiveGroupIcon:weakself.conversation.conversationID url:text completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveGroupSettingChanged" object:weakself.conversation];
                    [weakself createSettingModels];
                }
            }];
        }];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return avatarSetting;
}


- (VEIMDemoSettingModel *)createSilentListModel
{
    kWeakSelf(self);
    VEIMDemoSettingModel *silentListSetting = [VEIMDemoSettingModel settingWithTitle:@"禁言名单" detail:@"" isNeedSwitch:NO switchOn:NO];
    silentListSetting.clickHandler = ^() {
        weakself.actionType = VEIMDemoLiveGroupActionTypeManageParticipants;
        VEIMDemoSilentListViewController *userController = [[VEIMDemoSilentListViewController alloc] initWithConversation:weakself.conversation];
        userController.style = VEIMDemoUserSelectionStyleChoose;
        userController.title = @"禁言名单";
        [weakself.navigationController pushViewController:userController animated:YES];
    };
    
    return silentListSetting;
}

- (VEIMDemoSettingModel *)createBlackListModel
{
    kWeakSelf(self);
    VEIMDemoSettingModel *blackListSetting = [VEIMDemoSettingModel settingWithTitle:@"进群黑名单" detail:@"" isNeedSwitch:NO switchOn:NO];
    blackListSetting.clickHandler = ^() {
        weakself.actionType = VEIMDemoLiveGroupActionTypeManageParticipants;
        VEIMDemoBlockListViewController *userController = [[VEIMDemoBlockListViewController alloc] initWithConversation:weakself.conversation];
        userController.style = VEIMDemoUserSelectionStyleChoose;
        userController.title = @"进群黑名单";
        [weakself.navigationController pushViewController:userController animated:YES];
    };
    
    return blackListSetting;
}

- (VEIMDemoSettingModel *)createOwnerModel
{
    kWeakSelf(self);
    VEIMDemoSettingModel *ownerSetting = [VEIMDemoSettingModel settingWithTitle:@"转让群主" detail:@"" isNeedSwitch:NO switchOn:NO];
    ownerSetting.clickHandler = ^() {
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"转让群主" text:nil maxWordCount:100 editable:self.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
            [[BIMClient sharedInstance] transLiveGroupOwner:weakself.conversation.conversationID uid:text.longLongValue completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"转让群主失败：%@",error.localizedDescription]];
                } else {
                    [weakself createSettingModels];
                }
            }];
        }];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    return ownerSetting;
}

- (VEIMDemoSettingModel *)createDissmissModel
{
    kWeakSelf(self);
    VEIMDemoSettingModel *dismiss = [VEIMDemoSettingModel settingWithTitle:@"解散直播群" detail:@"" isNeedSwitch:NO switchOn:NO];
    dismiss.clickHandler = ^() {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"解散直播群" message:@"确定要解散直播群吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[BIMClient sharedInstance] dissolveLiveGroup:weakself.conversation.conversationID completion:^(BIMError * _Nullable error) {
                if (!error) {
                    // 解散成功后从列表移除改直播群
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLiveGroup" object:weakself.conversation];
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [BIMToastView toast:[NSString stringWithFormat:@"解散直播群失败：%@",error.localizedDescription]];
                }
            }];
        }];
        [alertVC addAction:sure];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [weakself presentViewController:alertVC animated:YES completion:nil];
    };
    return dismiss;
}

- (VEIMDemoSettingModel *)createLeaveModel
{
    kWeakSelf(self);
    //退出直播群
    VEIMDemoSettingModel *quit = [VEIMDemoSettingModel settingWithTitle:@"退出直播群" detail:@"" isNeedSwitch:NO switchOn:NO];
    quit.clickHandler = ^() {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出直播群" message:@"确定要退出直播群吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[BIMClient sharedInstance] leaveLiveGroup:weakself.conversation.conversationID completion:^(BIMError * _Nullable error) {
                if (!error) {
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [BIMToastView toast:[NSString stringWithFormat:@"退出直播群失败：%@",error.localizedDescription]];
                }
            }];
        }];
        [alertVC addAction:sure];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [weakself presentViewController:alertVC animated:YES completion:nil];
    };
    return quit;
}


- (UITableViewStyle)tableviewStyle{
    return UITableViewStyleGrouped;
}

- (void)setupUIElements{
    [super setupUIElements];
    
    self.title = @"直播群详情";
    
    [self.tableview registerClass:[VEIMDemoUserListCell class] forCellReuseIdentifier:@"VEIMDemoUserListCell"];
    
    [self.tableview registerClass:[VEIMDemoConversationSettingCell class] forCellReuseIdentifier:@"VEIMDemoConversationSettingCell"];
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
        userListCell.subTitleLabel.text = [NSString stringWithFormat:@"%d人", self.conversation.onlineMemberCount];
        NSArray *participants = self.onlineMembers;
        [userListCell refreshWithConversationParticipants:participants];
        userListCell.canRemove = self.currentParticant.role == BIM_MEMBER_ROLE_OWNER || self.currentParticant.role == BIM_MEMBER_ROLE_ADMIN;
        kWeakSelf(self);
        userListCell.minusHandler = ^{
            weakself.actionType = VEIMDemoLiveGroupActionTypeRemoveParticipant;
            VEIMDemoOnlineListViewController *userController = [[VEIMDemoOnlineListViewController alloc] initWithConversation:weakself.conversation];
            [userController setKickLiveGroupMemberListBlock:^(NSArray<NSNumber *> * _Nullable uidList) {
                NSMutableArray *onlineMembers = [weakself.onlineMembers mutableCopy];
                BOOL flag = NO;
                for (id<BIMMember> member in weakself.onlineMembers) {
                    if ([uidList containsObject:@(member.userID)]) {
                        [onlineMembers removeObject:member];
                        flag = YES;
                    }
                }
                if (flag) {
                    weakself.onlineMembers = [onlineMembers copy];
                    [weakself.tableview reloadData];
                }
            }];
            userController.style = VEIMDemoUserSelectionStyleMultiSelection;
            userController.title = @"移除群成员";
            [weakself.navigationController pushViewController:userController animated:YES];
        };
        
        
        userListCell.clickHandler = ^{
            weakself.actionType = VEIMDemoLiveGroupActionTypeDefault;
            VEIMDemoOnlineListViewController *userController = [[VEIMDemoOnlineListViewController alloc] initWithConversation:weakself.conversation];
            userController.title = @"群成员列表";
            [weakself.navigationController pushViewController:userController animated:YES];
        };
        return userListCell;
    } else {
        VEIMDemoSettingModel *setting = self.settings[indexPath.row];
        
        VEIMDemoConversationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoConversationSettingCell"];
        
        cell.model = setting;
        
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        VEIMDemoOnlineListViewController *userController = [[VEIMDemoOnlineListViewController alloc] initWithConversation:self.conversation];
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

#pragma mark - BIMLiveConversationListener

- (void)onConversationChanged:(BIMConversation *)conversation
{
    [self createSettingModels];
}

#pragma mark - BIMLiveGroupMemberEventListener

- (void)onMemberKicked:(BIMConversation *)conversation memberList:(NSArray<id<BIMMember>> *)memberList operatorID:(long)operatorID
{
    [self removeMemberList:memberList];
}

- (void)onMemberLeave:(BIMConversation *)conversation memberList:(NSArray<id<BIMMember>> *)memberList
{
    [self removeMemberList:memberList];
}

- (void)onMemberJoined:(BIMConversation *)conversation memberList:(NSArray<id<BIMMember>> *)memberList
{
    [self addMemberList:memberList];
}

- (void)removeMemberList:(NSArray<id<BIMMember>> *)memberList
{
    NSMutableArray *onlineMembers = [self.onlineMembers mutableCopy];
    BOOL flag = NO;
    for (id<BIMMember> member in self.onlineMembers) {
        for (id<BIMMember> kickMember in memberList) {
            if (kickMember.userID == member.userID) {
                [onlineMembers removeObject:member];
                flag = YES;
            }
        }
    }
    if (flag) {
        self.onlineMembers = [onlineMembers copy];
        [self.tableview reloadData];
    }
}

- (void)addMemberList:(NSArray<id<BIMMember>> *)memberList
{
    if (self.onlineMembers.count >= kMaxOnlineCount) {
        return;
    }
    NSSet *onlineSet = [NSSet setWithArray:[self.onlineMembers valueForKey:@"userID"]];
    NSMutableArray *onlineMembers = [self.onlineMembers mutableCopy];
    
    for (id<BIMMember> addMember in memberList) {
        if (![onlineSet containsObject:@(addMember.userID)]) {
            [onlineMembers addObject:addMember];
            if (onlineMembers.count >= kMaxOnlineCount) {
                break;
            }
        }
    }
    
    self.onlineMembers = [onlineMembers copy];
    [self.tableview reloadData];
}

@end
