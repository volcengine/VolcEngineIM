//
//  BDIMDebugBaseModel.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/13.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugBaseModel.h"

@implementation BDIMDebugBaseModel
+ (instancetype)modelWithTitle:(NSString *)title description:(NSString *)description enable: (BOOL)enable click:(void (^)(void))click{
    BDIMDebugBaseModel *item = [[[self class] alloc] init];
    item.title = title;
    item.desc = description;
    item.click = click;
    item.enable = enable;
    return item;
}
@end
