//
//  VEIMDemoAccountProtocol.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/6/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VEIMDemoAccountType) {
    VEIMDemoAccountTypeInternal,
    VEIMDemoAccountTypeOpenSource,
    VEIMDemoAccountTypeAppstore,
};

@protocol VEIMDemoAccountProtocol <NSObject>
@property (nonatomic, copy) void(^agreeUserPirvacyAgreementCompletion)(void);

- (BOOL)isAgreeUserPirvacyAgreement;
- (void)agreeUserPirvacyAgreement;
- (void)showLoginVC;
- (void)checkUserExist:(long long)uid completion:(void (^)(BOOL exist, NSError *error))completion;
- (VEIMDemoAccountType)accountType;
@end

NS_ASSUME_NONNULL_END
