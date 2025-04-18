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
#import "VEIMDemoConversationDetailDebugViewController.h"
#import "VEIMDemoSearchResultContainer.h"
#import "VEIMDemoSelectAvatarViewController.h"
#import <im-uikit-tob/BIMUICommonUtility.h>
#import <im-uikit-tob/NSString+IMUtils.h>

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
    @weakify(self);
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_ONE_CHAT) {
        //群聊名称
        NSString *detail = [BIMUICommonUtility getShowNameWithConversation:self.conversation];
        VEIMDemoSettingModel *nameSetting = [VEIMDemoSettingModel settingWithTitle:@"群聊名称" detail:detail isNeedSwitch:NO switchOn:NO];
        nameSetting.clickHandler = ^() {
            @strongify(self);
            VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群聊名称" text:detail maxWordCount:10 editable:self.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
                text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[BIMClient sharedInstance] setGroupName:self.conversation.conversationID name:text completion:^(BIMError * _Nullable error) {
                    if (error) {
                        if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                            [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                        } else {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群聊名称失败: %@",error.localizedDescription]];
                        }
                    } else {
                        [self createSettingModels];
                    }
                }];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        };
        [self.settings addObject:nameSetting];
        
        //群公告
        VEIMDemoSettingModel *noticeSetting = [VEIMDemoSettingModel settingWithTitle:@"群公告" detail:![NSString im_isBlankString:self.conversation.notice]?self.conversation.notice:@"未设置公告" isNeedSwitch:NO switchOn:NO];
        noticeSetting.clickHandler = ^() {
            @strongify(self);
            VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群公告" text:self.conversation.notice maxWordCount:100 editable:self.currentParticant.role == BIM_MEMBER_ROLE_OWNER handler:^(NSString * _Nonnull text) {
                [[BIMClient sharedInstance] setGroupNotice:self.conversation.conversationID notice:text completion:^(BIMError * _Nullable error) {
                    if (error) {
                        if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                            [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                        } else {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群聊名称失败: %@",error.localizedDescription]];
                        }
                    } else {
                        [self createSettingModels];
                    }
                }];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        };
        [self.settings addObject:noticeSetting];
        
        if (self.currentParticant.role == BIM_MEMBER_ROLE_OWNER || self.currentParticant.role == BIM_MEMBER_ROLE_ADMIN) {
            //修改群头像
            VEIMDemoSettingModel *iconSetting = [VEIMDemoSettingModel settingWithTitle:@"修改群头像" detail:@"" isNeedSwitch:NO switchOn:NO];
            iconSetting.clickHandler = ^{
                @strongify(self);
                VEIMDemoSelectAvatarViewController *vc = [[VEIMDemoSelectAvatarViewController alloc] initWithType:VEIMDemoSelectAvatarTypeGroup];
                vc.title = @"修改群头像";
                vc.selectCallBack = ^(NSString * _Nonnull url) {
                    BIMGroupInfo *groupInfo = [[BIMGroupInfo alloc] init];
                    groupInfo.avatarURL = url;
                    [[BIMClient sharedInstance] setGroupInfo:self.conversation.conversationID groupInfo:groupInfo completion:^(BIMError * _Nullable error) {
                        @strongify(self);
                        if (error) {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群头像失败: %@", error.localizedDescription]];
                            return;
                        }
                        
                        BIMUser *user = [BIMUIClient sharedInstance].userProvider(self.currentParticant.userID);
                        
                        NSString *name = [BIMUICommonUtility getSystemMessageUserNameWithUser:user member:self.currentParticant];
                        NSString *msgStr = [NSString stringWithFormat:@"%@修改了群头像", name];
                        BIMMessage *msg = [[BIMClient sharedInstance] createCustomMessage:@{@"text":msgStr, @"type":@(kBIMMessageTypeSystem)}];
                        [[BIMClient sharedInstance] sendMessage:msg conversationId:self.conversation.conversationID saved:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {} progress:^(int progress) {} completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {}];
                        [self createSettingModels];
                    }];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            [self.settings addObject:iconSetting];
            
            //修改群描述
            VEIMDemoSettingModel *descSetting = [VEIMDemoSettingModel settingWithTitle:@"群描述" detail:self.conversation.desc isNeedSwitch:NO switchOn:NO];
            descSetting.clickHandler = ^{
                @strongify(self);
                VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"群描述" text:self.conversation.desc maxWordCount:100 editable:YES handler:^(NSString * _Nonnull text) {
                    BIMGroupInfo *groupInfo = [[BIMGroupInfo alloc] init];
                    groupInfo.desc = text;
                    [[BIMClient sharedInstance] setGroupInfo:self.conversation.conversationID groupInfo:groupInfo completion:^(BIMError * _Nullable error) {
                        @strongify(self);
                        if (error) {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群描述失败: %@", error.localizedDescription]];
                            return;
                        } 
                        
                        BIMUser *user = [BIMUIClient sharedInstance].userProvider(self.currentParticant.userID);
                        
                        NSString *name = [BIMUICommonUtility getSystemMessageUserNameWithUser:user member:self.currentParticant];
                        NSString *msgStr = [NSString stringWithFormat:@"%@修改了群描述", name];
                        BIMMessage *msg = [[BIMClient sharedInstance] createCustomMessage:@{@"text":msgStr, @"type":@(kBIMMessageTypeSystem)}];
                        [[BIMClient sharedInstance] sendMessage:msg conversationId:self.conversation.conversationID saved:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {} progress:^(int progress) {} completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {}];
                        [self createSettingModels];
                    }];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            };
            [self.settings addObject:descSetting];
        }
        
        //群主管理
        if (self.currentParticant.role == BIM_MEMBER_ROLE_OWNER) {
            VEIMDemoSettingModel *ownerSetting = [VEIMDemoSettingModel settingWithTitle:@"设置管理员" detail:@"" isNeedSwitch:NO switchOn:NO];
            ownerSetting.clickHandler = ^() {
                @strongify(self);
                self.actionType = VEIMDemoConversationActionTypeManageParticipants;
                self.oldManagers = [NSMutableArray array];
                NSMutableArray *users = [NSMutableArray array];
                NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
                for (id <BIMMember> participant in participants) {
                    VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
                    BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
                    user.name = [BIMUICommonUtility getShowNameInGroupWithUser:u member:participant];
                    user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
                    user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
                    user.userIDNumber = participant.userID;
                    user.userIDString = participant.userIDString;
                    
                    user.isNeedSelection = YES;
                    if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
                        user.role = @"管理员";
                        user.isSelected = YES;
                        [self.oldManagers addObject:user];
                    } else if (participant.role == BIM_MEMBER_ROLE_OWNER) {
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
                [self.navigationController pushViewController:userController animated:YES];
            };
            [self.settings addObject:ownerSetting];
        }

        //群昵称
        VEIMDemoSettingModel *myAlias = [VEIMDemoSettingModel settingWithTitle:@"我的群昵称" detail:self.currentParticant.alias ?: @"" isNeedSwitch:NO switchOn:NO];
        myAlias.clickHandler = ^{
            @strongify(self);
            VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"我的群昵称" text:self.currentParticant.alias ?: @"" maxWordCount:100 editable:YES handler:^(NSString * _Nonnull text) {
                NSString *alias = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (alias.length == 0 && text.length > 0) {
                    /// 昵称不能为纯空格，可以为 @""
                    [BIMToastView toast:@"昵称不可为空"];
                    return;
                }
                [[BIMClient sharedInstance] setUserSelfGroupMemberAlias:self.conversation.conversationID alias:text completion:^(BIMError * _Nullable error) {
                    @strongify(self);
                    if (error) {
                        if (error.code == BIM_SERVER_SET_GROUP_INFO_REJECT) {
                            [BIMToastView toast:@"文本中可能包含敏感词，请修改后重试"];
                        } else {
                            [BIMToastView toast:[NSString stringWithFormat:@"更改群昵称失败: %@", error.localizedDescription]];
                        }
                    } else {
                        /// 刷新当前群成员信息
                        self.currentParticant = self.conversation.currentMember;
                        [self createSettingModels];
                    }
                }];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        };
        [self.settings addObject:myAlias];
    }
    
    //置顶
    VEIMDemoSettingModel *stickTop = [VEIMDemoSettingModel settingWithTitle:@"置顶聊天" detail:@"" isNeedSwitch:YES switchOn:self.conversation.isStickTop];
    stickTop.switchHandler = ^(UISwitch * _Nonnull swt) {
        @strongify(self);
        [[BIMClient sharedInstance] stickTopConversation:self.conversation.conversationID isStickTop:swt.on completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"置顶失败：%@",error.localizedDescription]];
            }
        }];
    };
    [self.settings addObject:stickTop];
    
    //消息免打扰
    VEIMDemoSettingModel *mute = [VEIMDemoSettingModel settingWithTitle:@"消息免打扰" detail:@"" isNeedSwitch:YES switchOn:self.conversation.isMute];
    mute.switchHandler = ^(UISwitch * _Nonnull swt) {
        @strongify(self);
        [[BIMClient sharedInstance] muteConversation:self.conversation.conversationID mute:swt.on completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"设置失败：%@",error.localizedDescription]];
                }
        }];
    };
    [self.settings addObject:mute];
    
    //搜索消息记录
    VEIMDemoSettingModel *searchMessage = [VEIMDemoSettingModel settingWithTitle:@"搜索消息记录" detail:@"" isNeedSwitch:NO switchOn:NO];
    searchMessage.clickHandler = ^{
        @strongify(self);
        
        VEIMDemoSearchResultContainer *vc = [[VEIMDemoSearchResultContainer alloc] initWithConversationID:self.conversation.conversationID conversationType:self.conversation.conversationType direction:BIM_PULL_DIRECTION_DESC];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [controllers removeObjectAtIndex:1];
        self.navigationController.viewControllers = controllers;
        
    };
    [self.settings addObject:searchMessage];

    
    //解散群聊
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT && self.currentParticant.role == BIM_MEMBER_ROLE_OWNER) {
        VEIMDemoSettingModel *dismiss = [VEIMDemoSettingModel settingWithTitle:@"解散群聊" detail:@"" isNeedSwitch:NO switchOn:NO];
        dismiss.clickHandler = ^() {
            @strongify(self);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"解散群聊" message:@"确定要解散群聊吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[VEIMDemoIMManager sharedManager] dismissCon:self.conversation completion:^(NSError * _Nullable error) {
                    if (!error) {
                        [[BIMClient sharedInstance] deleteConversation:self.conversation.conversationID completion:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }];
            [alertVC addAction:sure];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [self presentViewController:alertVC animated:YES completion:nil];
        };
        [self.settings addObject:dismiss];
    }
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        //退出群聊
        VEIMDemoSettingModel *quit = [VEIMDemoSettingModel settingWithTitle:@"退出群聊" detail:@"" isNeedSwitch:NO switchOn:NO];
        quit.clickHandler = ^() {
            @strongify(self);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"退出群聊" message:@"确定要退出群聊吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[VEIMDemoIMManager sharedManager] quitCon:self.conversation completion:^(NSError * _Nullable error) {
                    if (!error) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [BIMToastView toast:[NSString stringWithFormat:@"退出群聊失败：%@",error.localizedDescription]];
                    }
                }];
            }];
            [alertVC addAction:sure];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [self presentViewController:alertVC animated:YES completion:nil];
        };
        [self.settings addObject:quit];
    }
    
    VEIMDemoSettingModel *deleteAllLocalMsgsExt = [VEIMDemoSettingModel settingWithTitle:@"清空聊天记录" detail:@"" isNeedSwitch:NO switchOn:NO];
    deleteAllLocalMsgsExt.clickHandler = ^() {
        @strongify(self);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定后将删除本地聊天记录" message:@" " preferredStyle:UIAlertControllerStyleAlert];
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 270, 40)];
        UIButton *checkMark = [UIButton buttonWithType:UIButtonTypeCustom];
        checkMark.frame = CGRectMake(50, 20, 30, 30);
        [checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_normal"] forState:UIControlStateNormal];
        [checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_sel"] forState:UIControlStateSelected];
        [checkMark addTarget:self action:@selector(checkMarkClick:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:checkMark];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 30)];
        label.text = @"同时删除漫游聊天记录";
        label.font = [UIFont systemFontOfSize:14];
        [customView addSubview:label];
        [alertVC.view addSubview:customView];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            BIMClearConversationMessageType type = BIMClearConversationMessageTypeLocalDevice;
            if (checkMark.isSelected) {
                type = BIMClearConversationMessageTypeAllMyDevices;
            }
            [[BIMClient sharedInstance] clearConversationMessage:self.conversation.conversationID type:type completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"清空聊天记录失败：%@",error.localizedDescription]];
                }
            }];
        }];
        [alertVC addAction:sure];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    };
    [self.settings addObject:deleteAllLocalMsgsExt];
    
    if ([BIMUICommonUtility isRobotConversation:self.conversation]) {
        VEIMDemoSettingModel *markNewChat = [VEIMDemoSettingModel settingWithTitle:@"清除上下文" detail:@"" isNeedSwitch:NO switchOn:NO];
        markNewChat.clickHandler = ^() {
            @strongify(self);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"清除上下文" message:@"是否确认清除上下文内容，开启新的对话？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[VEIMDemoIMManager sharedManager] sendSystemMessage:@"已清除上下文" convId:self.conversation.conversationID completion:^(NSError * _Nullable error) {
                    if (error) {
                        return;
                    }
                    
                    [[BIMClient sharedInstance] markNewChat:self.conversation.conversationID needNotice:YES completion:^(BIMError * _Nullable bimError) {
                        NSError *error;
                        if (bimError) {
                            error = [NSError errorWithDomain:kVEIMDemoErrorDomain code:bimError.code userInfo:@{NSLocalizedDescriptionKey : bimError.localizedDescription}];
                            [BIMToastView toast:[NSString stringWithFormat:@"清除上下文失败：%@", error.localizedDescription]];
                        }
                    }];
                }];
            }];
            [alertVC addAction:sure];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [self presentViewController:alertVC animated:YES completion:nil];
        };
        [self.settings addObject:markNewChat];
    }

    VEIMDemoSettingModel *setExt = [VEIMDemoSettingModel settingWithTitle:@"自定义字段" detail:@"" isNeedSwitch:NO switchOn:NO];
    setExt.clickHandler = ^() {
        @strongify(self);
        VEIMDemoConversationExtController *vc = [[VEIMDemoConversationExtController alloc] initWithConversation:self.conversation];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.settings addObject:setExt];
    
    //#ifdef UI_INTERNAL_TEST
        //搜索消息记录
        VEIMDemoSettingModel *conversationDetail = [VEIMDemoSettingModel settingWithTitle:@"会话详情" detail:@"" isNeedSwitch:NO switchOn:NO];
        conversationDetail.clickHandler = ^{
            @strongify(self);
            VEIMDemoConversationDetailDebugViewController *vc = [[VEIMDemoConversationDetailDebugViewController alloc] init];
            vc.conversation = self.conversation;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [self.settings addObject:conversationDetail];
        
    //#endif

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

#pragma mark - Action

- (void)checkMarkClick: (UIButton *)sender
{
    sender.selected = !sender.selected;
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
                if (participant.userID != [VEIMDemoUserManager sharedManager].currentUser.userIDNumber) {
                    if (participant.role == BIM_MEMBER_ROLE_OWNER) {
//                        user.role = @"群主";
//                        user.isNeedSelection = NO;
                        continue;
                    }
                    VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
                    user.userIDNumber = participant.userID;
                    user.userIDString = participant.userIDString;
                    BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
                    user.name = [BIMUICommonUtility getShowNameInGroupWithUser:u member:participant];
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
                BIMUser *u = [BIMUIClient sharedInstance].userProvider(participant.userID);
                VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
                user.userIDNumber = participant.userID;
                user.userIDString = participant.userIDString;
                user.name = [BIMUICommonUtility getShowNameInGroupWithUser:u member:participant];
                user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
                user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
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
            userController.isShowSearcTextField = self.conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT;
            userController.conversation = self.conversation;
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
            user.name = [BIMUICommonUtility getShowNameInGroupWithUser:u member:participant];
            user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
            user.avatarUrl = participant.avatarURL.length ? participant.avatarURL : u.portraitUrl;
            user.userIDNumber = participant.userID;
            user.userIDString = participant.userIDString;
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
    [self jumpToProfileViewControllerWithUid:user.userIDNumber];
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
