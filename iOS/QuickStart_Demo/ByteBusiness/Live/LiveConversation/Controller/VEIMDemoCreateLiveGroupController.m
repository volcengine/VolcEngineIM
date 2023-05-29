//
//  VEIMDemoCreateLiveGroupController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoCreateLiveGroupController.h"
#import "VEIMDemoCreateLiveGroupCell.h"
#import "VEIMDemoSetInpuViewController.h"

#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMClient+liveGroup.h>

static NSString *kDefalutLiveName = @"未命名直播间";

@interface VEIMDemoCreateLiveGroupController ()

@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, strong) BIMGroupInfo *groupInfo;

@end

@implementation VEIMDemoCreateLiveGroupController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.groupInfo = [[BIMGroupInfo alloc] init];
    self.groupInfo.name = kDefalutLiveName;
    
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    self.title = @"创建直播群";
    
    // 固定tableview
    self.tableview.scrollEnabled = NO;
    // 去除section之间的空白间隙
    self.tableview.sectionHeaderTopPadding = YES;
    // 设置分割线
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-50);
    }];
    
    self.tableview.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [self.tableview registerClass:[VEIMDemoCreateLiveGroupCell class] forCellReuseIdentifier:@"VEIMDemoCreateLiveGroupCell"];
}

#pragma mark -Interaction

- (void)dismiss
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backBtnClicked:(id)sender
{
    [self dismiss];
}

#pragma mark - tableView Delegate && DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoCreateLiveGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoCreateLiveGroupCell"];
    [cell.arrow setImage:[UIImage imageNamed:@"icon_detail"]];
    
    switch (indexPath.row) {
        case 0:
            if (indexPath.section == 0) {
                cell.settingTitle.text = @"直播群名称";
                cell.detailLabel.text = kDefalutLiveName;
                [cell setupCellLayoutWithStyle:VEIMDemoLiveGroupSettingCellStyle2];
            } else {
                cell.settingTitle.text = @"直播群描述";
                [cell setupCellLayoutWithStyle:VEIMDemoLiveGroupSettingCellStyle1];
            }
            break;
        case 1:
            if (indexPath.section == 0) {
                cell.settingTitle.text = @"直播群头像";
                [cell.groupAvatar setImage:[UIImage imageNamed:@"icon_avatar_group"]];
                [cell setupCellLayoutWithStyle:VEIMDemoLiveGroupSettingCellStyle3];
            } else {
                cell.settingTitle.text = @"直播群公告";
                [cell setupCellLayoutWithStyle:VEIMDemoLiveGroupSettingCellStyle1];
            }
            break;
    }
    
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self popupSettingVCWithIndexPath:indexPath];
}

// section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

// section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

// section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    view.backgroundColor = self.tableview.backgroundColor;
    return view;
}

// section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Actions

- (void)confirmBtnClicked:(id)sender
{
//    if (BTD_isEmptyString(self.groupInfo.name)) {
//        [self showToast:@"直播群名称不能为空"];
//        return;
//    }
//    if (BTD_isEmptyString(self.groupInfo.avatarURL)) {
//        [self showToast:@"直播群头像不能为空"];
//        return;
//    }
    
    if ([self.delegate respondsToSelector:@selector(createLiveGroupWithInfo:)]){
        [self.delegate createLiveGroupWithInfo:self.groupInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showToast:(NSString *)text
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)popupSettingVCWithIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoCreateLiveGroupCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    @weakify(self);
    VEIMDemoSetInpuViewController *vc = [[VEIMDemoSetInpuViewController alloc] initWithTitle:cell.settingTitle.text confirmBlock:^(NSString * _Nonnull text) {
        @strongify(self);
        if (indexPath.section == 0 && indexPath.row == 0) {
            self.groupInfo.name = text;
            if (self.groupInfo.name && self.groupInfo.name.length) {
                cell.detailLabel.text = self.groupInfo.name;
            }
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            self.groupInfo.avatarURL = text;
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            self.groupInfo.desc = text;
        } else {
            self.groupInfo.notice = text;
        }
    }];
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - getter

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.layer.cornerRadius = 10;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:0.23 green:0.48 blue:0.96 alpha:1]];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
