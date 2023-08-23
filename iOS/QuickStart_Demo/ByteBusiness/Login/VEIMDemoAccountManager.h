//
//  VEIMDemoAccountManager.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/6/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VEIMDemoAccountProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoAccountManager : NSObject <VEIMDemoAccountProtocol>
+ (instancetype)sharedManager;
@property (nonatomic, copy) void(^agreeUserPirvacyAgreementCompletion)(void);
@end

NS_ASSUME_NONNULL_END
