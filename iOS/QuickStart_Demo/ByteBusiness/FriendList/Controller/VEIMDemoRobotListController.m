//
//  VEIMDemoRobotListController.m
//  ByteBusiness
//
//  Created by hexi on 2025/3/6.
//  Copyright © 2025 loulan. All rights reserved.
//

#import "VEIMDemoRobotListController.h"

#import "VEIMDemoDefine.h"
#import "VEIMDemoUserManager.h"
#import "BIMFriendListUserCell.h"
#import "VEIMDemoChatViewController.h"

#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>
#import <OneKit/ByteDanceKit.h>
#import <im-uikit-tob/BIMToastView.h>

@interface VEIMDemoRobotListController () <UITableViewDelegate, UITableViewDataSource, BIMFriendListUserCellDelegate >

@property (nonatomic, copy) NSArray<BIMUserFullInfo *> *robotList;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSInteger nextCursor;
@property (nonatomic, assign) int32_t limit;

@end

@implementation VEIMDemoRobotListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"机器人列表";
    self.limit = 3;
    self.hasMore = YES;
    self.nextCursor = 0;
    @weakify(self);
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadRobotListData];
    }];
    [self.tableview.mj_footer beginRefreshing];
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    [self.tableview registerClass:[BIMFriendListUserCell class] forCellReuseIdentifier:@"BIMFriendListUserCell"];
}

#pragma mark - Notification

- (void)registerNotification
{
    [super registerNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:kVEIMDemoUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:kVEIMDemoUserDidLogoutNotification object:nil];
}

- (void)userDidLogin:(NSNotification *)noti
{
    self.robotList = nil;
    [self.tableview.mj_footer beginRefreshing];
}

- (void)userDidLogout:(NSNotification *)noti
{
    self.robotList = nil;
}

#pragma mark- Load Data

- (void)loadRobotListData
{
    @weakify(self);
    [[VEIMDemoUserManager sharedManager] getRobotFullInfoWithCursor:self.nextCursor limit:self.limit completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, NSInteger nextCursor, BOOL hasMore, BIMError * _Nullable bimError) {
        @strongify(self);
        if (bimError) {
            NSError *error = [NSError errorWithDomain:kVEIMDemoErrorDomain code:bimError.code userInfo:@{NSLocalizedDescriptionKey : bimError.localizedDescription}];
            [BIMToastView toast:[NSString stringWithFormat:@"分页获取机器人失败：%@", error.localizedDescription]];
            [self.tableview.mj_footer endRefreshing];
            return;
        }
        
        NSArray *robotList = [infos btd_filter:^BOOL(BIMUserFullInfo * _Nonnull info) {
            long long uid = info.userProfile.uid;
            return uid == 999880 || uid == 999881;
        }];
#if DEBUG || INHOUSE
        robotList = infos;
        NSMutableArray *allRobotList = [NSMutableArray array];
        if (self.robotList) {
            [allRobotList addObjectsFromArray:self.robotList];
        }
        
        if (robotList) {
            [allRobotList addObjectsFromArray:robotList];
        }
        self.robotList = [allRobotList copy];
        self.nextCursor = nextCursor;
        self.hasMore = hasMore;
        if (!hasMore) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableview.mj_footer endRefreshing];
        }
#else
        self.robotList = robotList;
#endif
        
        btd_dispatch_async_on_main_queue(^{
            [self.tableview reloadData];
        });
    }];
}

#pragma mark - TableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.robotList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    BIMFriendListUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMFriendListUserCell"];
    cell.friendInfo = self.robotList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMFriendListUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    long long uid = cell.friendInfo.uid;
    [[BIMClient sharedInstance] createSingleConversation:@(uid) completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"进入会话失败"]];
        } else {
            if (!conversation.lastMessage) {
                [[BIMClient sharedInstance] markNewChat:conversation.conversationID needNotice:YES completion:^(BIMError * _Nullable error) {}];
            }
            
            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }];
}

#pragma mark - BIMFriendListUserCellDelegate

- (void)cellDidLongPress:(BIMFriendListUserCell *)cell
{
    /// 暂不支持删除机器人
}

@end
