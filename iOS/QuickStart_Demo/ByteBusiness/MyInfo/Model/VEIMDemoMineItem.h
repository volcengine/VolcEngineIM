//
//  VEIMDemoMineItem.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2025/6/24.
//  Copyright © 2025 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEIMDemoMineItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) int accessoryType;
@property (nonatomic, copy) void (^clickBlock)(VEIMDemoMineItem *item);
@property (nonatomic, strong) Class cellClass;


+ (instancetype)itemWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
               accessoryType:(int)accessoryType
                   clickBlock:(void (^)(VEIMDemoMineItem *item))clickBlock;

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
               accessoryType:(int)accessoryType
                   clickBlock:(void (^)(VEIMDemoMineItem *item))clickBlock;

@end

