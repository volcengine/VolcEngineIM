//
//  BIMBaseConversationListController.m
//  im-uikit-tob
//
//  Created by hexi on 2023/11/20.
//

#import "BIMBaseConversationListController.h"

#import "BIMUIDefine.h"
#import "BIMToastView.h"
#import "BIMConversationCell.h"
#import "BIMChatViewController.h"
#import "BIMConversationListDataSourceProtocol.h"
#import "BIMBaseConversationListController+Private.h"
#import "BIMUIClient.h"

#import <imsdk-tob/BIMSDK.h>

@interface BIMBaseConversationListController () <UITableViewDelegate, UITableViewDataSource, BIMConversationListDataSourceDelegate, BIMConversationCellDelegate, BIMFriendListener>
@end

@implementation BIMBaseConversationListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = NO;
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendListener:self];
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
    if (![BIMClient sharedInstance].getCurrentUserID) {
        return;
    }
    [self setupDataSource];
    self.conversationDataSource.delegate = self;
    self.conversationDataSource.pageSize = 100;
    
    [[BIMClient sharedInstance] addFriendListener:self];
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
    cell.delegate = self;
    [cell refreshWithConversation:conv];
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

    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (cell.conversation.conversationID.length) {
            kWeakSelf(self);
            [[BIMClient sharedInstance] deleteConversation:cell.conversation.conversationID completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"删除失败: %@",error.localizedDescription]];
                }else{
                    [weakself.tableview reloadData];
                }
            }];
        }
    }];
    [alertVC addAction:delete];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];

    [self presentViewController:alertVC animated:YES completion:nil];
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
