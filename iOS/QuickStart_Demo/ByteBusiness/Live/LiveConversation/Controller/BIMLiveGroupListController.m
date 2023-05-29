//
//  BIMLiveGroupListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMLiveGroupListController.h"
#import "BIMLiveGroupCell.h"
#import "BIMUIDefine.h"
#import "BIMLiveGroupListDataSource.h"
#import "VEIMDemoDefine.h"

#import <OneKit/BTDMacros.h>

@interface BIMLiveGroupListController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BIMLiveGroupCellDelegate, BIMLiveGroupListDataSourceDelegate>

@property(nonatomic, strong) BIMLiveGroupListDataSource *liveGroupDataSource;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, copy) NSArray *arr;
@property(nonatomic, strong) UIView *emptyView;

@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation BIMLiveGroupListController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.isNeedLeftBack = NO;
//    }
//    return self;
//}

- (instancetype)initWithType:(VEIMDemoLiveGroupListType)type
{
    if (self = [super init]) {
        self.listType = type;
        if (type == VEIMDemoLiveGroupListMain) {
            self.isNeedLeftBack = NO;
        } else {
            self.isNeedLeftBack = YES;
            // 全部直播群列表搜索框
            self.searchBar = [[UISearchBar alloc] init];
            self.searchBar.backgroundColor = [UIColor whiteColor];
            self.searchBar.placeholder = @"输入直播群ID或群名";
            self.searchBar.delegate = self;
            
            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmptyView:)];
            [self.emptyView addGestureRecognizer:self.tapGesture];
        }
        self.arr = [NSArray array];
        self.liveGroupDataSource = [[BIMLiveGroupListDataSource alloc] initWithType:self.listType];
        self.liveGroupDataSource.delegate = self;
        self.liveGroupDataSource.pageSize = 100;
        [self loadNexPageLiveGroups];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.modalPresentationCapturesStatusBarAppearance = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    // TODO: 待优化
    if (self.searchBar) {
        [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, 60)];
        [self.view addSubview:self.searchBar];
        [self.tableview setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height + 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    }
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    [self.tableview registerClass:[BIMLiveGroupCell class] forCellReuseIdentifier:@"VEIMDemoLiveGroupCell"];
}

- (BOOL)footerPullEnable{
    return YES;
}

- (void)footerPulled
{
    [self loadNexPageLiveGroups];
}

- (void)registerNotification
{
    [super registerNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLogoutNotification object:nil];
    // 直播群解散通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:@"dismissLiveGroup" object:nil];
    // 直播群信息更改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:@"liveGroupSettingChanged" object:nil];
    // 创建直播群
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:@"createLiveGroupSucess" object:nil];
}

- (void)didReceiveNoti:(NSNotification *)noti
{
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification]) {
        [self userDidLogin];
    }else if ([noti.name isEqualToString:kVEIMDemoUserDidLogoutNotification]){
        [self userDidLogout];
    }else if ([noti.name isEqualToString:@"dismissLiveGroup"]) {
        [self removeLiveGroupFromListWith:noti.object];
    }else if ([noti.name isEqualToString:@"liveGroupSettingChanged"]) {
        [self updateLiveGroupWithConv:noti.object];
    }else if ([noti.name isEqualToString:@"createLiveGroupSucess"]) {
        [self addLiveGroupToListWith:noti.object];
    }
}

- (void)userDidLogin
{
    // 登录成功后初始化dataSource
    self.liveGroupDataSource = [[BIMLiveGroupListDataSource alloc] initWithType:self.listType];
    self.liveGroupDataSource.delegate = self;
    self.liveGroupDataSource.pageSize = 100;
    [self loadNexPageLiveGroups];
}

- (void)userDidLogout
{
    self.liveGroupDataSource = nil;
    [self.tableview reloadData];
}

#pragma mark - updateTableList
- (void)updateLiveGroupWithConv:(BIMConversation *)conv
{
    [self.liveGroupDataSource updateLiveGroupWithConv:conv];
}

- (void)addLiveGroupToListWith:(BIMConversation *)conv
{
    [self.liveGroupDataSource addLiveGroupToListWithConv:conv];
}

- (void)removeLiveGroupFromListWith:(BIMConversation *)conv
{
    [self.liveGroupDataSource removeLiveGroupFromListWith:conv];
}

- (void)loadNexPageLiveGroups
{
    @weakify(self);
    [self.liveGroupDataSource loadNexPageLiveGroupWithCompletion:^(NSError * _Nullable error) {
        @strongify(self);
        [self.tableview reloadData];
        if (self.liveGroupDataSource.hasMore) {
            [self.tableview.mj_footer endRefreshing];
        } else {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}

#pragma mark - tableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//      return self.liveGroupDataSource.liveGroupList.count;
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMLiveGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoLiveGroupCell"];
//    BIMConversation *conv = self.liveGroupDataSource.liveGroupList[indexPath.row];
    BIMConversation *conv = self.arr[indexPath.row];
    cell.delegate = self;
    // 根据conv构造cell
    [cell refreshWithCoversation:conv];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BIMConversation *conv = self.liveGroupDataSource.liveGroupList[indexPath.row];
    BIMConversation *conv = self.arr[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(liveGroupListController:didSelectLiveGroup:)]) {
        [self.delegate liveGroupListController:self didSelectLiveGroup:conv];
    }
}

- (void)liveGroupDataSourceDidReloadAllLiveGroup:(BIMLiveGroupListDataSource *)dataSource
{
    self.arr = [dataSource.liveGroupList copy];
    [self.tableview reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate;
    NSArray *tempArr = [NSArray array];
    if (searchText.length <= 0) {
        tempArr = [NSArray arrayWithArray:self.liveGroupDataSource.liveGroupList];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"name contains %@",searchText];
        tempArr = [self.liveGroupDataSource.liveGroupList filteredArrayUsingPredicate:predicate];
    }
    self.arr = [tempArr copy];
    [self.tableview reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view addSubview:self.emptyView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - EmptyView
- (UIView *)emptyView
{
    if (!_emptyView) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _emptyView = [[UIView alloc] initWithFrame:self.view.frame];
        _emptyView.backgroundColor = [UIColor clearColor];
        _emptyView.userInteractionEnabled = YES;
    }
    return _emptyView;
}

// 点击空白关闭键盘
- (void)tapEmptyView:(id)sender
{
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        [self.searchBar resignFirstResponder];
    }
}

@end
