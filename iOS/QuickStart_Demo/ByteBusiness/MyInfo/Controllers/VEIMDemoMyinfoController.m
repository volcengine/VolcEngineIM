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

#import "VEIMDemoMineItem.h"

@interface VEIMDemoMyinfoController ()<BIMFriendListener>

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, copy) NSString *did;
@property (nonatomic, strong) NSMutableArray *dataSectionList;
@property (nonatomic, strong) VEIMDemoMineItem *didItem;
@property (nonatomic, strong) VEIMDemoMineItem *connectItem;

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
    [[BIMClient sharedInstance] addFriendListener:self];
    
    [self getDid];
}

- (void)getDid
{
    @weakify(self);
    [[BIMClient sharedInstance] getDid:^(NSString * _Nullable did) {
        @strongify(self);
        self.did = did;
        self.didItem.subTitle = did;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }];
}

- (void)didReceiveNoti:(NSNotification *)noti {
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification] || [noti.name isEqualToString:@"LongConnectStatusChanged"]) {
        if ([noti.name isEqualToString:@"LongConnectStatusChanged"]) {
            self.connectItem.subTitle = [[BIMClient sharedInstance] getConnectStatus] == BIM_CONNECT_STATUS_CONNECTED ? @"[已连接]" : @"[未连接]";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [self setupData];
    [self.tableview registerClass:[VEIMDemoMyinfoHeaderCell class] forCellReuseIdentifier:@"VEIMDemoMyinfoHeaderCell"];
    [self.tableview registerClass:[VEIMDemoAppInfoCell class] forCellReuseIdentifier:@"VEIMDemoAppInfoCell"];
}

#pragma mark - data

- (void)setupData
{
    self.dataSectionList = [NSMutableArray array];
    
    // 分组
    [self setupDataMyInfoSection];
    [self setupDataDebugSection];
    [self setupDataBasicInfoSection];
    [self setupDataAccountSection];
}

- (void)setupDataMyInfoSection
{
    //TODO:后期改造为tableHeaderView
    NSMutableArray *myInfoSectionArray = [NSMutableArray array];
    @weakify(self);
    VEIMDemoMineItem *myInfoItem = [VEIMDemoMineItem itemWithTitle:nil subTitle:nil accessoryType:UITableViewCellAccessoryNone clickBlock:^(VEIMDemoMineItem *item) {
        @strongify(self);
        [self clickMyInfoCell];
    }];
    myInfoItem.cellClass = NSClassFromString(@"VEIMDemoMyinfoHeaderCell");
    [myInfoSectionArray addObject:myInfoItem];
    
    [self.dataSectionList addObject:myInfoSectionArray];
}

- (void)setupDataDebugSection
{
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType != VEIMDemoAccountTypeInternal) {
        return;
    }
    NSMutableArray *debugSectionArray = [NSMutableArray array];
    VEIMDemoMineItem *debugItem = [VEIMDemoMineItem itemWithTitle:@"高级调试" subTitle:@"摇一摇更便捷" accessoryType:UITableViewCellAccessoryDisclosureIndicator clickBlock:^(VEIMDemoMineItem *item) {
        #if __has_include("BDIMDebugManager.h")
        [[BDIMDebugManager sharedManager] showDebugVC];
        #endif
    }];
    [debugSectionArray addObject:debugItem];
    
    [self.dataSectionList addObject:debugSectionArray];
}

- (void)setupDataBasicInfoSection
{
    NSMutableArray *basicInfoSectionArray = [NSMutableArray array];
    @weakify(self);
    VEIMDemoMineItem *appIdItem = [VEIMDemoMineItem itemWithTitle:@"AppId" subTitle:kVEIMDemoAppID accessoryType:UITableViewCellAccessoryNone clickBlock:nil];
    [basicInfoSectionArray addObject:appIdItem];
    
    VEIMDemoMineItem *appVersionItem = [VEIMDemoMineItem itemWithTitle:@"App Version Name" subTitle:UIApplication.btd_versionName accessoryType:UITableViewCellAccessoryNone clickBlock:nil];
    [basicInfoSectionArray addObject:appVersionItem];
    
    VEIMDemoMineItem *sdkVersionItem = [VEIMDemoMineItem itemWithTitle:@"IMSDK Version Name" subTitle:[[BIMClient sharedInstance] getVersion] accessoryType:UITableViewCellAccessoryNone clickBlock:nil];
    [basicInfoSectionArray addObject:sdkVersionItem];
    
    VEIMDemoMineItem *didItem = [VEIMDemoMineItem itemWithTitle:@"Did" subTitle:self.did accessoryType:UITableViewCellAccessoryNone clickBlock:^(VEIMDemoMineItem *item) {
        @strongify(self);
        [self clickDidCell];
    }];
    self.didItem = didItem;
    
    [basicInfoSectionArray addObject:didItem];
    
    
    VEIMDemoMineItem *longConnectItem = [VEIMDemoMineItem itemWithTitle:@"长连接状态" subTitle:[[BIMClient sharedInstance] getConnectStatus] == BIM_CONNECT_STATUS_CONNECTED ? @"[已连接]" : @"[未连接]" accessoryType:UITableViewCellAccessoryNone clickBlock:nil];
    [basicInfoSectionArray addObject:longConnectItem];
    
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType != VEIMDemoAccountTypeOpenSource) {
        VEIMDemoMineItem *privacyItem = [VEIMDemoMineItem itemWithTitle:@"隐私政策" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator clickBlock:^(VEIMDemoMineItem *item) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoPrivacyAgreement] options:nil completionHandler:nil];
        }];
        [basicInfoSectionArray addObject:privacyItem];
        
        VEIMDemoMineItem *permissionListItem = [VEIMDemoMineItem itemWithTitle:@"权限清单" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator clickBlock:^(VEIMDemoMineItem *item) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoPermissionList] options:nil completionHandler:nil];
        }];
        [basicInfoSectionArray addObject:permissionListItem];
        
        VEIMDemoMineItem *ICPItem = [VEIMDemoMineItem itemWithTitle:@"ICP备案号：京ICP备20018813号-193A" subTitle:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator clickBlock:^(VEIMDemoMineItem *item) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kVEIMDemoICP] options:nil completionHandler:nil];
        }];
        [basicInfoSectionArray addObject:ICPItem];
    }
    
    [self.dataSectionList addObject:basicInfoSectionArray];
}

- (void)setupDataAccountSection
{
    NSMutableArray *accountSectionArray = [NSMutableArray array];
    @weakify(self);
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType != VEIMDemoAccountTypeOpenSource) {
        VEIMDemoMineItem *cancelAccountItem = [VEIMDemoMineItem itemWithTitle:@"注销账户" subTitle:nil accessoryType:UITableViewCellAccessoryNone clickBlock:^(VEIMDemoMineItem *item) {
            @strongify(self);
            [self clickCancelAccountCell];
        }];
        [accountSectionArray addObject:cancelAccountItem];
    }
    
    VEIMDemoMineItem *logoutItem = [VEIMDemoMineItem itemWithTitle:@"退出登录" subTitle:nil accessoryType:UITableViewCellAccessoryNone clickBlock:^(VEIMDemoMineItem *item) {
        @strongify(self);
        [self clickLogoutCell];
    }];
    [accountSectionArray addObject:logoutItem];
    
    [self.dataSectionList addObject:accountSectionArray];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoMineItem *item = self.dataSectionList[indexPath.section][indexPath.row];
    if (item.cellClass && item.cellClass == NSClassFromString(@"VEIMDemoMyinfoHeaderCell")) {
        VEIMDemoMyinfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoMyinfoHeaderCell"];
        [cell refreshWithUser:[VEIMDemoUserManager sharedManager].currentUserFullInfo.userProfile];
        return cell;
    } else {
        VEIMDemoAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoAppInfoCell"];
        cell.accessoryType = item.accessoryType;
        [cell configCellWithTitle:item.title info:item.subTitle];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *sectionArray = self.dataSectionList[indexPath.section];
    VEIMDemoMineItem *item = sectionArray[indexPath.row];
    if (item.clickBlock) {
        item.clickBlock(item);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataSectionList[section];
    return sectionArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSectionList.count;
}

#pragma mark - event

- (void)showLoading {
    [self.view.window addSubview:self.progressHUD];
    [self.progressHUD showAnimated:YES];
}

- (void)hideLoading {
    [self.progressHUD hideAnimated:YES];
    [self.progressHUD removeFromSuperview];
}

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
