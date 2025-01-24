//
//  VEIMDemoIMManager+Message.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/25.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoIMManager.h"
#import <imsdk-tob/BIMSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoIMManager (Message)

- (void)sendSystemMessage: (NSString *)msg convId: (NSString *)convId completion:(void (^ _Nullable)(NSError * _Nullable))completion;

- (void)sendLocalSystemMessage: (NSString *)msg convId: (NSString *)convId completion:(void (^ _Nullable)(NSError * _Nullable))completion;

- (NSString *)contentWithMessage:(BIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
