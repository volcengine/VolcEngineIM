//
//  VEIMDemoRouter.h
//  VEIMDemo
//
//  Created by Weibai on 2022/10/28.
//

#import <UIKit/UIKit.h>>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoRouter : NSObject

+ (instancetype)shared;

- (void)presentViewController: (UIViewController *)controller fullScreen: (BOOL)fullScreen animated: (BOOL)animated;

- (void)dismiss: (UIViewController *)controller animated: (BOOL)animated;

- (void)pushViewController: (UIViewController *)controller animated: (BOOL)animated;

@end

NS_ASSUME_NONNULL_END
