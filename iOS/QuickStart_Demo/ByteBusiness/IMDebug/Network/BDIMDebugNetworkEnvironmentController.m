//
//  BDIMDebugNetworkEnvironmentController.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/8.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugNetworkEnvironmentController.h"
#import "BDIMDebugNetworkManager.h"
#import <Masonry/Masonry.h>

@interface BDIMDebugNetworkEnvironmentController ()
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) UIButton *countryBtn;
@property (nonatomic, strong) UILabel *envLabel;
@property (nonatomic, strong) UIButton *envBtn;
@property (nonatomic, strong) UILabel *netLaneLabel;
@property (nonatomic, strong) UIButton *netLaneBtn;
@property (nonatomic, strong) UILabel *tokenUrlLabel;
@property (nonatomic, strong) UILabel *apiUrlLabel;
@property (nonatomic, strong) UILabel *frontierUrlLabel;
@property (nonatomic, strong) UILabel *videoDomainLabel;
@property (nonatomic, strong) UILabel *imageDomainLabel;
@property (nonatomic, strong) UILabel *onlyHttpLabel;
@property (nonatomic, strong) UISwitch *onlyHttpSwitch;

@property (nonatomic, strong) UILabel *showNetworkMonitorLabel;
@property (nonatomic, strong) UISwitch *showNetworkMonitorSwitch;

@end

@implementation BDIMDebugNetworkEnvironmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIElements];
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:BDIMDebugNetworkChangeNotification object:nil];
}

- (void)didReceiveNoti: (NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([noti.name isEqualToString:BDIMDebugNetworkChangeNotification]) {
            [self refresh];
        }
    });
}

- (void)setupUIElements{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.countryLabel = [UILabel new];
    self.countryLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.countryLabel];
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(80);
    }];
    
    self.envLabel = [UILabel new];
    self.envLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.envLabel];
    [self.envLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.countryLabel.mas_bottom).with.offset(24);
    }];
    
    self.countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countryBtn.layer.cornerRadius = 8;
    self.countryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.countryBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.5];
    [self.countryBtn addTarget:self action:@selector(countryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.countryBtn];
    [self.countryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countryLabel.mas_right).with.offset(12);
        make.centerY.equalTo(self.countryLabel);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    self.envBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.envBtn];
    self.envBtn.layer.cornerRadius = 8;
    self.envBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.envBtn addTarget:self action:@selector(envBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.envBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:0.5];
    [self.envBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.envLabel.mas_right).with.offset(12);
        make.centerY.equalTo(self.envLabel);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    self.netLaneLabel = [UILabel new];
    self.netLaneLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.netLaneLabel];
    [self.netLaneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.envLabel.mas_bottom).with.offset(24);
    }];
    
    self.netLaneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.netLaneBtn];
    self.netLaneBtn.layer.cornerRadius = 8;
    self.netLaneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.netLaneBtn addTarget:self action:@selector(netLaneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.netLaneBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.9 alpha:0.5];
    [self.netLaneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.netLaneLabel.mas_right).with.offset(12);
        make.centerY.equalTo(self.netLaneLabel);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    
    self.tokenUrlLabel = [UILabel new];
    self.tokenUrlLabel.font = [UIFont systemFontOfSize:14];
    self.tokenUrlLabel.numberOfLines = 0;
    [self.view addSubview:self.tokenUrlLabel];
    [self.tokenUrlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.netLaneLabel.mas_bottom).with.offset(24);
    }];
    self.apiUrlLabel = [UILabel new];
    self.apiUrlLabel.font = [UIFont systemFontOfSize:14];
    self.apiUrlLabel.numberOfLines = 0;
    [self.view addSubview:self.apiUrlLabel];
    [self.apiUrlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.tokenUrlLabel.mas_bottom).with.offset(24);
    }];
    self.frontierUrlLabel = [UILabel new];
    self.frontierUrlLabel.font = [UIFont systemFontOfSize:14];
    self.frontierUrlLabel.numberOfLines = 0;
    [self.view addSubview:self.frontierUrlLabel];
    [self.frontierUrlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.apiUrlLabel.mas_bottom).with.offset(24);
    }];
    self.videoDomainLabel = [UILabel new];
    self.videoDomainLabel.font = [UIFont systemFontOfSize:14];
    self.videoDomainLabel.numberOfLines = 0;
    [self.view addSubview:self.videoDomainLabel];
    [self.videoDomainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.frontierUrlLabel.mas_bottom).with.offset(24);
    }];
    self.imageDomainLabel = [UILabel new];
    self.imageDomainLabel.font = [UIFont systemFontOfSize:14];
    self.imageDomainLabel.numberOfLines = 0;
    [self.view addSubview:self.imageDomainLabel];
    [self.imageDomainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.videoDomainLabel.mas_bottom).with.offset(24);
    }];
    
    self.onlyHttpLabel = [UILabel new];
    self.onlyHttpLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.onlyHttpLabel];
    [self.onlyHttpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.imageDomainLabel.mas_bottom).with.offset(24);
    }];
    
    self.onlyHttpSwitch = [[UISwitch alloc] init];
    [self.onlyHttpSwitch addTarget:self action:@selector(httpSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.onlyHttpSwitch];
    [self.onlyHttpSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onlyHttpLabel.mas_right).with.offset(12);
        make.centerY.equalTo(self.onlyHttpLabel);
    }];
    
    self.showNetworkMonitorLabel = [UILabel new];
    self.showNetworkMonitorLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:self.showNetworkMonitorLabel];
    [self.showNetworkMonitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.onlyHttpLabel.mas_bottom).with.offset(24);
    }];
    
    self.showNetworkMonitorSwitch = [[UISwitch alloc] init];
    [self.showNetworkMonitorSwitch addTarget:self action:@selector(monitorSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.showNetworkMonitorSwitch];
    [self.showNetworkMonitorSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showNetworkMonitorLabel.mas_right).with.offset(12);
        make.centerY.equalTo(self.showNetworkMonitorLabel);
    }];
}

-(void)netLaneBtnClick:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"netLane" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"请输入泳道名"];
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!alertController.textFields[0].text) {
            return;
        }
        NSString *laneStr = alertController.textFields[0].text;
        [[BDIMDebugNetworkManager sharedManager] setNetLane:laneStr];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirm];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)envBtnClick: (id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose env" message:@"choose env to switch" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ppeAc = [UIAlertAction actionWithTitle:@"PPE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[BDIMDebugNetworkManager sharedManager] setEnv:BDIMDebugNetworkEnvTypePPE];
    }];
    [alertController addAction:ppeAc];
    UIAlertAction *boeAc = [UIAlertAction actionWithTitle:@"BOE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[BDIMDebugNetworkManager sharedManager] setEnv:BDIMDebugNetworkEnvTypeBOE];
    }];
    [alertController addAction:boeAc];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)countryBtnClick: (id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose country" message:@"choose country to switch" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *chinaAc = [UIAlertAction actionWithTitle:@"China" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[BDIMDebugNetworkManager sharedManager] setCountry:BDIMDebugNetworkCountryTypeChina];
//    }];
//    [alertController addAction:chinaAc];
//    UIAlertAction *singAc = [UIAlertAction actionWithTitle:@"Singapore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[BDIMDebugNetworkManager sharedManager] setCountry:BDIMDebugNetworkCountryTypeSingapore];
//    }];
//    [alertController addAction:singAc];
//    UIAlertAction *USEastAc = [UIAlertAction actionWithTitle:@"US-East" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[BDIMDebugNetworkManager sharedManager] setCountry:BDIMDebugNetworkCountryTypeUSEast];
//    }];
//    [alertController addAction:USEastAc];
//    UIAlertAction *USEastRedAc = [UIAlertAction actionWithTitle:@"US-GCP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[BDIMDebugNetworkManager sharedManager] setCountry:BDIMDebugNetworkCountryTypeUSGCP];
//    }];
//    [alertController addAction:USEastRedAc];
    
    UIAlertAction *tob = [UIAlertAction actionWithTitle:@"Tob" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[BDIMDebugNetworkManager sharedManager] setCountry:BDIMDebugNetworkCountryTypeTob];
    }];
    [alertController addAction:tob];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)httpSwitch: (UISwitch *)swit{
//    kIMShareInstance.httpOnly = swit.on;
//    [[IM_Manager sharedManager] configNetworkEnv];
}
- (void)monitorSwitch: (UISwitch *)swit{
    [[BDIMDebugNetworkManager sharedManager] showMonitor:swit.on];
}

- (void)refresh{
    self.countryLabel.text = @"Country: ";
    self.envLabel.text = @"Env: ";
    self.netLaneLabel.text = @"NetLane: ";
    self.tokenUrlLabel.text = [NSString stringWithFormat:@"TokenUrl: \n%@",[[BDIMDebugNetworkManager sharedManager] tokenUrl]];
    self.apiUrlLabel.text = [NSString stringWithFormat:@"ApiUrl: \n%@",[[BDIMDebugNetworkManager sharedManager] apiUrl]];
    self.frontierUrlLabel.text = [NSString stringWithFormat:@"FrontierUrl: \n%@",[[BDIMDebugNetworkManager sharedManager] frontierUrl]];
    self.videoDomainLabel.text = [NSString stringWithFormat:@"VideoDomain: \n%@",[[BDIMDebugNetworkManager sharedManager] videoDomain]];
    self.imageDomainLabel.text = [NSString stringWithFormat:@"ImageDomain: \n%@",[[BDIMDebugNetworkManager sharedManager] imageDomain]];
    self.onlyHttpLabel.text = @"Http only: ";
//    self.onlyHttpSwitch.on = kIMShareInstance.httpOnly;
    [self.countryBtn setTitle:[[BDIMDebugNetworkManager sharedManager] currentCountryDesc] forState:UIControlStateNormal];
    [self.envBtn setTitle:[[BDIMDebugNetworkManager sharedManager] currentEnvDesc] forState:UIControlStateNormal];
    [self.netLaneBtn setTitle:[[BDIMDebugNetworkManager sharedManager] currentNetLane] forState:UIControlStateNormal];
    
    self.showNetworkMonitorLabel.text = @"show network monitor: ";
    BOOL isShowing = NO;
    if ([BDIMDebugNetworkManager sharedManager].monitor && ![BDIMDebugNetworkManager sharedManager].monitor.hidden) {
        isShowing = YES;
    }
    self.showNetworkMonitorSwitch.on = isShowing;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
