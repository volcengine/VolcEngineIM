//
//  BDIMDebugMenuItemModel.m
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugMenuIconModel.h"

@implementation BDIMDebugMenuIconModel

+ (instancetype)modelWithTitle:(NSString *)title icon:(NSString *)icon description:(NSString *)description enable: (BOOL)enable click:(void (^)(void))click{
    BDIMDebugMenuIconModel *item = [BDIMDebugMenuIconModel modelWithTitle:title description:description enable: enable click:click];
    item.icon = icon;
    return item;
}
@end
