//
//  TIMSlideLineButton.m
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/16.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import "BIMSlideLineButton.h"

static CGFloat const TIMSlideLineHeight = 22.0;


@interface BIMSlideLineButton ()
@property (nonatomic, strong) NSArray<UIView *> *lineViews;
@end


@implementation BIMSlideLineButton

- (instancetype)init
{
    if (self = [super init]) {
        self.linePosition = BIMSlideLineButtonPositionNone;
        self.lineColor = [UIColor blackColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        [self setNeedsLayout];
    }
}

- (void)setLinePosition:(BIMSlideLineButtonPosition)linePosition
{
    if (_linePosition != linePosition) {
        _linePosition = linePosition;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (UIView *lineView in self.lineViews) {
        [lineView removeFromSuperview];
    }
    self.lineViews = nil;

    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.bounds) - TIMSlideLineHeight) / 2, 1.f / [UIScreen mainScreen].scale, TIMSlideLineHeight)];
    leftLine.backgroundColor = self.lineColor;
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 1.f / [UIScreen mainScreen].scale, (CGRectGetHeight(self.bounds) - TIMSlideLineHeight) / 2, 1.f / [UIScreen mainScreen].scale, TIMSlideLineHeight)];
    rightLine.backgroundColor = self.lineColor;

    NSMutableArray *lineViews = [[NSMutableArray alloc] init];
    switch (self.linePosition) {
        case BIMSlideLineButtonPositionNone:
            break;
        case BIMSlideLineButtonPositionLeft:
            [lineViews addObject:leftLine];
            [self addSubview:leftLine];
            break;
        case BIMSlideLineButtonPositionRight:
            [lineViews addObject:rightLine];
            [self addSubview:rightLine];
            break;
        case BIMSlideLineButtonPositionBoth:
            [lineViews addObject:leftLine];
            [lineViews addObject:rightLine];
            [self addSubview:leftLine];
            [self addSubview:rightLine];
            break;
        default:
            break;
    }
    self.lineViews = lineViews;
}

@end
