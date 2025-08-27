//
//  VEIMDemoMineItem.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2025/6/24.
//  Copyright © 2025 loulan. All rights reserved.
//

#import "VEIMDemoMineItem.h"

@implementation VEIMDemoMineItem

+ (instancetype)itemWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
               accessoryType:(int)accessoryType
                   clickBlock:(void (^)(VEIMDemoMineItem *item))clickBlock
{
    return [[self alloc] initWithTitle:title
                              subTitle:subTitle
                        accessoryType:accessoryType
                            clickBlock:clickBlock];
}

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
               accessoryType:(int)accessoryType
                   clickBlock:(void (^)(VEIMDemoMineItem *item))clickBlock
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _subTitle = [subTitle copy];
        _accessoryType = accessoryType;
        _clickBlock = [clickBlock copy];
    }
    return self;
}

@end
