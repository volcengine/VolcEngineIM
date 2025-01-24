//
//  VEIMDemoProfileEditViewController.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoProfileEditViewController.h"
#import "VEIMDemoSelectAvatarViewController.h"
#import <imsdk-tob/BIMSDK.h>
#import "VEIMDemoConversationSettingCell.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoInputController.h"
#import "VEIMDemoAvatarSettingCell.h"
#import <im-uikit-tob/BIMToastView.h>
#import <OneKit/ByteDanceKit.h>

@interface VEIMDemoProfileEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settings;
@property (nonatomic, strong) BIMUserProfile *userInfo;
@end

@implementation VEIMDemoProfileEditViewController

- (instancetype)initWithUserProfile:(BIMUserProfile *)userProfile
{
    if (self = [super init]) {
        _userInfo = userProfile;
        self.title = @"个人资料";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self createSettingModels];
    @weakify(self);
    [[VEIMDemoUserManager sharedManager] getUserFullInfoList:@[@(self.userInfo.uid)] syncServer:YES completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {
        @strongify(self);
        self.userInfo = infos.lastObject.userProfile;
        [self createSettingModels];
    }];
}

- (void)createSettingModels
{
    self.settings = [NSMutableArray array];
    [self.settings addObject:[self createAvatarModel]];
    [self.settings addObject:[self createNickModel]];
    [self.settings addObject:[self createExtModel]];
    
    [self.tableView reloadData];
}

- (VEIMDemoAvatarSettingModel *)createAvatarModel
{
    // 设置头像
//    VEIMDemoSettingModel *model = [VEIMDemoSettingModel settingWithTitle:@"头像" detail:nil isNeedSwitch:NO switchOn:NO];
    VEIMDemoAvatarSettingModel *model = [[VEIMDemoAvatarSettingModel alloc] init];
    model.title = @"头像";
    model.avatarUrl = self.userInfo.portraitUrl;
    @weakify(self);
    model.clickHandler = ^{
        @strongify(self);
        VEIMDemoSelectAvatarViewController *vc = [[VEIMDemoSelectAvatarViewController alloc] initWithType:VEIMDemoSelectAvatarTypeUserProfile];
        vc.selectCallBack = ^(NSString * _Nonnull url) {
            // 测试声明周期问题
            [[BIMClient sharedInstance] setUserSelfPortrait:url completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                } else {
                    self.userInfo.portraitUrl = url;
                    [self createSettingModels];
                }
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    return model;
}

- (VEIMDemoSettingModel *)createNickModel
{
    NSString *nickName = self.userInfo.nickName.length ? self.userInfo.nickName : [[VEIMDemoUserManager sharedManager] nicknameForTestUser:self.userInfo.uid];
    VEIMDemoSettingModel *model = [VEIMDemoSettingModel settingWithTitle:@"昵称" detail:nickName isNeedSwitch:NO switchOn:NO];
    @weakify(self);
    model.clickHandler = ^{
        @strongify(self);
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"我的昵称" text:nickName maxWordCount:100 editable:YES handler:^(NSString * _Nonnull text) {
            NSString *nickName = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (!nickName.length) {
                [BIMToastView toast:@"昵称不可为空"];
                return;
            }
            [[BIMClient sharedInstance] setUserSelfNickName:nickName completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                } else {
                    self.userInfo.nickName = nickName;
                    [self createSettingModels];
                }
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return model;
}

- (VEIMDemoSettingModel *)createExtModel
{
    NSString *detail = nil;
    if (self.userInfo.ext.count) {
        detail =  [self.userInfo.ext btd_jsonStringEncoded];
    }
    VEIMDemoSettingModel *model = [VEIMDemoSettingModel settingWithTitle:@"自定义字段" detail:detail isNeedSwitch:NO switchOn:NO];
    @weakify(self);
    model.clickHandler = ^{
        @strongify(self);
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"自定义字段" text:detail maxWordCount:100 editable:YES handler:^(NSString * _Nonnull text) {
            NSDictionary *ext = [text btd_jsonDictionary];
            if (!ext) {
                return;
            }
            [[BIMClient sharedInstance] setUserSelfExt:ext completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                } else {
                    [[BIMClient sharedInstance] getUserFullInfo:self.userInfo.uid completion:^(BIMUserFullInfo * _Nullable info, BIMError * _Nullable error) {
                        self.userInfo.ext = info.userProfile.ext;
                        [self createSettingModels];
                    }];
                }
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return model;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id setting = self.settings[indexPath.row];
    
    VEIMDemoConversationSettingCell *cell = nil;
    if ([setting isKindOfClass:[VEIMDemoAvatarSettingModel class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VEIMDemoAvatarSettingCell class])];
    } else if ([setting isKindOfClass:[VEIMDemoSettingModel class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VEIMDemoConversationSettingCell class])];
    }
    
    cell.model = setting;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long long currentUID = [VEIMDemoUserManager sharedManager].currentUser.userID;
    if (currentUID != self.userInfo.uid) {
        return;
    }
    if (!self.canSelfEdit) {
        return;
    }
    VEIMDemoSettingModel *model = self.settings[indexPath.row];
    if (model.clickHandler) {
        model.clickHandler();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[VEIMDemoConversationSettingCell class] forCellReuseIdentifier:NSStringFromClass([VEIMDemoConversationSettingCell class])];
        [_tableView registerClass:[VEIMDemoAvatarSettingCell class] forCellReuseIdentifier:NSStringFromClass([VEIMDemoAvatarSettingCell class])];
    }
    return _tableView;
}

@end
