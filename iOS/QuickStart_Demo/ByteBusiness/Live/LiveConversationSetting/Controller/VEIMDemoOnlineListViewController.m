//
//  VEIMDemoOnlineListViewController.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/26.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoOnlineListViewController.h"
#import "VEIMDemoUser.h"
#import "VEIMDemoUserManager.h"
#import "BIMUIDefine.h"
#import "BIMToastView.h"
#import <imsdk-tob/BIMSDK.h>

@interface VEIMDemoOnlineListViewController ()<VEIMDemoUserSelectionControllerDelegate>
@property (nonatomic, assign) long long nextCursor;

@end

@implementation VEIMDemoOnlineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
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
    [[BIMClient sharedInstance] getLiveGroupMemberOnlineList:self.conversation.conversationID cursor:cursor count:100 completion:^(NSArray<id<BIMMember>> * _Nullable members, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
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
            user.isNeedSelection = NO;
        }
        [users addObject:user];
    }
    return users;
}
- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didSelectUsers:(NSArray<VEIMDemoUser *> *)users
{
    NSArray *uids = [users valueForKey:@"userID"];
    [[BIMClient sharedInstance] kickLiveGroupMemberList:self.conversation.conversationID uidList:[NSSet setWithArray:uids] completion:^(BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"移除失败：%@", error.localizedDescription]];
        } else {
            if (self.kickLiveGroupMemberListBlock) {
                self.kickLiveGroupMemberListBlock(uids);
            }
        }
    }];
}
@end
