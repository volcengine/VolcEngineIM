//
//  BIMMessageDetailDebugViewController.m
//  im-uikit-tob
//
//  Created by yangzhanjiang on 2024/1/31.
//

#import "BIMMessageDetailDebugViewController.h"
#import <imsdk-tob/BIMSDK.h>
#import <Masonry/Masonry.h>
#import <OneKit/BTDMacros.h>
#import "BIMUIDefine.h"

@interface BIMLableTextField : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation BIMLableTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.label];
    [self addSubview:self.textField];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.label.mas_right);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - getter

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}

@end

@interface BIMMessageDetailDebugViewController ()
@property (nonatomic, strong) BIMLableTextField *messageTextField;
@property (nonatomic, strong) BIMLableTextField *convTextField;
@property (nonatomic, strong) UIButton *queryButton;

@property (nonatomic, strong) UITextView *localMessageTextView;
@property (nonatomic, strong) UITextView *remoteMessageTextView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *remoteLabel;
@property (nonatomic, strong) UILabel *localLabel;


@end

@implementation BIMMessageDetailDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self queryButtonClick];
}

- (void)setupUIElements
{
    [super setupUIElements];
    self.title = @"消息详情";
    [self.view addSubview:self.messageTextField];
    [self.view addSubview:self.convTextField];
    [self.view addSubview:self.queryButton];
    [self.view addSubview:self.remoteMessageTextView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.localMessageTextView];
    [self.view addSubview:self.remoteLabel];
    [self.view addSubview:self.localLabel];
    
    
    [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.convTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageTextField.mas_bottom);
        make.left.right.height.equalTo(self.messageTextField);
    }];
//    
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.convTextField.mas_bottom);
        make.height.width.mas_equalTo(60);
        make.centerX.equalTo(self.view);
    }];
//    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.queryButton.mas_bottom);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self.view);
    }];
    
    [self.remoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.queryButton.mas_bottom);
        make.left.equalTo(self.view).mas_offset(2);
    }];
    
    [self.localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remoteLabel);
        make.left.equalTo(self.line.mas_right).mas_offset(2);
    }];
//
    [self.remoteMessageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.equalTo(self.line.mas_left);
        make.top.equalTo(self.remoteLabel.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    
    [self.localMessageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line.mas_right);
        make.right.equalTo(self.view);
        make.top.equalTo(self.remoteMessageTextView);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - event

- (void)queryButtonClick
{
    @weakify(self);
    long long serverMsgID = self.messageTextField.textField.text.longLongValue;
    long long convShortID = self.convTextField.textField.text.longLongValue;
    self.localMessageTextView.text = nil;
    self.remoteMessageTextView.text = nil;
    [[BIMClient sharedInstance] getMessageByServerID:serverMsgID inConversationShortID:convShortID isServer:NO completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
        @strongify(self);
        NSString *msg = [[message valueForKey:@"message"] description];
        self.localMessageTextView.text = msg;
    }];
    
    [[BIMClient sharedInstance] getMessageByServerID:serverMsgID inConversationShortID:convShortID isServer:YES completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            self.remoteMessageTextView.text = [NSString stringWithFormat:@"查询消息失败:\n%@", error.localizedDescription];
        } else {
            NSString *msg = [[message valueForKey:@"message"] description];
            self.remoteMessageTextView.text = msg;
        }
    }];
}

#pragma mark - getter

- (BIMLableTextField *)messageTextField
{
    if (!_messageTextField) {
        _messageTextField = [[BIMLableTextField alloc] init];
        _messageTextField.label.text = @"消息ID";
        _messageTextField.textField.text = self.message.serverMessageID.stringValue;
    }
    return _messageTextField;
}

- (BIMLableTextField *)convTextField
{
    if (!_convTextField) {
        _convTextField = [[BIMLableTextField alloc] init];
        _convTextField.label.text = @"会话ID";
        _convTextField.textField.text = @(self.conversationShortID).stringValue;
    }
    return _convTextField;
}

- (UIButton *)queryButton
{
    if (!_queryButton) {
        _queryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        _queryButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_queryButton addTarget:self action:@selector(queryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}

- (UITextView *)remoteMessageTextView
{
    if (!_remoteMessageTextView) {
        _remoteMessageTextView = [[UITextView alloc] init];
        _remoteMessageTextView.editable = NO;
    }
    return _remoteMessageTextView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UITextView *)localMessageTextView
{
    if (!_localMessageTextView) {
        _localMessageTextView = [[UITextView alloc] init];
        _localMessageTextView.editable = NO;
    }
    return _localMessageTextView;
}

- (UILabel *)remoteLabel
{
    if (!_remoteLabel) {
        _remoteLabel = [UILabel new];
        _remoteLabel.text = @"服务端详情";
        _remoteLabel.textColor = [UIColor grayColor];
    }
    return _remoteLabel;
}

- (UILabel *)localLabel
{
    if (!_localLabel) {
        _localLabel = [UILabel new];
        _localLabel.text = @"本地详情";
        _localLabel.textColor = [UIColor grayColor];
    }
    return _localLabel;
}

@end
