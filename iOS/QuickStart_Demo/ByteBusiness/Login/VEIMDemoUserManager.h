//
//  VEIMDemoLoginManager.h
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//

#import <Foundation/Foundation.h>
#import "VEIMDemoUser.h"

NS_ASSUME_NONNULL_BEGIN



@interface VEIMDemoUserManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) VEIMDemoUser *currentUser;
//@property (nonatomic, strong) NSMutableArray<VEIMDemoUser *> *testUsers;

- (void)showLoginVCIfNeed;

- (void)loginWithUser:(VEIMDemoUser *)user completion:(void (^ _Nullable)(NSError * _Nullable))completion;

- (NSMutableArray <VEIMDemoUser *> *)createTestUsers: (BOOL)needSelection;

- (void)logout;

- (NSString *)portraitForTestUser: (long long)userID;
- (NSString *)nicknameForTestUser: (long long)userID;

- (void)setNickName:(NSString *)nickName forUID:(long long)userID;

@end

NS_ASSUME_NONNULL_END
