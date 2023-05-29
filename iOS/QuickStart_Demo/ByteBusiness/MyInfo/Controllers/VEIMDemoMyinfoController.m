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

typedef enum : NSUInteger {
    VEIMDemoMyinfoSectionTypeInfo,
    VEIMDemoMyinfoSectionTypeLogout,
} VEIMDemoMyinfoSectionType;

@interface VEIMDemoMyinfoController ()

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
	
- (UITableViewStyle)tableviewStyle{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLoginNotification object:nil];
}

- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification]) {
        [self.tableview reloadData];
    }
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [self.tableview registerClass:[VEIMDemoMyinfoHeaderCell class] forCellReuseIdentifier:@"VEIMDemoMyinfoHeaderCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (void)refreshWithUser{
    [self.tableview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case VEIMDemoMyinfoSectionTypeInfo:{
            VEIMDemoMyinfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoMyinfoHeaderCell"];
            [cell refreshWithUser:[VEIMDemoUserManager sharedManager].currentUser];
            return cell;
            break;
        }
        case VEIMDemoMyinfoSectionTypeLogout:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.textLabel.text = @"退出登录";
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
    if (indexPath.section == VEIMDemoMyinfoSectionTypeLogout) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"登出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[VEIMDemoUserManager sharedManager] logout];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:sureAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case VEIMDemoMyinfoSectionTypeInfo:
            return 1;
            break;
        case VEIMDemoMyinfoSectionTypeLogout:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

@end
