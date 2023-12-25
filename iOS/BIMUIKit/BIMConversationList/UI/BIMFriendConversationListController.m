//
//  BIMFriendConversationListController.m
//  im-uikit-tob
//
//  Created by hexi on 2023/11/20.
//

#import "BIMFriendConversationListController.h"

#import "BIMUIDefine.h"
#import "BIMFriendConversationListDataSource.h"
#import "BIMBaseConversationListController+Private.h"

#import <OneKit/BTDMacros.h>
#import <Masonry/View+MASShorthandAdditions.h>

@interface BIMFriendConversationListController ()

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UILabel *label;

@end

@implementation BIMFriendConversationListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLogin = NO;
        self.type = BIMConversationListTypeFriendConversation;
        /// 好友会话列表需要在 init 时就监听登录通知，否则会导致好友会话未读数展现不及时
        [super registerNotification];
    }
    return self;
}

- (void)setupUIElements
{
    [super setupUIElements];
    [self.view addSubview:self.label];
    [self makeSubViewsConstraints];
}

- (void)makeSubViewsConstraints
{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(@(130));
        make.height.equalTo(@(30));
    }];
}

- (void)userDidLogin
{
    if (self.isLogin) {
        return;
    }
    self.isLogin = YES;
    [self setupDataSourceIfNeed];
    /// 因为 TIMO 缓存层问题可能拉取到的会话没有 setUp 完成，导致获取不到 lastMsg
    /// 所以延迟执行会话拉去动作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        [self loadNexPageConversations];
    });
}

- (void)userDidLogout
{
    if (!self.isLogin) {
        return;
    }
    self.isLogin = NO;
    [super userDidLogout];
}

- (void)setupDataSource
{
    super.conversationDataSource = [[BIMFriendConversationListDataSource alloc] init];
}

- (void)loadNexPageConversations
{
    kWeakSelf(self);
    [self.conversationDataSource loadNexPageConversationsWithCompletion:^(BIMError * _Nullable error) {
        kStrongSelf(self);
        if (BTD_isEmptyArray(self.conversationDataSource.conversationList)) {
            self.tableview.hidden = YES;
            self.label.hidden = NO;
            return;
        } 

        self.tableview.hidden = NO;
        self.label.hidden = YES;
        [self.tableview reloadData];
        if (self.conversationDataSource.hasMore) {
            [self.tableview.mj_footer endRefreshing];
        } else {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)conversationDataSourceDidReloadAllConversations:(id<BIMConversationListDataSourceProtocol>)dataSource
{
    if (BTD_isEmptyArray(self.conversationDataSource.conversationList)) {
        self.tableview.hidden = YES;
        self.label.hidden = NO;
        return;
    } 
    self.tableview.hidden = NO;
    self.label.hidden = YES;
    [self.tableview reloadData];
}

#pragma mark - Getter

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.hidden = YES;
        _label.text = @"暂无好友会话";
        _label.textColor = [UIColor darkGrayColor];
    }
    return _label;
}

@end
