//
//  VEIMDemoAccountProtocol.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/6/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VEIMDemoAccountProtocol <NSObject>
- (void)showLoginVC;
- (void)checkUserExist:(long long)uid completion:(void (^)(BOOL exist, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
