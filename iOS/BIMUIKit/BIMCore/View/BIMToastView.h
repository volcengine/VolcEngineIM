//
//  CommonToastView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/2.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BIMToastView : UIView

+ (instancetype)sharedToast;
+ (void)toast:(NSString *)message;
+ (void)toast:(NSString *)message withDuration:(CGFloat)duration;

- (void)toast:(NSString *)message inView:(UIView *)view;
- (void)toast:(NSString *)message inView:(UIView *)view withDuration:(CGFloat)duration;

+ (void)dismiss;

@end
