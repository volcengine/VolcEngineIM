//
//  VEIMDemoSetInpuView.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/24.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoSetInpuViewController.h"
#import "BIMToastView.h"

#import <Masonry/Masonry.h>

@interface VEIMDemoSetInpuViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *closeImgView;
@property(nonatomic, strong) UITextField *inputView;
@property(nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITapGestureRecognizer *tapBlankAreaToDismissGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapXToDismissGesture;

@property(nonatomic, assign) BOOL keyboardIsVisable;

@property(nonatomic, copy) void(^confirmBlock)(NSString *text);

@end

@implementation VEIMDemoSetInpuViewController

//- (instancetype)initWithTitle:(NSString *)title inputText:(NSString *)text
//{
//    if (self = [super init]) {
//        [self.titleLabel setText:[NSString stringWithFormat:@"%@", title]];
//        if (text.length) {
//            [self.inputView setText:[NSString stringWithFormat:@"%@", text]];
//        }
//
//        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    }
//    return self;
//}

- (instancetype)initWithTitle:(NSString *)title confirmBlock:(void (^)(NSString * _Nonnull))confirmBlock
{
    if (self = [super init]) {
        [self.titleLabel setText:[NSString stringWithFormat:@"%@", title]];
        self.confirmBlock = confirmBlock;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        self.keyboardIsVisable = NO;
        
        [self addKeyboardNoti];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self p_setpuUI];
    [self addGestures];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - keyboardListener

- (void)addKeyboardNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardIsVisable = YES;
    // 获取键盘高度
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSInteger height = keyboardRect.size.height;
    // 获取键盘弹出动画时间
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-height);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardIsVisable = NO;
    // 获取键盘弹出动画时间
    NSDictionary *info = [notification userInfo];
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UI
- (void)p_setpuUI
{
    self.view.alpha = 1;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.containerView];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@(0));
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.containerView).offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    [self.containerView addSubview:self.closeImgView];
    [self.closeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.containerView.mas_right).offset(-15);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.containerView addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(self.containerView).offset(-50);
    }];
    
    [self.containerView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.containerView).offset(-50);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.containerView).offset(-30);
    }];
}

#pragma mark -  Gestures

- (void)addGestures
{
    [self.maskView addGestureRecognizer:self.tapBlankAreaToDismissGesture];
    [self.closeImgView addGestureRecognizer:self.tapXToDismissGesture];
}

- (UITapGestureRecognizer *)tapXToDismissGesture
{
    if (!_tapXToDismissGesture) {
        _tapXToDismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureToDismiss)];
        _tapXToDismissGesture.delegate = self;
    }
    return _tapXToDismissGesture;
}

- (UITapGestureRecognizer *)tapBlankAreaToDismissGesture
{
    if (!_tapBlankAreaToDismissGesture) {
        _tapBlankAreaToDismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureToDismiss)];
        _tapBlankAreaToDismissGesture.delegate = self;
    }
    return _tapBlankAreaToDismissGesture;
}

- (void)gestureToDismiss
{
    if (self.keyboardIsVisable) {
        [self.inputView resignFirstResponder];
    } else {
        [self dismiss];
    }
}

#pragma mark - Actions

- (void)dismiss
{
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)confirmBtnClicked:(id)sender
{
    // 文本字数限制（临时）
    if ([self.titleLabel.text isEqualToString:@"直播群名称"]) {
        if (self.inputView.text.length > 10) {
            [BIMToastView toast:@"直播群名称限制字数:10"];
            return;
        }
    } else if ([self.titleLabel.text isEqualToString:@"直播群公告"]) {
        if (self.inputView.text.length > 100) {
            [BIMToastView toast:@"直播群公告限制字数:100"];
            return;
        }
    } else if ([self.titleLabel.text isEqualToString:@"直播群描述"]) {
        if (self.inputView.text.length > 100) {
            [BIMToastView toast:@"直播群描述限制字数:100"];
            return;
        }
    } else if ([self.titleLabel.text isEqualToString:@"直播群头像"]) {
        if (self.inputView.text.length > 0) {
            // 检查图片链接是否可用
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.inputView.text]];
            if ([self contentTypeForImageData:data] == nil) {
                [BIMToastView toast:@"头像链接不可用"];
                return;
            }
        }
    }
    if (self.confirmBlock) {
        self.confirmBlock(self.inputView.text);
    }
    [self dismiss];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
        if ([data length] < 12) {
            return nil;
        }
        NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
        if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
            return @"webp";
        }
        return nil;
    }
    return nil;
}

#pragma mark - Getter
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor lightGrayColor];
        _maskView.alpha = 0;
    }
    return _maskView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 20;
    }
    return _containerView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)closeImgView
{
    if (!_closeImgView) {
        _closeImgView = [[UIImageView alloc] init];
        [_closeImgView setImage:[UIImage imageNamed:@"icon_close"]];
        _closeImgView.userInteractionEnabled = YES;
        _closeImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _closeImgView;
}

- (UITextField *)inputView
{
    if (!_inputView) {
        _inputView = [[UITextField alloc] init];
        _inputView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        _inputView.layer.cornerRadius = 10;
        _inputView.placeholder = @" 请输入";
    }
    return _inputView;
}

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
