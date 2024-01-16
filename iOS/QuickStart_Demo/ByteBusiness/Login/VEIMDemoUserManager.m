//
//  VEIMDemoLoginManager.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//

#import "VEIMDemoUserManager.h"
#import "BDIMDebugNetworkManager.h"
#import "VEIMDemoRouter.h"
#import "VEIMDemoLoginViewController.h"
#import "VEIMDemoDefine.h"
#import <TTNetworkManager/TTNetworkManager.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>
//#import <imsdk-tob/BIMDebugManager.h>
#import "BIMUIClient.h"
#import "VEIMDemoIMManager.h"
#import <imsdk-tob/BIMClient+Friend.h>
#import "BIMToastView.h"

@interface VEIMDemoUserManager ()<BIMConnectListener, BIMFriendListener, BIMUIClientUserInfoDataSource>
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSMutableDictionary *userDict;
@end

@implementation VEIMDemoUserManager

+ (instancetype)sharedManager{
    static VEIMDemoUserManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[VEIMDemoUserManager alloc] init];
        }
    });
    return _sharedInstance;
}


//- (NSMutableArray<VEIMDemoUser *> *)testUsers{
//    if (!_testUsers) {
//        _testUsers = [NSMutableArray array];
//    }
//    return _testUsers;
//}

- (MBProgressHUD *)progressHUD{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] init];
    }
    return _progressHUD;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDict = [NSMutableDictionary dictionary];
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] valueForKey:kVEIMDemoUserUserdefaultKey];
        NSError *error;
        VEIMDemoUser *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[VEIMDemoUser class] fromData:userData error:&error];
        if (user && !error) {
            long long demoUID = kVEIMDemoUserID.longLongValue;
            if (demoUID <= 0) {
                self.currentUser = user;
            } else if (demoUID == user.userID) { // 兼容开源
                self.currentUser = user;
            }
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:BDIMDebugNetworkChangeNotification object:nil];
        
    }
    return self;
}

- (void)initSDK
{
    BIMSDKConfig *config = [[BIMSDKConfig alloc] init];
//    config.enableAPM = ![BDIMDebugNetworkManager sharedManager].disableApm;
//    config.enableAppLog = ![BDIMDebugNetworkManager sharedManager].disableApplog;
    [config setLogListener:^(BIMLogLevel logLevel, NSString * _Nonnull logContent) {
            // 日志 输出
        NSLog(@"TIM--%@", logContent);
    }];
    // env 国内：BIM_ENV_DEFAULT_ZH 海外：BIM_ENV_I18N
    [[BIMUIClient sharedInstance] initSDK:[kVEIMDemoAppID integerValue] config:config env:BIM_ENV_DEFAULT_ZH];
    
    [[BIMUIClient sharedInstance] setUserProvider:^BIMUser * _Nullable(long long userID) {
        if (userID == 0) {
            return nil;
        }
        BIMUserFullInfo *fullInfo = self.userDict[@(userID)];
        if (!fullInfo) {
            return nil;
        }
        BIMUser *user = [[BIMUser alloc] init];
        user.nickName = fullInfo.nickName.length ? fullInfo.nickName : [self nicknameForTestUser:userID];
        user.placeholderImage = [UIImage imageNamed:[self portraitForTestUser:userID]];
        user.userID = userID;
        user.alias = fullInfo.alias;
        user.portraitUrl = fullInfo.portraitUrl;
        return user;
    }];
    
    [BIMUIClient sharedInstance].userInfoDataSource = self;
    
    [[BIMClient sharedInstance] addConnectListener:self];
    [[BIMClient sharedInstance] addFriendListener:self];
    
    [[BIMClient sharedInstance] getDid:^(NSString * _Nullable did) {
        NSLog(@"TIM--did:%@", did);
    }];
}

- (BOOL)isLogedIn{
    return self.currentUser.userToken.length != 0;
}

- (void)showLoginVCIfNeed{
    // 从未登录成功过或已经退出登录
    if (!self.currentUser) {
        [self presentLoginVC];
        return;
    }
    
    // sdk是否登录
    if ([[BIMClient sharedInstance] getToken]) {
        return;
    }
    
    [self loginWithUser:self.currentUser completion:^(NSError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"登录失败：%@", error.localizedDescription]];
            [self logout];
        }
    }];
}

- (void)presentLoginVC
{
    [[VEIMDemoIMManager sharedManager].accountProvider showLoginVC];
}

- (void)logout {
    [self logoutWithCompletion:nil];
}

- (void)logoutWithCompletion:(BIMCompletion)completion
{
    [self.progressHUD showAnimated:YES];
    @weakify(self);
    [[BIMUIClient sharedInstance] logoutWithCompletion:^(BIMError * _Nullable error) {
        @strongify(self);
        [self.progressHUD hideAnimated:YES];
        if (!error) {
            self.currentUser = nil;
            [self.userDict removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kVEIMDemoUserUserdefaultKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self showLoginVCIfNeed];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kVEIMDemoUserDidLogoutNotification object:nil];
        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    }];
}

- (void)loginWithUser:(VEIMDemoUser *)user completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (user.userID <= 0) {
        if (completion) {
            completion([NSError errorWithDomain:kVEIMDemoErrorDomain code:VEIMDemoErrorTypeParamsError userInfo:@{NSLocalizedDescriptionKey : @"UserID cannot be nil"}]);
        }
        return;
    }
    
    [self.progressHUD showAnimated:YES];
    
    if (kVEIMDemoToken.length) {
        self.currentUser = user;
        self.currentUser.userToken = kVEIMDemoToken;
        [self saveCurrentUser:user];
        @weakify(self);
        [[BIMUIClient sharedInstance] login:@(self.currentUser.userID).stringValue token:self.currentUser.userToken completion:^(BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                if (completion) {
                    completion(error);
                }
                return;
            }
            [self getUserFullInfo:user.userID syncServer:NO completion:^(BIMUserFullInfo * _Nullable info, BIMError * _Nullable error) {
                self.currentUserFullInfo = info;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressHUD hideAnimated:YES];
                    if (error) {
                        [self logout];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kVEIMDemoUserDidLoginNotification object:nil];
                    }
                    if (completion){
                        completion(error);
                    }
                });
            }];
        }];
        
    } else {
        if (user.userToken.length) {
            [self __loginIMSDKWithUserID:user.userID token:user.userToken completion:completion];
            return;
        }
        NSString *tokenUrl = [[BDIMDebugNetworkManager sharedManager] tokenUrl];
        NSString *URL = [NSString stringWithFormat:@"%@/get_token?appID=%@&userID=%lld",tokenUrl, kVEIMDemoAppID, user.userID];
        @weakify(self);
        NSDate *date1 = [NSDate date];
        [TTNetworkManager.shareInstance requestForJSONWithResponse:URL params:nil method:@"GET" needCommonParams:YES callback:^(NSError *error, NSDictionary *obj, TTHttpResponse *response) {
            NSString *token = @"";
            if (error == nil && [obj isKindOfClass:[NSDictionary class]]) {
                token = [obj objectForKey:@"Token"];
            }
            
            if (token.length && user) {
                self.currentUser = user;
                self.currentUser.userToken = token;
                [self saveCurrentUser:user];
                [self __loginIMSDKWithUserID:user.userID token:token completion:completion];
            } else {
                [self.progressHUD hideAnimated:YES];
                if (completion) {
                    completion([NSError errorWithDomain:kVEIMDemoErrorDomain code:VEIMDemoErrorTypeFormatError userInfo:@{NSLocalizedDescriptionKey : @"Response params error"}]);
                }
            }
        }];
    }
}

- (void)__loginIMSDKWithUserID:(long long )userID token:(NSString *)token completion:(void (^ _Nullable)(NSError * _Nullable))completion
{
    @weakify(self);
    [[BIMUIClient sharedInstance] login:@(userID).stringValue token:token completion:^(BIMError * _Nullable error) {
        @strongify(self);
        [self getUserFullInfo:userID syncServer:NO completion:^(BIMUserFullInfo * _Nullable info, BIMError * _Nullable error) {
            self.currentUserFullInfo = info;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressHUD hideAnimated:YES];
                if (error) {
                    [self logout];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kVEIMDemoUserDidLoginNotification object:nil];
                }
                if (completion){
                    completion(error);
                }
            });
        }];
    }];
}

- (void)saveCurrentUser: (VEIMDemoUser *)user{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:NO error:nil];
    if (userData) {
        [[NSUserDefaults standardUserDefaults] setValue:userData forKey:kVEIMDemoUserUserdefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)portraitForTestUser:(long long)userID{
    return @"icon_recommend_user_default";
}

- (NSString *)nicknameForTestUser:(long long)userID{
    return [NSString stringWithFormat:@"用户%lld",userID];
}

- (NSString *)displayNameForUserID:(long long)userID{
    return [NSString stringWithFormat:@"用户%lld",userID];
}

- (void)setNickName:(NSString *)nickName forUID:(long long)userID
{
    if (!nickName) {
        return;
    }
    VEIMDemoUser *user = [self.userDict objectForKey:@(userID)];
    if (user) {
        user.name = nickName;
    } else {
        user = [[VEIMDemoUser alloc] init];
        user.userID = userID;
        user.name = nickName;
        [self.userDict setObject:user forKey:@(userID)];
    }
}

- (void)getUserFullInfo:(long long)uid syncServer:(BOOL)syncServer completion:(BIMUserFullInfoCompletion)completion
{
    [self getUserFullInfoList:@[@(uid)] syncServer:syncServer completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {
        if (completion) {
            completion(infos.firstObject, error);
        }
    }];
}

- (void)getUserFullInfoList:(NSArray<NSNumber *> *)uidList syncServer:(BOOL)syncServer completion:(BIMMUserFullInfoListCompletion)completion
{
    [[BIMClient sharedInstance] getUserFullInfoList:uidList syncServer:syncServer completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {
        for (BIMUserFullInfo *info in infos) {
            [self.userDict setObject:info forKey:@(info.uid)];
            [[BIMUIClient sharedInstance] reloadUserInfoWithUserId:info.uid];
        }
        if (completion) {
            completion(infos, error);
        }
    }];
}

- (BIMUserFullInfo *)fullInfoWithUserID:(long long)userID
{
    BIMUserFullInfo *fullInfo = self.userDict[@(userID)];
    return fullInfo;
}

#pragma mark - notification

- (void)didReceiveNoti:(NSNotification *)noti
{
    if ([noti.name isEqualToString:BDIMDebugNetworkChangeNotification]) {
        [[BTDResponder topViewController] dismissViewControllerAnimated:NO completion:^{
            @weakify(self);
            [self logoutWithCompletion:^(BIMError * _Nullable error) {
                @strongify(self);
                [[BIMUIClient sharedInstance] unInitSDK];
                [self initSDK];
//                [[BIMDebugManager sharedInstance] removeAllData];
            }];
        }];
    }
}

#pragma mark - BIMConnectListener

- (void)onConnectStatusChanged:(BIMConnectStauts)status
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LongConnectStatusChanged" object:nil];
}

- (void)onTokenInvalid {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"账号已过期，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }];
    [alertVC addAction:sure];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - BIMFriendListener

- (void)onUserProfileUpdate:(BIMUserFullInfo *)info
{
    [self p_updateInfo:info];
}

- (void)onFriendUpdate:(BIMUserFullInfo *)info
{
    [self p_updateInfo:info];
}

- (void)onBlackListUpdate:(BIMUserFullInfo *)info
{
    [self p_updateInfo:info];
}

- (void)onFriendDelete:(long long)uid
{
    [self.userDict removeObjectForKey:@(uid)];
}

- (void)p_updateInfo:(BIMUserFullInfo *)info
{
    if (info.uid == self.currentUser.userID) {
        self.currentUserFullInfo = info;
    }
    
    if (info) {
        [self.userDict setObject:info forKey:@(info.uid)];
    }
}

#pragma mark - BIMUIClientDelegate

- (void)getUserInfoWithUserId:(long long)userID completion:(void (^)(BIMUser *))completion
{
    [self getUserFullInfo:userID syncServer:NO completion:^(BIMUserFullInfo * _Nullable info, BIMError * _Nullable error) {
        BIMUser *user = [self userWithFullInfo:info];
        if (completion) {
            completion(user);
        }
    }];
}

- (void)getUserFullInfoList:(NSArray<NSNumber *> *)uidList completion:(void (^)(NSArray<BIMUser *> *userInfos))completion
{
    [self getUserFullInfoList:uidList syncServer:NO completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {
        NSArray *users = [self usersWithFullInfos:infos];
        if (completion) {
            completion(users);
        }
    }];
}

- (BIMUser *)userWithFullInfo:(BIMUserFullInfo *)fullInfo
{
    if (!fullInfo) {
        return nil;
    }
    long long userID = fullInfo.uid;
    BIMUser *user = [[BIMUser alloc] init];
    user.nickName = fullInfo.nickName.length ? fullInfo.nickName : [self nicknameForTestUser:userID];
    user.placeholderImage = [UIImage imageNamed:[self portraitForTestUser:userID]];
    user.userID = userID;
    user.alias = fullInfo.alias;
    user.portraitUrl = fullInfo.portraitUrl;
    return user;
}

- (NSArray<BIMUser *> *)usersWithFullInfos:(NSArray<BIMUserFullInfo *> *)fullInfos
{
    if (!fullInfos.count) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (BIMUserFullInfo *fullInfo in fullInfos) {
        BIMUser *user = [self userWithFullInfo:fullInfo];
        [array addObject:user];
    }
    return [array copy];
}

@end
