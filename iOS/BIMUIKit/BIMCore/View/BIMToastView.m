//
//  CommonToastView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/2.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMToastView.h"
#import "BIMUIDefine.h"
#import <OneKit/UIView+BTDAdditions.h>

static CGFloat kFont = 14.0;

@interface BIMToastView ()

@property (nonatomic) UILabel *label;
@property (nonatomic) NSTimer *fadeOutTimer;

@end


@implementation BIMToastView

+ (instancetype)sharedToast
{
    static BIMToastView *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupControl];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGSize baseSize = [self.label.text boundingRectWithSize:CGSizeMake(KScreenWidth * 0.7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kFont]} context:nil].size;

    return baseSize;
}


- (void)layoutSubviews
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 6.0;

    [super layoutSubviews];
}

- (void)setupControl
{
    self.backgroundColor = kRGBCOLOR(0, 0, 0, 0.8);
    [self addSubview:self.label];
    [self layoutLabel];
}

- (void)layoutLabel
{
//    self.label.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.label.bounds.size.width, self.label.bounds.size.height);
    self.label.bounds = [self.label.text boundingRectWithSize:CGSizeMake(KScreenWidth * 0.7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kFont]} context:nil];
}

- (void)toast:(NSString *)message inView:(UIView *)view
{
    [self toast:message inView:view withDuration:0.8f];
}

- (void)toast:(NSString *)message inView:(UIView *)view withDuration:(CGFloat)duration
{
    if (!message || [message isEqualToString:@""]) {
        return;
    }

    __weak typeof(self) wself = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(wself) self = wself;
        if (!self.superview) {
            if (view) {
                [view addSubview:self];
            } else {
                [self.frontWindow addSubview:self];
            }
        }
//        self.label.frame = CGRectZero;
        self.label.text = message;
//        [self.label sizeToFit];
        [self layoutLabel];
        [self invalidateIntrinsicContentSize];
        self.alpha = 0.f;
        self.transform = CGAffineTransformIdentity;
        if (view) {
            self.btd_width = self.label.btd_width + 32;
            self.btd_height = self.label.btd_height + 32;
            self.btd_left = self.superview.btd_left + (self.superview.btd_width - self.btd_width) / 2.0;
            self.btd_top = self.superview.btd_top + (self.superview.btd_height - self.btd_height) / 2.0;
        } else {
            self.btd_width = self.label.btd_width + 32;
            self.btd_height = self.label.btd_height + 32;
            self.btd_left = self.superview.btd_left + (self.superview.btd_width - self.btd_width) / 2.0;
            self.btd_top = self.superview.btd_top + (self.superview.btd_height - self.btd_height) / 2.0;
        }

        self.label.center = CGPointMake(self.btd_width / 2, self.btd_height / 2);

        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.f;
            //            self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 15);
        }];


        [self.fadeOutTimer invalidate];
        self.fadeOutTimer = [NSTimer timerWithTimeInterval:duration > 0 ? duration : 0.8f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
    }];
}

- (void)dismiss
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!self.superview) {
            return;
        }

        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.f;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (BOOL)isVisible
{
    return self.superview && self.alpha > .1f;
}

+ (void)toast:(NSString *)message
{
    [[self class] toast:message withDuration:2.0f];
}

+ (void)toast:(NSString *)message withDuration:(CGFloat)duration
{
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BIMToastView sharedToast] toast:message inView:nil withDuration:duration];
    });
}

+ (void)dismiss
{
    [[BIMToastView sharedToast] dismiss];
}


#pragma mark - Accessors

- (void)setFadeOutTimer:(NSTimer *)timer
{
    if (_fadeOutTimer) {
        [_fadeOutTimer invalidate];
        _fadeOutTimer = nil;
    }
    if (timer) {
        _fadeOutTimer = timer;
    }
}

- (UIWindow *)frontWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        BOOL windowFullScreen = (window.bounds.size.height == UIScreen.mainScreen.bounds.size.height && window.bounds.size.width == UIScreen.mainScreen.bounds.size.width);

        if (windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow && windowFullScreen) {
            return window;
        }
    }
    return nil;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:kFont];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        _label.numberOfLines = 0;
    }
    return _label;
}


@end
