//
//  VEIMDemoInputController.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface VEIMDemoInputController : BIMBaseViewController

- (instancetype)initWithTitle: (NSString *)title text: (NSString *)text maxWordCount: (NSInteger)max editable: (BOOL)editable handler: (void(^)(NSString *text))hander;

@end

NS_ASSUME_NONNULL_END
