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
#import "VEIMDemoIMManager.h"

#import <OneKit/UIApplication+BTDAdditions.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMClient.h>
#import <im-uikit-tob/BIMToastView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#if __has_include("BDIMDebugManager.h")
#import "BDIMDebugManager.h"
#endif

typedef enum : NSUInteger {
    VEIMDemoMyinfoSectionTypeInfo,
    VEIMDemoMyinfoSectionTypeAppInfo,
    VEIMDemoMyinfoSectionTypeCancelAccountAndLogout,
} VEIMDemoMyinfoSectionType;

static NSString *const VEIMMyInfoDebug = @"高级调试";
static NSString *const VEIMMyInfoAppid = @"AppId";
static NSString *const VEIMMyInfoAppVersionName = @"App Version Name";
static NSString *const VEIMMyInfoIMSDKVersion = @"IMSDK Version Name";
static NSString *const VEIMMyInfoIMSDKDid = @"Did";
static NSString *const VEIMMyInfoLongConnectStauts = @"长连接状态";
static NSString *const VEIMMyInfoPrivacy = @"隐私政策";
static NSString *const VEIMMyInfoPermissionList = @"权限清单";
static NSString *const VEIMMyInfoICP = @"ICP备案号：京ICP备20018813号-193A";


static NSString *const VEIMMyInfoCancelAccount = @"注销账户";
static NSString *const VEIMMyInfoLogout = @"退出登录";

@interface VEIMDemoMyinfoController ()<BIMFriendListener>

@property (nonatomic, copy) NSArray *appInfoArr;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, copy) NSString *did;
@property (nonatomic, copy) NSArray *cancelAccountArray;

@end

@implementation VEIMDemoMyinfoController


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
    
    NSMutableArray *appInfoArr = [NSMutableArray array];
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType == VEIMDemoAccountTypeInternal) {
        [appInfoArr addObject:VEIMMyInfoDebug];
    }
    [appInfoArr addObject:VEIMMyInfoAppid];
    [appInfoArr addObject:VEIMMyInfoAppVersionName];
    [appInfoArr addObject:VEIMMyInfoIMSDKVersion];
    [appInfoArr addObject:VEIMMyInfoIMSDKDid];
    [appInfoArr addObject:VEIMMyInfoLongConnectStauts];
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType != VEIMDemoAccountTypeOpenSource) {
        [appInfoArr addObject:VEIMMyInfoPrivacy];
        [appInfoArr addObject:VEIMMyInfoPermissionList];
        [appInfoArr addObject:VEIMMyInfoICP];
    }
    self.appInfoArr = [appInfoArr copy];
    
    
    NSMutableArray *cancelAccountArray = [NSMutableArray array];
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType != VEIMDemoAccountTypeOpenSource) {
        [cancelAccountArray addObject:VEIMMyInfoCancelAccount];
    }
    [cancelAccountArray addObject:VEIMMyInfoLogout];
    self.cancelAccountArray = [cancelAccountArray copy];
    

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
            } else if ([title isEqualToString:VEIMMyInfoICP]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if ([title isEqualToString:VEIMMyInfoDebug]) {
                info = @"摇一摇更便捷";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            [cell configCellWithTitle:title info:info];
            return cell;
            break;
        }
        case VEIMDemoMyinfoSectionTypeCancelAccountAndLogout:{
            NSString *title = [self.cancelAccountArray objectAtIndex:indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.textLabel.text = title;
            
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
        NSString *title = [self.cancelAccountArray objectAtIndex:indexPath.row];
        if ([title isEqualToString:VEIMMyInfoCancelAccount]) {
            [self clickCancelAccountCell];
        } else if ([title isEqualToString:VEIMMyInfoLogout]) {
            [self clickLogoutCell];
        }
    } else if (indexPath.section == VEIMDemoMyinfoSectionTypeAppInfo) {
        NSString *title = [self.appInfoArr objectAtIndex:indexPath.row];
        if ([title isEqualToString:VEIMMyInfoPrivacy]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoPrivacyAgreement] options:nil completionHandler:nil];
        } else if ([title isEqualToString:VEIMMyInfoPermissionList]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoPermissionList] options:nil completionHandler:nil];
        } else if ([title isEqualToString:VEIMMyInfoICP]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoICP] options:nil completionHandler:nil];
        } else if ([title isEqualToString:VEIMMyInfoIMSDKDid]) {
            [self clickDidCell];
        } else if ([title isEqualToString:VEIMMyInfoDebug]) {
#if __has_include("BDIMDebugManager.h")
            [[BDIMDebugManager sharedManager] showDebugVC];
#endif
        }
    } else if (indexPath.section == VEIMDemoMyinfoSectionTypeInfo) {
        [self clickMyInfoCell];
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
            return self.cancelAccountArray.count;
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

#pragma mark - event

- (void)clickCancelAccountCell
{
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
        NSString *uid = [NSString stringWithFormat:@"%lld", curUser.userIDNumber];
    
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
}

- (void)clickLogoutCell
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"登出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[VEIMDemoUserManager sharedManager] logout];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)clickDidCell
{
    if (!self.did.length) return;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.did;
    [BIMToastView toast:[NSString stringWithFormat:@"已复制Did:%@", self.did] withDuration:0.5];
}

- (void)clickMyInfoCell
{
    BOOL isUidStringLogin = [BIMClient sharedInstance].isUseStringUid;
    if (isUidStringLogin) {
        VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserIdString:[BIMClient sharedInstance].getCurrentUserIDString];
        vc.canSelfEdit = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        BIMUserProfile *profile = [VEIMDemoUserManager sharedManager].currentUserFullInfo.userProfile;
        VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserProfile:profile];
        vc.canSelfEdit = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - getter

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
