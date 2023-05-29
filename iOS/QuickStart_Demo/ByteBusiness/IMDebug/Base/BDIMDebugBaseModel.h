//
//  BDIMDebugBaseModel.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/13.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDIMDebugModelProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugBaseModel : NSObject<BDIMDebugModelProtocal>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) void(^click)(void);


+ (instancetype)modelWithTitle:(NSString *)title description:(NSString *)description enable: (BOOL)enable click:(void (^)(void))click;

@end

NS_ASSUME_NONNULL_END
