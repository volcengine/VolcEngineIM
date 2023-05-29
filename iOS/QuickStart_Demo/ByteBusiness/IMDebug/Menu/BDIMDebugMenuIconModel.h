//
//  BDIMDebugMenuItem.h
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDIMDebugBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugMenuIconModel : BDIMDebugBaseModel

@property (nonatomic, strong) NSString *icon;

+ (instancetype)modelWithTitle:(NSString *)title icon:(NSString *)icon description:(NSString *)description enable: (BOOL)enable click:(void (^)(void))click;

@end

NS_ASSUME_NONNULL_END
