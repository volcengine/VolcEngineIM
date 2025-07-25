//
//  VEIMDemoIMManager.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/2.
//  这个类主要负责和IM相关的初始化任务以及交互

#import <Foundation/Foundation.h>
#import "VEIMDemoAccountProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoIMManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak, readonly) id<VEIMDemoAccountProtocol> accountProvider;

- (void)updateAccountProvider;
@end

NS_ASSUME_NONNULL_END
