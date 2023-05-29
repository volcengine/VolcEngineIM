//
//  VEIMDemoBlockListViewController.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/26.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoBlockListViewController.h"
#import "VEIMDemoInputController.h"
#import "VEIMDemoUser.h"
#import "VEIMDemoUserManager.h"
#import "BIMUIDefine.h"
#import "BIMToastView.h"
#import <imsdk-tob/BIMSDK.h>

@interface VEIMDemoBlockListViewController () <VEIMDemoUserSelectionControllerDelegate>
@property (nonatomic, assign) long long nextCursor;

@end

@implementation VEIMDemoBlockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"增加" style:UIBarButtonItemStyleDone target:self action:@selector(rightClicked:)];
    self.delegate = self;
}

- (void)rightClicked:(id)sender{
    kWeakSelf(self)
    VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"进群黑名单" text:nil maxWordCount:100 editable:YES handler:^(NSString * _Nonnull text) {
        long long userID = text.longLongValue;
        [[BIMClient sharedInstance] addLiveGroupMemberBlockList:weakself.conversation.conversationID uidList:[NSSet setWithObject:@(userID)] completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"拉黑失败: %@",error.localizedDescription]];
            } else {
                VEIMDemoUser *user = [VEIMDemoUser new];
                user.name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:userID];
                user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:userID];
                user.userID = userID;
                [self.users addObject:user];
                [weakself.tableview reloadData];
            }
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadMoreCompletion:(VEIMDemoUserListCompletion _Nullable )completion
{
    [self loadDataWithCursor:self.nextCursor completion:completion];
}

- (void)loadFirstPageCompletion:(VEIMDemoUserListCompletion _Nullable )completion
{
    [self loadDataWithCursor:0 completion:completion];
}

- (void)loadDataWithCursor:(long long)cursor completion:(VEIMDemoUserListCompletion _Nullable )completion
{
    kWeakSelf(self)

    [[BIMClient sharedInstance] getLiveGroupMemberBlockList:self.conversation.conversationID cursor:cursor count:100 completion:^(NSArray<id<BIMMember>> * _Nullable members, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        NSArray *users = [weakself usersWithMembers:members];
        if (completion) {
            completion(users, hasMore, error);
        }
        if (nextCursor > 0) {
            weakself.nextCursor = nextCursor;
        }
    }];
}

- (NSArray *)usersWithMembers:(NSArray<id<BIMMember>> *)participants
{
    NSMutableArray *users = [NSMutableArray array];
    for (id <BIMMember> participant in participants) {
        VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
        user.name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:participant.userID];
        user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID];
        user.userID = participant.userID;
        user.isNeedSelection = YES;
        if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
            user.role = @"管理员";
//            user.isSelected = YES;
        }else if (participant.role == BIM_MEMBER_ROLE_OWNER){
            user.role = @"群主";
//            user.isSelected = YES;
//            user.isNeedSelection = NO;
        }
        [users addObject:user];
    }
    return users;
}

#pragma mark - VEIMDemoUserSelectionControllerDelegate

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didLongPressUser:(nonnull VEIMDemoUser *)user indexPath:(nonnull NSIndexPath *)indexPath
{
    kWeakSelf(self)
    UIAlertController *alertVC = [[UIAlertController alloc] init];
    UIAlertAction *remove = [UIAlertAction actionWithTitle:@"移除成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[BIMClient sharedInstance] removeLiveGroupMemberBlockList:self.conversation.conversationID uidList:[NSSet setWithObject:@(user.userID)] completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"移除失败: %@",error.localizedDescription]];
            } else {
                [weakself.users removeObjectAtIndex:indexPath.row];
                [weakself.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }];
    
    [alertVC addAction:remove];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
