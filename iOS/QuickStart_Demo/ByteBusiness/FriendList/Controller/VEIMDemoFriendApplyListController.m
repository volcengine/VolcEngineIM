//
//  VEIMDemoFriendApplyListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendApplyListController.h"
#import "VEIMDemoFriendApplyListCell.h"
#import "VEIMDemoFriendApplyListDataSource.h"

//#import <imsdk-tob/BIMClient+conversation.h>
#import <imsdk-tob/BIMClient+Friend.h>
#import <im-uikit-tob/BIMUser.h>
#import <imsdk-tob/BIMClient+Friend.h>
#import <OneKit/BTDMacros.h>
#import <im-uikit-tob/BIMToastView.h>

@interface VEIMDemoFriendApplyListController () <VEIMDemoFriendApplyListCellDelegate, VEIMDemoFriendApplyListDataSourceDelegate>

@property (nonatomic, strong) VEIMDemoFriendApplyListDataSource *dataSource;
@property (nonatomic, copy) NSArray<BIMFriendApplyInfo *> *friendApplyList;
@property (nonatomic, strong) NSMutableDictionary *friendApplyDict;

@end

@implementation VEIMDemoFriendApplyListController

- (instancetype)init
{
    if (self = [super init]) {
        _dataSource = [[VEIMDemoFriendApplyListDataSource alloc] init];
        _dataSource.delegate = self;
        _dataSource.pageSize = 20;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"好友申请";
    // ⚠️进入好友申请页面后，好友申请未读数清零
    [[BIMClient sharedInstance] markFriendApplyRead:nil];
    
    // ⚠️排序按照申请时间排序（后续看接口提供的是已经排序好的数据，还是需要获取后端上排序）
    [self loadFriendApplyData];
}

- (void)setupUIElements
{
    [super setupUIElements];
    [self.tableview registerClass:[VEIMDemoFriendApplyListCell class] forCellReuseIdentifier:@"VEIMDemoFriendApplyListCell"];
}

- (BOOL)footerPullEnable
{
    return YES;
}

- (void)footerPulled
{
    [self loadFriendApplyData];
}

#pragma mark - updateData
- (void)loadFriendApplyData
{
    @weakify(self);
    [self.dataSource loadFriendApplyWithCompletion:^(NSError * _Nullable error) {
        @strongify(self);
        [self.tableview reloadData];
        if (self.dataSource.hasMore) {
            [self.tableview.mj_footer endRefreshing];
        } else {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - tableViewDelegate & datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoFriendApplyListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"VEIMDemoFriendApplyListCell"];
    cell.applyInfo = self.friendApplyList[indexPath.row];
    cell.delegate = self;
    [cell configCell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendApplyList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - VEIMDemoFriendApplyListCellDelegate

/// 接受好友申请
/// toast：操作成功
/// btn消失，显示“已通过”状态
/// 向对方发出 “我已通过你的好友申请”
/// 通讯录列表出现A
- (void)didAcceptFriendApply:(VEIMDemoFriendApplyListCell *)cell
{
    // 同意好友申请回调
    long long uid = cell.applyInfo.fromUid;
    BIMReplyInfo *replyInfo = [[BIMReplyInfo alloc] init];
    replyInfo.uid = uid;
    replyInfo.replyType = BIM_FRIEND_REPLY_AGREE;
    
    [[BIMClient sharedInstance] replyFriendApply:replyInfo completion:^(BIMError * _Nullable error) {
        if (error) {
            NSString *toastStr = error.localizedDescription;
            if (error.code == BIM_FRIEND_MORE_THAN_LIMIT) {
                toastStr = @"你的好友数量已到上限，请删除部分好友后重试";
            } else if (error.code == BIM_SERVER_FROM_USER_FRIEND_MORE_THAN_LIMIT) {
                toastStr = @"操作失败，对方的好友数量已到上限";
            }
            [BIMToastView toast:[NSString stringWithFormat:@"%@", toastStr]];
        } else {
            [BIMToastView toast:@"操作成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
        }
    }];
}

/// 拒绝好友申请
/// toast：操作成功
/// btn消失，显示“已拒绝”状态
- (void)didRejectFriendApply:(VEIMDemoFriendApplyListCell *)cell
{
    // 拒绝好友申请回调
    long long uid = cell.applyInfo.fromUid;
    BIMReplyInfo *replyInfo = [[BIMReplyInfo alloc] init];
    replyInfo.uid= uid;
    replyInfo.replyType = BIM_FRIEND_REPLY_REFUSE;
    
    [[BIMClient sharedInstance] replyFriendApply:replyInfo completion:^(BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [BIMToastView toast:@"操作成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
        }
    }];
}

- (void)friendApplyDataSourceDidReloadFriendApplyList:(nonnull VEIMDemoFriendApplyListDataSource *)dataSource {
    // 判断当前是否在好友申请页
    if (self.isViewLoaded && self.view.window) {
        [[BIMClient sharedInstance] markFriendApplyRead:nil];
    }
    self.friendApplyList = [dataSource.friendApplyList copy];
    [self.tableview reloadData];
}

@end
