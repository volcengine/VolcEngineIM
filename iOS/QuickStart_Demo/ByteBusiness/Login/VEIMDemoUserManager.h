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

@property (nonatomic, strong) BIMUserFullInfo *currentUserFullInfo;


- (void)initSDK;


- (void)showLoginVCIfNeed;

- (void)loginWithUser:(VEIMDemoUser *)user isUseStringUid:(BOOL)isUseStringUid completion:(void (^ _Nullable)(NSError * _Nullable))completion;

- (void)logout;

- (NSString *)portraitForTestUser: (long long)userID;
- (NSString *)nicknameForTestUser: (long long)userID;

- (NSString *)portraitForRobot: (long long)robotUserID;
- (NSString *)nickNameForUserIDString:(NSString *)userIDString;

- (BIMUserFullInfo *)fullInfoWithUserID:(long long)userID;

- (void)getUserFullInfoList:(NSArray<NSNumber *> *)uidList syncServer:(BOOL)syncServer completion:(BIMMUserFullInfoListCompletion)completion;

- (void)getAllRobotFullInfoWithSyncServer:(BOOL)syncServer completion:(BIMMUserFullInfoListCompletion)completion;

- (BOOL)isStringUidLogin;

@end

NS_ASSUME_NONNULL_END
