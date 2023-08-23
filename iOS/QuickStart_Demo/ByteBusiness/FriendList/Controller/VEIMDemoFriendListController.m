//
//  VEIMDemoFriendListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendListController.h"
#import "BIMFriendListController.h"
#import "BIMFriendListDataSource.h"
#import "VEIMDemoIMManager.h"
#import "UIAlertController+Dismiss.h"
#import "VEIMDemoDefine.h"

#import <im-uikit-tob/BIMToastView.h>
#import <imsdk-tob/BIMClient+Friend.h>

@interface VEIMDemoFriendListController () <UITextFieldDelegate, BIMFriendListener>


@end

@implementation VEIMDemoFriendListController

- (instancetype)init
{
    if (self = [super init]) {
        self.tabBarItem.badgeColor = [UIColor redColor];
        [self registerNotification];
        [[BIMClient sharedInstance] addFriendListener:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"通讯录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    BIMFriendListController *friendListController = [[BIMFriendListController alloc] init];
    [self addChildViewController:friendListController];
    [self.view addSubview:friendListController.view];
    
    
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLogoutNotification object:nil];
}

- (void)didReceiveNoti:(NSNotification *)noti
{
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification]) {
        [self userDidLogin];
    }else if ([noti.name isEqualToString:kVEIMDemoUserDidLogoutNotification]){
        [self userDidLogout];
    }
}

- (void)userDidLogin
{
    @weakify(self);
    [[BIMClient sharedInstance] getFriendApplyUnreadCount:^(long long unreadCount, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            return;
        }
        [self updateTabUnreadCount:unreadCount];
    }];
}

- (void)userDidLogout
{
    [self updateTabUnreadCount:0];
}

#pragma mark - Actions
- (void)addFriend:(id)sender
{
    UIAlertController *addFriendAlert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [addFriendAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // ⚠️限制输入数字
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setPlaceholder:@"请输入uid"];
        textField.delegate = self;
        [textField addTarget:self action:@selector(addFriendTextFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    addFriendAlert.wontDismiss = YES;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // ⚠️输入框为空，toast提示：请输入uid（输入框不关闭）
        NSString *input = addFriendAlert.textFields[0].text;
        if (!input || input.length == 0) {
            [BIMToastView toast:@"请输入uid"];
            return;
        }
        
        // ⚠️好友数量超过限制，toast提示：已超出好友数量上限。（输入框不关闭）
        // ⚠️该uid已经是该用户好友，toast提示：TA已经是你的好友，请重新输入（输入框不关闭）
        // ⚠️uid是自己，toast提示：自己不能添加自己为好友，请重新输入。（输入框不关闭）
        // ⚠️已经向改uid发送过好友申请，且该uid尚未处理，toast提示：已发送过好友申请，请等待对方处理（输入框不关闭）
        // ⚠️uid不存在。toast提示：uid不存在，请重新输入。（输入框不关闭）
        [self checkUserExist:input.longLongValue completion:^(BOOL exist) {
            if (exist) {
                // 构造BIMApplyInfo
                BIMApplyInfo *applyInfo = [[BIMApplyInfo alloc] init];
                applyInfo.uid = input.longLongValue;
                [[BIMClient sharedInstance] applyFriend:applyInfo completion:^(BIMError * _Nullable error) {
                    if (error) {
                        NSString *toastStr = error.localizedDescription;
                        if (error.code == BIM_SERVER_DUPLICATE_APPLY) {
                            toastStr = @"已发送过好友申请，请等待对方处理";
                        } else if (error.code == BIM_SERVER_IS_FRIEND) {
                            toastStr = @"TA已经是你的好友，请重新输入";
                        } else if (error.code == BIM_FRIEND_MORE_THAN_LIMIT) {
                            toastStr = @"已超出好友数量上限";
                        } else if (error.code == BIM_SERVER_ADD_SELF_FRIEND_NOT_ALLOW) {
                            toastStr = @"自己不能添加自己为好友";
                        }
                        [BIMToastView toast:[NSString stringWithFormat:@"%@", toastStr]];
                    } else {
                        // 请求成功关闭alert
                        [BIMToastView toast:@"操作成功"];
                        [self dismissViewControllerAnimated:addFriendAlert completion:nil];
                    }
                }];
            } else {
                [BIMToastView toast:@"uid不存在，请重新输入"];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [addFriendAlert addAction:cancelAction];
    [addFriendAlert addAction:confirmAction];
    
    [self presentViewController:addFriendAlert animated:YES completion:nil];
}

#pragma mark - Check

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

#pragma mark - 添加好友textField限制输入数字
// 验证码输入框实时更新
- (void)addFriendTextFieldTextChanged:(UITextField *)textField
{
    // 获取当前光标位置
    NSUInteger currentCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    // 限制只能输入数字
    NSString *digitNumWithoutSpaces = [self removeNonDigitsWithInput:textField.text preserveCursorPosition:&currentCursorPosition];
    [textField setText:digitNumWithoutSpaces];
}

// 去除非数字字符
- (NSString *)removeNonDigitsWithInput:(NSString *)input preserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originPosition = *cursorPosition;
    NSMutableString *digitsString = [NSMutableString string];
    for (NSUInteger i = 0; i < input.length; i++) {
        unichar character = [input characterAtIndex:i];
        if (isdigit(character)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&character length:1];
            [digitsString appendString:stringToAdd];
        } else {
            if (i < originPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsString;
}

- (void)onFriendApplyUnreadCountChanged:(long long)count
{
    [self updateTabUnreadCount:count];
}

- (void)updateTabUnreadCount:(long long)count
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (count == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            self.tabBarItem.badgeValue = count > 99 ? @"99+" : @(count).stringValue;
        }
    });
}
@end
