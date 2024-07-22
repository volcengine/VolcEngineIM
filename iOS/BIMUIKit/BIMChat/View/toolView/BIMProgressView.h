//
//  BIMProgressView.h
//  im-uikit-tob
//
//  Created by Ding Jinyan on 2024/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMProgressView : UIView

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *circleColor;

@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithTrackWidth:(CGFloat)trackWidth;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated startAngle:(CGFloat)startAngle clockwise:(BOOL)clockwise;

@end

NS_ASSUME_NONNULL_END
