//
//ConversationListController.m
//
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMConversationListController.h"
#import "BIMUIDefine.h"
#import "BIMConversationCell.h"
#import "BIMToastView.h"
#import "BIMChatViewController.h"
#import "BIMConversationListDataSource.h"

#import <imsdk-tob/BIMSDK.h>


@interface BIMConversationListController () <UITableViewDelegate, UITableViewDataSource, BIMConversationListDataSourceDelegate, BIMConversationCellDelegate>
@property (nonatomic, strong) BIMConversationListDataSource *conversationDataSource;

@end

@implementation BIMConversationListController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [self.tableview registerClass:[BIMConversationCell class] forCellReuseIdentifier:@"BIMConversationCell"];
}

- (BOOL)footerPullEnable{
    return YES;
}

- (void)footerPulled{
    [self loadNexPageConversations];
}

- (void)registerNotification{
    [super registerNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kUserDidLogoutNotification object:nil];
}

- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:kUserDidLoginNotification]) {
        [self userDidLogin];
    }else if ([noti.name isEqualToString:kUserDidLogoutNotification]){
        [self userDidLogout];
    }
}

- (void)userDidLogin{
    [self setupDataSource];
}

- (void)userDidLogout{
    self.conversationDataSource = nil;
    [self.tableview reloadData];
}

- (void)setupDataSource
{
    if (self.conversationDataSource) {
        return;
    }
    // 登录
    if (![BIMClient sharedInstance].getCurrentUserID) {
        return;
    }
    // 登录成功后才能初始化 IM_ConversationsDataSource
    self.conversationDataSource = [[BIMConversationListDataSource alloc] init];
    self.conversationDataSource.delegate = self;
    self.conversationDataSource.pageSize = 100;
    [self loadNexPageConversations];
}

#pragma mark - loadData

- (void)loadNexPageConversations
{
    kWeakSelf(self);
    [self.conversationDataSource loadNexPageConversationsWithCompletion:^(NSError * _Nullable error) {
        [weakself.tableview reloadData];
        if (weakself.conversationDataSource.hasMore) {
            [weakself.tableview.mj_footer endRefreshing];
        } else {
            [weakself.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.convDataSource.numberOfItems;
    return self.conversationDataSource.conversationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BIMConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMConversationCell"];
    BIMConversation *conv = self.conversationDataSource.conversationList[indexPath.row];
    cell.delegate = self;
    [cell refreshWithConversation:conv];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BIMConversation *conv = self.conversationDataSource.conversationList[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(conversationListController:didSelectConversation:)]) {
        [self.delegate conversationListController:self didSelectConversation:conv];
    }
}


#pragma mark - BIMConversationListDataSourceDelegate

- (void)conversationDataSourceDidReloadAllConversations:(BIMConversationListDataSource *)dataSource
{
    [self.tableview reloadData];
}

- (void)conversationDataSource:(BIMConversationListDataSource *)dataSource onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount
{
    if ([self.delegate respondsToSelector:@selector(conversationListController:onTotalUnreadMessageCountChanged:)]) {
        [self.delegate conversationListController:self onTotalUnreadMessageCountChanged:totalUnreadCount];
    }
}

- (void)cellDidLongPress:(BIMConversationCell *)cell{
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

@end
