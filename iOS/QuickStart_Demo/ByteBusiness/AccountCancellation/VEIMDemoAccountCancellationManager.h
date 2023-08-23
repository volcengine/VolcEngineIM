//
//  VEIMDemoAccountCancellationManager.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/6/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoAccountCancellationManager : NSObject
+ (instancetype)sharedInstance;
- (void)cancelAccountWithUid:(NSString *)uid token:(NSString *)token completion:(void(^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
