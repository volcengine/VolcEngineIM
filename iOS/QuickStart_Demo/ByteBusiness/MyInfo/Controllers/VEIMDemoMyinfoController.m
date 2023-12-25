//
//  VEIMDemoMyinfoController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/3.
//

#import "VEIMDemoMyinfoController.h"
#import "VEIMDemoMyinfoHeaderCell.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoAppInfoCell.h"
#import "VEIMDemoAccountCancellationManager.h"
#import "VEIMDemoProfileEditViewController.h"

#import <OneKit/UIApplication+BTDAdditions.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMClient.h>
#import <im-uikit-tob/BIMToastView.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef enum : NSUInteger {
    VEIMDemoMyinfoSectionTypeInfo,
    VEIMDemoMyinfoSectionTypeAppInfo,
    VEIMDemoMyinfoSectionTypeCancelAccountAndLogout,
} VEIMDemoMyinfoSectionType;

static NSString *const VEIMMyInfoAppid = @"AppId";
static NSString *const VEIMMyInfoAppVersionName = @"App Version Name";
static NSString *const VEIMMyInfoIMSDKVersion = @"IMSDK Version Name";
static NSString *const VEIMMyInfoIMSDKDid = @"Did";
static NSString *const VEIMMyInfoLongConnectStauts = @"长连接状态";
static NSString *const VEIMMyInfoPrivacy = @"隐私政策";
static NSString *const VEIMMyInfoPermissionList = @"权限清单";

@interface VEIMDemoMyinfoController ()<BIMFriendListener>

@property (nonatomic, copy) NSArray *appInfoArr;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, copy) NSString *did;

@end

@implementation VEIMDemoMyinfoController


- (instancetype)initWithUser:(VEIMDemoUser *)user
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = YES;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = NO;
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeFriendListener:self];
}
	
- (UITableViewStyle)tableviewStyle{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:@"LongConnectStatusChanged" object:nil];
    
    @weakify(self);
    [[BIMClient sharedInstance] getDid:^(NSString * _Nullable did) {
        @strongify(self);
        self.did = did;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }];
    
    [[BIMClient sharedInstance] addFriendListener:self];
}

- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification] || [noti.name isEqualToString:@"LongConnectStatusChanged"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }
}

- (void)setupUIElements{
    [super setupUIElements];
    
    self.appInfoArr = @[VEIMMyInfoAppid,
                        VEIMMyInfoAppVersionName,
                        VEIMMyInfoIMSDKVersion,
                        VEIMMyInfoIMSDKDid,
                        VEIMMyInfoLongConnectStauts,
                        VEIMMyInfoPrivacy,
                        VEIMMyInfoPermissionList];
    
    [self.tableview registerClass:[VEIMDemoMyinfoHeaderCell class] forCellReuseIdentifier:@"VEIMDemoMyinfoHeaderCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableview registerClass:[VEIMDemoAppInfoCell class] forCellReuseIdentifier:@"VEIMDemoAppInfoCell"];
    
}

- (void)refreshWithUser{
    [self.tableview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case VEIMDemoMyinfoSectionTypeInfo:{
            VEIMDemoMyinfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoMyinfoHeaderCell"];
            [cell refreshWithUser:[VEIMDemoUserManager sharedManager].currentUserFullInfo.userProfile];
            return cell;
            break;
        }
        case VEIMDemoMyinfoSectionTypeAppInfo:{
            VEIMDemoAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoAppInfoCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *title = [self.appInfoArr objectAtIndex:indexPath.row];
            NSString *info = nil;
            if ([title isEqualToString:VEIMMyInfoAppid]) {
                info = kVEIMDemoAppID;
            } else if ([title isEqualToString:VEIMMyInfoAppVersionName]) {
                info = UIApplication.btd_versionName;
            } else if ([title isEqualToString:VEIMMyInfoIMSDKVersion]) {
                info = [[BIMClient sharedInstance] getVersion];
            } else if ([title isEqualToString:VEIMMyInfoIMSDKDid]) {
                info = self.did;
            } else if ([title isEqualToString:VEIMMyInfoLongConnectStauts]) {
                info = [[BIMClient sharedInstance] getConnectStatus] == BIM_CONNECT_STATUS_CONNECTED ? @"[已连接]" : @"[未连接]";
            } else if ([title isEqualToString:VEIMMyInfoPrivacy]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if ([title isEqualToString:VEIMMyInfoPermissionList]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            [cell configCellWithTitle:title info:info];
            return cell;
            break;
        }
        case VEIMDemoMyinfoSectionTypeCancelAccountAndLogout:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"注销账户";
            } else {
                cell.textLabel.text = @"退出登录";
            }
            return cell;
            break;
        }
        default:
            break;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == VEIMDemoMyinfoSectionTypeCancelAccountAndLogout) {
        if (indexPath.row == 0) {
            NSString *msg = @"注销后，当前账户的所有数据将会被删除且无法找回。\n注销后，当前账户所创建的群聊将自动转让群主后退出。\n注销一经开始将无法撤回。";
            NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:msg];
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            [paragraph setLineSpacing:3];
            [paragraph setParagraphSpacingBefore:5];
            [paragraph setAlignment:NSTextAlignmentLeft];
            [paragraph setBaseWritingDirection:NSWritingDirectionLeftToRight];
            [attMsg addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, msg.length)];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alertVC setValue:attMsg forKey:@"attributedMessage"];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                VEIMDemoUser *curUser = [[VEIMDemoUserManager sharedManager] currentUser];
                NSString *token = curUser.userToken;
                NSString *uid = [NSString stringWithFormat:@"%lld", curUser.userID];
                [self showLoading]; // 展示loading动画
                @weakify(self);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[VEIMDemoAccountCancellationManager sharedInstance] cancelAccountWithUid:uid token:token completion:^(BOOL success){
                        @strongify(self);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideLoading];
                        });
                        if (success) {
                            [[VEIMDemoUserManager sharedManager] logout];
                            [BIMToastView toast:@"注销成功"];
                        } else {
                            [BIMToastView toast:@"注销失败"];
                        }
                    }];
                });
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:sureAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"登出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[VEIMDemoUserManager sharedManager] logout];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:sureAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else if (indexPath.section == VEIMDemoMyinfoSectionTypeAppInfo) {
        NSString *title = [self.appInfoArr objectAtIndex:indexPath.row];
        if ([title isEqualToString:VEIMMyInfoPrivacy]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoPrivacyAgreement] options:nil completionHandler:nil];
        } else if ([title isEqualToString:VEIMMyInfoPermissionList]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoPermissionList] options:nil completionHandler:nil];
        } else if ([title isEqualToString:VEIMMyInfoIMSDKDid]) {
            if (!self.did.length) return;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.did;
            [BIMToastView toast:[NSString stringWithFormat:@"已复制Did:%@", self.did] withDuration:0.5];
        }
    } else if (indexPath.section == VEIMDemoMyinfoSectionTypeInfo) {
        BIMUserProfile *profile = [VEIMDemoUserManager sharedManager].currentUserFullInfo.userProfile;
        VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserProfile:profile];
        vc.canSelfEdit = YES;
        [self.navigationController pushViewController:vc animated:YES];
     }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case VEIMDemoMyinfoSectionTypeInfo:
            return 1;
            break;
        case VEIMDemoMyinfoSectionTypeAppInfo:
            return self.appInfoArr.count;
            break;
        case VEIMDemoMyinfoSectionTypeCancelAccountAndLogout:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (void)showLoading {
    [self.view.window addSubview:self.progressHUD];
    [self.progressHUD showAnimated:YES];
}

- (void)hideLoading {
    [self.progressHUD hideAnimated:YES];
    [self.progressHUD removeFromSuperview];
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _progressHUD;
}

#pragma mark - BIMFriendListener

- (void)onUserProfileUpdate:(BIMUserFullInfo *)info
{
    [self.tableview reloadData];
}

@end
