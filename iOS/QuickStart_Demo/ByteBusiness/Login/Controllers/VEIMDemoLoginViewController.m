//
//  VEIMDemoLoginViewController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//

#import "VEIMDemoLoginViewController.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoUser.h"
#import "VEIMDemoDefine.h"
#import "BIMToastView.h"

#import <Masonry/Masonry.h>

@interface VEIMDemoLoginViewController ()

@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) VEIMDemoUser *currentSelectedUser;

@end

@implementation VEIMDemoLoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
    user.userIDNumber = [kVEIMDemoUserID longLongValue];
    user.userIDString = kVEIMDemoUserID;
    user.userToken = kVEIMDemoToken;
    user.name = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:user.userIDNumber];
    self.currentSelectedUser = user;
}

- (void)setupUIElements{
    [super setupUIElements];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.welcomeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.welcomeLabel];
    self.welcomeLabel.font = [UIFont boldSystemFontOfSize:24];
    self.welcomeLabel.text = @"欢迎登录IM Demo";
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.font = [UIFont systemFontOfSize:14];
    NSMutableString *infoString = [NSMutableString string];
    [infoString appendFormat:@"APPID: %@", kVEIMDemoAppID];
    [infoString appendFormat:@"\n\n用户ID: %@", kVEIMDemoUserID];
    [infoString appendFormat:@"\n\ntoken: %@", kVEIMDemoToken];
    self.infoLabel.text = infoString;
    [self.view addSubview:self.infoLabel];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.borderWidth = 2;
    self.loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        

    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(KScreenHeight<680?    60:140);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.welcomeLabel);
        make.top.equalTo(self.welcomeLabel.mas_bottom).with.offset(100);
        make.right.mas_lessThanOrEqualTo(-24);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.welcomeLabel);
        make.top.equalTo(self.infoLabel.mas_bottom).with.offset(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)loginBtnClicked: (id)sender{
    if (!kVEIMDemoUserID.length) {
        [BIMToastView toast:@"uid不能为空，请在kVEIMDemoUserID中填写正确的uid"];
        return;
    }
    
    if (self.currentSelectedUser) {
        [[VEIMDemoUserManager sharedManager] loginWithUser:self.currentSelectedUser isUseStringUid:NO completion:^(NSError * _Nullable error) {
            if (!error) {
                [BIMToastView toast:@"登录成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [BIMToastView toast:[NSString stringWithFormat:@"登录失败：%@", error.localizedDescription]];
            }
        }];
    } else {
        [BIMToastView toast:@"请选择用户登录"];
    }
}

@end
