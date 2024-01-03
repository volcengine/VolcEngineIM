//
//  BIMUserSelectionController.m
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import "BIMUserSelectionController.h"
#import "BIMUserCell.h"
#import "BIMUIDefine.h"
#import "BIMUIClient.h"
#import <OneKit/BTDMacros.h>

@interface BIMUserSelectionController ()

@property (nonatomic, weak) BIMUser *selectedUser;

@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, copy) NSString *conversationID;

@end

@implementation BIMUserSelectionController

- (instancetype)initWithConversationID:(NSString *)conversationID
{
    if (self = [super init]) {
        _conversationID = conversationID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.users) {
            return;
        }
        self.users = [NSMutableArray array];
        NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversationID];
        @weakify(self);
        NSArray *uidList = [participants valueForKey:@"userID"];
        if ([[BIMUIClient sharedInstance].userInfoDataSource respondsToSelector:@selector(getUserFullInfoList:completion:)]) {
            [[BIMUIClient sharedInstance].userInfoDataSource getUserFullInfoList:uidList completion:^(NSArray<BIMUser *> *userInfos) {
                @strongify(self);
                self.users = userInfos;
                [self.tableview reloadData];
            }];
        }
    });
}

- (void)rightClicked: (id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(userSelectVCDidClickClose:)]) {
        [self.delegate userSelectVCDidClickClose:self];
    }
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [self.tableview registerClass:[BIMUserCell class] forCellReuseIdentifier:@"BIMUserCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BIMUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMUserCell"];
    BIMUser *user = [self.users objectAtIndex:indexPath.row];
    cell.user = user;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BIMUser *user = [self.users objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.delegate respondsToSelector:@selector(userSelectVC:didChooseUser:)]) {
        [self.delegate userSelectVC:self didChooseUser:user];
    }
    [self dismiss];
}

@end
