//
//  BIMConversationDetailDebugViewController.m
//  Bolts
//
//  Created by yangzhanjiang on 2024/4/17.
//

#import "VEIMDemoConversationDetailDebugViewController.h"

#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>
#import <Masonry/Masonry.h>
#import <OneKit/BTDMacros.h>
#import "BIMUIDefine.h"
#import "BIMLableTextField.h"
//#import "BIMConversation.h"


@interface VEIMDemoConversationDetailDebugViewController ()

@property (nonatomic, strong) BIMLableTextField *convTextField;
@property (nonatomic, strong) UIButton *queryButton;

@property (nonatomic, strong) UITextView *localMessageTextView;
@property (nonatomic, strong) UITextView *remoteMessageTextView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *remoteLabel;
@property (nonatomic, strong) UILabel *localLabel;

@end

@implementation VEIMDemoConversationDetailDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self queryButtonClick];
}

- (void)setupUIElements
{
    [super setupUIElements];
    self.title = @"会话详情";
    [self.view addSubview:self.convTextField];
    [self.view addSubview:self.queryButton];
    [self.view addSubview:self.remoteMessageTextView];
    [self.view addSubview:self.line];
    [self.view addSubview:self.localMessageTextView];
    [self.view addSubview:self.remoteLabel];
    [self.view addSubview:self.localLabel];
    
    
    [self.convTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
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
    self.localMessageTextView.text = nil;
    self.remoteMessageTextView.text = nil;
    if ([self.convTextField.textField.text containsString:@","]) {
        [self queryBatchConversation];
    } else {
        [self querySingleConversation];
    }
}

// 单个会话请求
- (void)querySingleConversation
{
    @weakify(self);
    long long convShortID = self.convTextField.textField.text.longLongValue;
    [[BIMClient sharedInstance] getConversationByShortID:convShortID isServer:NO completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            self.localMessageTextView.text = [NSString stringWithFormat:@"查询会话失败:\n%@", error.localizedDescription];
        } else {
            NSString *msg = [[conversation valueForKey:@"conversation"] description];
            self.localMessageTextView.text = msg;
        }
    }];
    
    [[BIMClient sharedInstance] getConversationByShortID:convShortID isServer:YES completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            self.remoteMessageTextView.text = [NSString stringWithFormat:@"查询会话失败:\n%@", error.localizedDescription];
        } else {
            NSString *msg = [[conversation valueForKey:@"conversation"] description];
            self.remoteMessageTextView.text = msg;
        }
    }];
}

// 批量会话请求
- (void)queryBatchConversation
{
    @weakify(self);
    NSMutableArray *convShortIDs = [[self.convTextField.textField.text componentsSeparatedByString:@","] mutableCopy];
    if ([[convShortIDs.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [convShortIDs removeLastObject];
    }
    [[BIMClient sharedInstance] getConversationByShortIDList:convShortIDs isServer:NO completion:^(NSArray<BIMConversation *> * _Nullable conversations, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            self.localMessageTextView.text = [NSString stringWithFormat:@"查询会话失败:\n%@", error.localizedDescription];
        } else {
            NSString *msg = [[conversations valueForKey:@"conversation"] componentsJoinedByString:@"\n\n-------------------------------------------\n\n"];
            self.localMessageTextView.text = msg;
        }
    }];
    
    [[BIMClient sharedInstance] getConversationByShortIDList:convShortIDs isServer:YES completion:^(NSArray<BIMConversation *> * _Nullable conversations, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            self.remoteMessageTextView.text = [NSString stringWithFormat:@"查询会话失败:\n%@", error.localizedDescription];
        } else {
            NSString *msg = [[conversations valueForKey:@"conversation"] componentsJoinedByString:@"\n\n-------------------------------------------\n\n"];
            self.remoteMessageTextView.text = msg;
        }
    }];
}

#pragma mark - getter

- (BIMLableTextField *)convTextField
{
    if (!_convTextField) {
        _convTextField = [[BIMLableTextField alloc] init];
        _convTextField.label.text = @"会话shortID";
        _convTextField.textField.text = self.conversation.conversationShortID.stringValue;
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
        _remoteMessageTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
        _localMessageTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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

