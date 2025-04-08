//
//  SSDebugViewController.h
//  TTDebugCore
//
//  Created by 李琢鹏 on 2020/4/28.
//

#import "SSDebugViewControllerBase.h"

NS_ASSUME_NONNULL_BEGIN


@interface SSDebugViewController : SSDebugViewControllerBase

@property (nonatomic, assign, class) BOOL shakeEntranceEnabled;

+ (void)showDebugVC;

@end

NS_ASSUME_NONNULL_END
