//
//  VEIMDemoTestUserCell.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import "BIMPortraitBaseCell.h"
#import "VEIMDemoUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoTestUserCell : BIMPortraitBaseCell

@property (nonatomic, strong) VEIMDemoUser *user;

@property (nonatomic, strong) UIButton *checkMark;

@property (nonatomic, strong) UIImageView *silentMark;

- (void)hideCheckMark: (BOOL)hide;
- (void)hideSilentMark: (BOOL)hide;

@property (nonatomic, strong, nullable) void(^longPressHandler)(UILongPressGestureRecognizer *gesture);


@end

NS_ASSUME_NONNULL_END
