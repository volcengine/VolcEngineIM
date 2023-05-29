//
//  BDIMDebugMenuItem.h
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIMDebugMenuIconModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugMenuItem : UIButton

@property (nonatomic, strong) BDIMDebugMenuIconModel *model;

+ (instancetype)itemWithModel: (BDIMDebugMenuIconModel *)model;

@end

NS_ASSUME_NONNULL_END
