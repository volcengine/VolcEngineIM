//
//  VEIMDemoSelectUserViewController.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/6/25.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoSelectUserViewController.h"
#import "BIMToastView.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoChatViewController.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoUserListCell.h"
#import "VEIMDemoUserSelectionController.h"
#import "VEIMDemoIMManager+Conversation.h"
#import <Onekit/NSString+BTDAdditions.h>

static NSInteger const kMaxCount = 5;

@interface VEIMDemoSelectUserViewController ()<UITextFieldDelegate, VEIMDemoUserSelectionControllerDelegate>
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIButton *addButton;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSArray<NSNumber *> *members;

@end

@implementation VEIMDemoSelectUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.showType == VEIMDemoSelectUserShowTypeAddParticipants) {
        self.members = [[[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID] valueForKey:@"userID"];
        self.conversationType = self.conversation.conversationType;
    }
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    [self.view addSubview:self.textField];
    self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableview.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.textField.frame), 0, 0, 0);
    self.tableview.allowsSelection = NO;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableview.rowHeight = 88;
    [self.tableview registerClass:[VEIMDemoUserListCell class] forCellReuseIdentifier:@"VEIMDemoUserListCell"];
    [self.textField becomeFirstResponder];
}

#pragma mark - action

// 群
- (void)addClick
{
    if (!self.textField.text.length) {
        return;
    }
    NSNumber *uid = @(self.textField.text.longLongValue);
    if ([self.users containsObject:uid]) {
        [BIMToastView toast:@"群成员已添加"];
        return;
    }
    
    if (uid.longLongValue == [VEIMDemoUserManager sharedManager].currentUser.userID) {
        [BIMToastView toast:@"您已在群聊中"];
        return;
    }
    
    if (self.showType == VEIMDemoSelectUserShowTypeAddParticipants && [self.members containsObject:uid]) {
        [BIMToastView toast:@"用户已在群"];
        return;
    }
    
    if (self.users.count >= 20) {
        [BIMToastView toast:[NSString stringWithFormat:@"已添加%lu个用户", (unsigned long)self.users.count]];
        return;
    }
    
    self.addButton.enabled = NO;
    kWeakSelf(self)
    [self checkUserExist:uid.longLongValue completion:^(BOOL exist) {
        self.addButton.enabled = YES;
        if (!exist) {
            return;
        }
        [weakself.users insertObject:uid atIndex:0];
        [weakself.tableview reloadData];
        [weakself clearTextField];
    }];
}

- (void)clearTextField
{
    self.textField.text = nil;
    self.addButton.hidden = YES;
}

- (void)rightButtonClick
{
    switch (self.showType) {
        case VEIMDemoSelectUserShowTypeCreateChat:
            if (self.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
                [self createSingleConversation];
            } else {
                [self createGroupConversation];
            }
            break;
        case VEIMDemoSelectUserShowTypeAddParticipants:
            [self addParticipant];
            break;
            
        default:
            break;
    }
}

#pragma mark - event

- (void)createSingleConversation
{
    if (!self.textField.text.length) {
        [BIMToastView toast:@"请输入用户ID"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    kWeakSelf(self);
    long long uid = self.textField.text.longLongValue;
    // 远端校验
    [self checkUserExist:uid completion:^(BOOL exist) {
        weakself.navigationItem.rightBarButtonItem.enabled = YES;
        if (!exist) {
            return;
        }
        [weakself p_createSingleConversation];
    }];
}

- (void)p_createSingleConversation
{
    UINavigationController *nav = self.navigationController;
    [self dismiss];
    [[BIMClient sharedInstance] createSingleConversation:@(self.textField.text.longLongValue) completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"创建聊天失败: %@",error.localizedDescription]];
        } else {
            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
            [nav pushViewController:chatVC animated:YES];
        }
    }];
}

- (void)createGroupConversation
{
    if (!self.users.count) {
        [BIMToastView toast:@"请添加群成员"];
        return;
    }
    
    NSMutableSet *usersSet = [NSMutableSet setWithArray:self.users];
    NSString *msgStr = [NSString stringWithFormat:@"%@邀请", [VEIMDemoUserManager sharedManager].currentUser.name];

    for (int i = 0; i < self.users.count; i++) {
        NSNumber *user = self.users[i];
        NSString *name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:user.longLongValue];
        if (i == (self.users.count - 1)) {
            msgStr = [msgStr stringByAppendingFormat:@"%@",name];
        } else {
            msgStr = [msgStr stringByAppendingFormat:@"%@、",name];
        }
    }
    msgStr = [msgStr stringByAppendingFormat:@"加入群聊"];
    UINavigationController *nav = self.navigationController;
    kWeakSelf(self);
    [[BIMClient sharedInstance] createGroupConversation:usersSet completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        if (error) {
            NSString *toast = nil;
            if (error.code == BIM_SERVER_ERROR_CREATE_CONVERSATION_MORE_THAN_LIMIT) {
                toast = error.localizedDescription;
            } else if (error.code == BIM_SERVER_ERROR_CREATE_CONVERSATION_MEMBER_TOUCH_LIMIT) {
                toast = @"群成员已达上限";
            } else {
                toast = [NSString stringWithFormat:@"创建群聊失败: %@",error.localizedDescription];
            }
            
            [BIMToastView toast:toast];
        } else {
            [weakself dismiss];
            BIMMessage *msg = [[BIMClient sharedInstance] createCustomMessage:@{@"text":msgStr,@"type":@(2)}];
            [[BIMClient sharedInstance] sendMessage:msg conversationId:conversation.conversationID saved:nil progress:nil  completion:nil];

            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
            [nav pushViewController:chatVC animated:YES];
        }
    }];
}

- (void)addParticipant
{
    if (!self.users.count) {
        [BIMToastView toast:@"请添加群成员"];
        return;
    }
    NSMutableArray *users = [NSMutableArray array];
    for (NSNumber *userID in self.users) {
        VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
        user.userID = userID.longLongValue;
        user.isNeedSelection = YES;
        user.name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:userID.longLongValue];
        user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:userID.longLongValue];
        [users addObject:user];
    }
    kWeakSelf(self);
    [[VEIMDemoIMManager sharedManager] addUsers:users con:self.conversation completion:^(NSError * _Nullable error) {
        if (error) {
            NSString *toast = [NSString stringWithFormat:@"添加失败: %@",error.localizedDescription];
            if (error.code == BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT) {
                toast = error.localizedDescription;
            } else if (error.code == BIM_SERVER_ADD_MEMBER_TOUCH_LIMIT) {
                toast = @"群成员已达上限";
            }
            [BIMToastView toast:toast];
        } else {
            [weakself dismiss];
        }
    }];
}

- (void)jumpToUserSelectionPage
{
    NSMutableArray *users = [NSMutableArray array];
    for (NSNumber *userID in self.users) {
        VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
        user.userID = userID.longLongValue;
        user.isNeedSelection = YES;
        user.name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:userID.longLongValue];
        user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:userID.longLongValue];
        [users addObject:user];
    }
    VEIMDemoUserSelectionController *userController = [[VEIMDemoUserSelectionController alloc] initWithUsers:users];
    userController.style = VEIMDemoUserSelectionStyleMultiSelection;
    userController.delegate = self;
    userController.title = @"移出群成员";
    [self.navigationController pushViewController:userController animated:YES];
}

#pragma mark - check

- (void)checkUserExist:(long long)uid completion:(void (^)(BOOL exist))completion
{
    if (!completion) {
        return;
    }
    [[VEIMDemoIMManager sharedManager].accountProvider checkUserExist:uid completion:^(BOOL exist, NSError * _Nonnull error) {
        if (error) {
            [BIMToastView toast:error.localizedDescription];
            completion(NO);
            return;
        }
        if (!exist) {
            [BIMToastView toast:@"该用户不存在"];
            completion(NO);
            return;
        }
        
        completion(YES);
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kWeakSelf(self);
    VEIMDemoUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoUserListCell"];
    NSArray *participants = [self.users copy];
    if (participants.count > kMaxCount) {
        participants = [participants subarrayWithRange:NSMakeRange(0, kMaxCount)];
    }
    [cell refreshWithConversationParticipants:participants];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%lu人", (unsigned long)self.users.count];
    cell.clickHandler = ^{
        [weakself jumpToUserSelectionPage];
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.users.count) {
        return 1;
    }
    return 0;
}

#pragma mark - User Selection Delegate

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didSelectUsers:(NSArray<VEIMDemoUser *> *)users{
    if (!users.count) {
        return;
    }
    
    NSArray *userIDs = [users valueForKey:@"userID"];
    [self.users removeObjectsInArray:userIDs];
    [self.tableview reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string btd_containsNumberOnly]) {
        return NO;
    }
    if(range.length + range.location > textField.text.length) {
        return NO;
    }

    NSUInteger newLength = [textField.text length] + [string length] - range.length;

    return newLength <= kVEIMDemoUIDLength;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        return;
    }
    self.addButton.hidden = !textField.text.length;
}

#pragma mark -

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - getter

- (UITextField *)textField
{
    if (!_textField) {
        CGFloat x = 10;
        CGFloat width = self.view.frame.size.width - 2 * x;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(x, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height+10, width, 40)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = self.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT ? @"请输入用户ID 添加群成员" : @"请输入用户ID";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.rightView = self.addButton;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addButton.frame = CGRectMake(0, 0, 40, 40);
        _addButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        _addButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        _addButton.contentMode = UIViewContentModeCenter;
        _addButton.hidden = YES;
    }
    return _addButton;
}

- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
