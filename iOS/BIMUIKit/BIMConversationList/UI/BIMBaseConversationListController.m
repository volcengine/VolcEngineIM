//
//  BIMBaseConversationListController.m
//  im-uikit-tob
//
//  Created by hexi on 2023/11/20.
//

#import "BIMBaseConversationListController.h"
#import "BIMUnreadMessageListViewController.h"

#import "BIMUIDefine.h"
#import "BIMToastView.h"
#import "BIMConversationCell.h"
#import "BIMChatViewController.h"
#import "BIMConversationListDataSourceProtocol.h"
#import "BIMBaseConversationListController+Private.h"
#import "BIMUIClient.h"
#import "BIMUICommonUtility.h"
//#import "BIMClient.h"

#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>
#import <OneKit/ByteDanceKit.h>

@interface BIMBaseConversationListController () <UITableViewDelegate, UITableViewDataSource, BIMConversationListDataSourceDelegate, BIMConversationCellDelegate, BIMFriendListener, BIMGroupMemberListener>

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<BIMMember>> *convMemberDict;

@end

@implementation BIMBaseConversationListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = NO;
        self.convMemberDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendListener:self];
    [[BIMClient sharedInstance] removeGroupMemberListener:self];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self setupDataSourceIfNeed];
    [self loadNexPageConversations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tableview reloadData];
}

- (void)setupUIElements
{
    [super setupUIElements];
    [self.tableview registerClass:[BIMConversationCell class] forCellReuseIdentifier:@"BIMConversationCell"];
}

- (BOOL)footerPullEnable
{
    return YES;
}

- (void)footerPulled
{
    [self loadNexPageConversations];
}

- (void)registerNotification
{
    [super registerNotification];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:kUserDidLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfileUpdateNotify:) name:kBIMUserProfileUpdateNotification object:nil];
}

- (void)userDidLogin
{
    [self setupDataSourceIfNeed];
    [self loadNexPageConversations];
}

- (void)userDidLogout
{
    self.conversationDataSource = nil;
    [self.tableview reloadData];
}

- (void)setupDataSourceIfNeed
{
    if (self.conversationDataSource) {
        return;
    }
    // 登录
    if (![BIMClient sharedInstance].getToken) {
        return;
    }
    [self setupDataSource];
    self.conversationDataSource.delegate = self;
    self.conversationDataSource.pageSize = 100;
    
    [[BIMClient sharedInstance] addFriendListener:self];
    [[BIMClient sharedInstance] addGroupMemberListener:self];
}

/// @override
- (void)setupDataSource
{
}

#pragma mark - loadData

- (void)loadNexPageConversations
{
    kWeakSelf(self);
    [self.conversationDataSource loadNexPageConversationsWithCompletion:^(BIMError * _Nullable error) {
        kStrongSelf(self)
        [self.tableview reloadData];
        if (self.conversationDataSource.hasMore) {
            [self.tableview.mj_footer endRefreshing];
        } else {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationDataSource.conversationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMConversationCell"];
    BIMConversation *conv;
    if (self.conversationDataSource.conversationList.count) {
        conv = self.conversationDataSource.conversationList[indexPath.row];
    }
    [self prepareCell:cell forConverastion:conv];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BIMConversation *conv = self.conversationDataSource.conversationList[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(conversationListController:didSelectConversation:)]) {
        [self.delegate conversationListController:self didSelectConversation:conv];
    }
}

#pragma mark - Private

- (void)reloadData
{
    btd_dispatch_async_on_main_queue(^{
        [self.tableview reloadData];
    });
}

- (void)prepareCell:(BIMConversationCell *)cell forConverastion:(BIMConversation *)converastion
{
    cell.delegate = self;
    if (converastion.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        long long userID = converastion.lastMessage.senderUID;
        id<BIMMember> member = [self.convMemberDict btd_objectForKey:converastion.conversationID default:nil];
        if (!userID || member.userID == userID) {
            [cell refreshWithConversation:converastion member:member];
        } else {
            [cell refreshWithConversation:converastion];
            @weakify(self);
            [[BIMClient sharedInstance] getConversationMemberList:@[@(userID)] inConversationId:converastion.conversationID completion:^(NSArray<id<BIMMember>> * _Nullable members, BIMError * _Nullable error) {
                @strongify(self);
                id<BIMMember> newMember = members.firstObject;
                if (!newMember || error) {
                    return;
                }
                btd_dispatch_async_on_main_queue(^{
                    if (![cell.conversation.conversationID isEqualToString:newMember.conversationID]) {
                        return;
                    }
                    [self.convMemberDict btd_setObject:newMember forKey:converastion.conversationID];
                    [cell refreshWithConversation:converastion member:newMember];
                });
            }];
        }
    } else {
        [cell refreshWithConversation:converastion];
    }
}

#pragma mark - BIMConversationListDataSourceDelegate

- (void)conversationDataSourceDidReloadAllConversations:(id<BIMConversationListDataSourceProtocol>)dataSource
{
    [self.tableview reloadData];
}

- (void)conversationDataSource:(id<BIMConversationListDataSourceProtocol>)dataSource onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount
{
    if ([self.delegate respondsToSelector:@selector(conversationListController:onTotalUnreadMessageCountChanged:)]) {
        [self.delegate conversationListController:self onTotalUnreadMessageCountChanged:totalUnreadCount];
    }
}

- (void)cellDidLongPress:(BIMConversationCell *)cell
{
    UIAlertController *alertVC = [[UIAlertController alloc] init];
    /// 先取出 cell 对应会话，防止之后从 cell 被复用取出错误会话
    BIMConversation *conversation = cell.conversation;
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (conversation.conversationID.length) {
            @weakify(self);
            [[BIMClient sharedInstance] deleteConversation:conversation.conversationID completion:^(BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"删除失败: %@",error.localizedDescription]];
                }else{
                    [self.tableview reloadData];
                }
            }];
        }
    }];
    [alertVC addAction:delete];
#ifdef UI_INTERNAL_TEST
    UIAlertAction *queryUnreadMessage = [UIAlertAction actionWithTitle:@"查询未读消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (conversation.conversationID.length) {
            BIMUnreadMessageListViewController *vc = [[BIMUnreadMessageListViewController alloc] init];
            vc.conversation = conversation;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [alertVC addAction:queryUnreadMessage];
#endif

    @weakify(self);
    UIAlertAction *clearMessage = [UIAlertAction actionWithTitle:@"清空聊天记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        NSString *conversationID = conversation.conversationID;
        if (BTD_isEmptyString(conversationID)) {
            return;
        }
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
            @strongify(self);
            NSString *conversationID = conversation.conversationID;
            if (BTD_isEmptyString(conversationID)) {
                return;
            }
            BIMClearConversationMessageType type = BIMClearConversationMessageTypeLocalDevice;
            if (checkMark.isSelected) {
                type = BIMClearConversationMessageTypeAllMyDevices;
            }
            [[BIMClient sharedInstance] clearConversationMessage:conversationID type:type completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"清空聊天记录失败：%@",error.localizedDescription]];
                }
            }];
        }];
        [alertVC addAction:sure];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    [alertVC addAction:clearMessage];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];

    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Action

- (void)checkMarkClick: (UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - BIMGroupMemberListener

- (void)onBatchMemberInfoChanged:(BIMConversation *)conversation members:(NSArray<id<BIMMember>> *)members
{
    id<BIMMember> oldMember = [self.convMemberDict btd_objectForKey:conversation.conversationID default:nil];
    if (oldMember) {
        [members enumerateObjectsUsingBlock:^(id<BIMMember>  _Nonnull member, NSUInteger idx, BOOL * _Nonnull stop) {
            if (member.userID == oldMember.userID) {
                [self.convMemberDict btd_setObject:member forKey:conversation.conversationID];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - BIMFriendListener

// 备注等更新
- (void)onFriendUpdate:(BIMUserFullInfo *)info
{
    [self.tableview reloadData];
}

// 用户信息更新（需要确认user是否会写入混链）
- (void)onUserProfileUpdate:(BIMUserFullInfo *)info
{
    [self.tableview reloadData];
}

#pragma mark - Notification

- (void)userProfileUpdateNotify:(NSNotification *)notify
{
    [self.tableview reloadData];
}

@end
