//
//  BIMProgressView.m
//  im-uikit-tob
//
//  Created by Ding Jinyan on 2024/7/3.
//

#import "BIMProgressView.h"
#import <Masonry/Masonry.h>

@interface BIMProgressView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *frontFillLayer;

@property (nonatomic, assign) CGFloat trackWidth;

@end


@implementation BIMProgressView

- (instancetype)initWithTrackWidth:(CGFloat)trackWidth
{
    if (self = [super init])
    {
        _trackWidth = trackWidth;
        
        [self setupSubviews];
    }
    return self;

}

- (void)setupSubviews
{
    //创建背景图层
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = nil;

    //创建填充图层
    _frontFillLayer = [CAShapeLayer layer];
    _frontFillLayer.fillColor = nil;
    _frontFillLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_frontFillLayer];
    
    //设置颜色
    _frontFillLayer.strokeColor  = [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1.0].CGColor;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
  
}

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // 设置线宽
    _frontFillLayer.lineWidth = self.trackWidth;
    _backgroundLayer.lineWidth = self.trackWidth;
    CGFloat width = self.bounds.size.width;
    UIBezierPath *backgroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)- self.trackWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
    _backgroundLayer.path = backgroundBezierPath.CGPath;
    
    CGFloat endAngle = -(M_PI_2) + (2*M_PI)*self.progress;
    UIBezierPath *frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-self.trackWidth)/2.f startAngle:-(M_PI_2) endAngle:endAngle clockwise:YES];
    _frontFillLayer.path = frontFillBezierPath.CGPath;
    
    if (self.trackWidth < 0) {
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.duration = 0.1;//动画时间
        basicAnimation.fromValue=[NSNumber numberWithInteger:0];
        basicAnimation.toValue=[NSNumber numberWithInteger:1];
        [_frontFillLayer addAnimation:basicAnimation forKey:@"strokeKey"];
    }
}

#pragma mark -- setter方法
- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _frontFillLayer.strokeColor = progressColor.CGColor;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    _backgroundLayer.strokeColor = circleColor.CGColor;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO startAngle:-(M_PI_2) clockwise:YES];

}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    
    [self setProgress:progress animated:animated startAngle:-(M_PI_2) clockwise:YES];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated startAngle:(CGFloat )startAngle clockwise:(BOOL)clockwise
{
    progress = MAX( MIN(progress, 1.0), 0.0);
    _progress = progress;
    
    [self setNeedsLayout];
}

@end
