//
//  BIMBaseViewController.h
//
//
//  Created by Weibai on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isNeedLeftBack;
@property (nonatomic, assign) BOOL isNeedCloseBtn;

- (void)registerNotification;

- (void)setupUIElements;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
