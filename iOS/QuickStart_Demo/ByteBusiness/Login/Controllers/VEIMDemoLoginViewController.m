//
//  VEIMDemoLoginViewController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//

#import "VEIMDemoLoginViewController.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoUser.h"
#import "VEIMDemoTestUserCell.h"
#import "VEIMDemoDefine.h"
#import "BIMToastView.h"

#import <Masonry/Masonry.h>

@interface VEIMDemoLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UITableView *testUsersContainer;
@property (nonatomic, strong) UITextView *loginPromptLabel;
@property (nonatomic, strong) UIButton *checkMark;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSMutableArray <VEIMDemoUser *> *testUsers;
@property (nonatomic, strong) VEIMDemoUser *currentSelectedUser;

//@property (nonatomic, strong) UITextField *inputField;

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
    
    self.testUsers = [[VEIMDemoUserManager sharedManager] createTestUsers:YES];
}



- (void)setupUIElements{
    [super setupUIElements];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.welcomeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.welcomeLabel];
    self.welcomeLabel.font = [UIFont boldSystemFontOfSize:24];
    self.welcomeLabel.text = @"欢迎登录IM Demo";
    
    self.promptLabel = [[UILabel alloc] init];
    [self.view addSubview:self.promptLabel];
    self.promptLabel.font = [UIFont systemFontOfSize:16];
    self.promptLabel.text = @"请从以下账号中选择一个进行登录";
    
    self.testUsersContainer = [[UITableView alloc] init];
    self.testUsersContainer.delegate = self;
    self.testUsersContainer.dataSource = self;
    [self.testUsersContainer registerClass:[VEIMDemoTestUserCell class] forCellReuseIdentifier:@"VEIMDemoTestUserCell"];
    [self.view addSubview:self.testUsersContainer];
    
    self.checkMark = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_normal"] forState:UIControlStateNormal];
    [self.checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_sel"] forState:UIControlStateSelected];
    [self.checkMark addTarget:self action:@selector(checkMarkClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkMark];
    
    self.loginPromptLabel = [[UITextView alloc] init];
    self.loginPromptLabel.delegate = self;
    [self.view addSubview:self.loginPromptLabel];
    self.loginPromptLabel.font = [UIFont systemFontOfSize:14];
    self.loginPromptLabel.textColor = [UIColor blackColor];
    self.loginPromptLabel.contentSize = CGSizeMake(0, 0);
    self.loginPromptLabel.scrollEnabled = NO;
    self.loginPromptLabel.editable = NO;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"已阅读并同意"];
    NSAttributedString *user = [[NSAttributedString alloc] initWithString:@"用户协议" attributes:@{NSLinkAttributeName:[NSURL URLWithString:@"https://www.volcengine.com/docs/6348/975891"]}];
    [str appendAttributedString:user];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" 和 "]];
    NSAttributedString *privacy = [[NSAttributedString alloc] initWithString:@"隐私政策" attributes:@{NSLinkAttributeName:[NSURL URLWithString:@"https://www.volcengine.com/docs/6348/975890"]}];
    [str appendAttributedString:privacy];
    
    self.loginPromptLabel.attributedText = str;
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.borderWidth = 2;
    self.loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    self.inputField = [UITextField new];
//    self.inputField.layer.borderColor = [UIColor blackColor].CGColor;
//    self.inputField.layer.borderWidth = 1.0;
//    self.inputField.placeholder = @"输入自定义uid登录";
//    [self.view addSubview:self.inputField];
    
    

    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(KScreenHeight<680?    60:140);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.welcomeLabel);
        make.top.equalTo(self.welcomeLabel.mas_bottom).with.offset(24);
        make.right.mas_lessThanOrEqualTo(-24);
    }];
    
    [self.testUsersContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(12);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(360);
    }];
    
    [self.checkMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.left.equalTo(self.welcomeLabel);
        make.top.equalTo(self.testUsersContainer.mas_bottom).with.offset(24);
        
    }];
    
    [self.loginPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkMark.mas_right).with.offset(12);
        make.centerY.equalTo(self.checkMark);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-24);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.welcomeLabel);
        make.top.equalTo(self.loginPromptLabel.mas_bottom).with.offset(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(40);
    }];
    
//    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.welcomeLabel);
//        make.top.equalTo(self.loginBtn.mas_bottom).offset(16);
//        make.right.mas_equalTo(-24);
//    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:nil];
    return YES;
}

- (void)loginBtnClicked: (id)sender{
    if (!self.checkMark.selected) {
        [BIMToastView toast:@"请同意协议后登录"];
        return;
    }
    
    if (self.currentSelectedUser) {
        [[VEIMDemoUserManager sharedManager] loginWithUser:self.currentSelectedUser completion:^(NSError * _Nullable error) {
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

- (void)checkMarkClick: (id)sender{
    self.checkMark.selected = !self.checkMark.selected;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEIMDemoTestUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoTestUserCell"];
    VEIMDemoUser *user = [self.testUsers objectAtIndex:indexPath.row];
    [cell hideSilentMark:YES];
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.currentSelectedUser) {
//        self.currentSelectedUser.isSelected = NO;
//    }
//    VEIMDemoUser *user = [self.testUsers objectAtIndex:indexPath.row];
//    user.isSelected = YES;
//    self.currentSelectedUser = user;
    VEIMDemoUser *user = [self.testUsers objectAtIndex:indexPath.row];
    if (self.currentSelectedUser) {
        if (self.currentSelectedUser == user) {
            user.isSelected = NO;
            self.currentSelectedUser = nil;
        } else {
            self.currentSelectedUser.isSelected = NO;
            user.isSelected = YES;
            self.currentSelectedUser = user;
        }
    } else {
        user.isSelected = YES;
        self.currentSelectedUser = user;
    }
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.testUsers.count;
}


@end
