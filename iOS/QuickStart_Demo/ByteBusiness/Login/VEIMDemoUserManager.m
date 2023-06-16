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

@interface VEIMDemoUserManager ()<BIMConnectListener>
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
            self.currentUser = user;
        }
        
        [self initSDK];
        
        [[BIMClient sharedInstance] addConnectListener:self];
        
        [self setupDefaultUser];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:BDIMDebugNetworkChangeNotification object:nil];
        
    }
    return self;
}

- (void)initSDK
{
    // debug
//    [BIMDebugManager sharedInstance].imServerBaseURL = [[BDIMDebugNetworkManager sharedManager] apiUrl];
    BIMSDKConfig *config = [[BIMSDKConfig alloc] init];
    [config setLogListener:^(BIMLogLevel logLevel, NSString * _Nonnull logContent) {
            // 日志 输出
        NSLog(@"TIM--%@", logContent);
    }];
    [[BIMUIClient sharedInstance] initSDK:[kVEIMDemoAppID integerValue]  config:config];
    
    [[BIMUIClient sharedInstance] setUserProvider:^BIMUser * _Nullable(long long userID) {
        BIMUser *user = [[BIMUser alloc] init];
        user.nickName = [self nicknameForTestUser:userID];
        user.headImg = [UIImage imageNamed:[self portraitForTestUser:userID]];
        user.userID = userID;
//        user.url = xxx;
        return user;
    }];
}

- (BOOL)isLogedIn{
    return self.currentUser.userToken.length != 0;
}

- (void)showLoginVCIfNeed{
    if (self.isLogedIn) {
        return;
    }
    if (!self.currentUser) {
        VEIMDemoLoginViewController *loginVC = [[VEIMDemoLoginViewController alloc] init];
        [[VEIMDemoRouter shared] presentViewController:loginVC fullScreen:YES animated:YES];
    }else{
        [self loginWithUser:self.currentUser completion:nil];
    }
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
        [[BIMUIClient sharedInstance] login:@(self.currentUser.userID).stringValue token:self.currentUser.userToken completion:^(BIMError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressHUD hideAnimated:YES];
                if (completion){
                    completion(error);
                }
            });
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVEIMDemoUserDidLoginNotification object:nil];
    } else {
        NSString *tokenUrl = [[BDIMDebugNetworkManager sharedManager] tokenUrl];
        NSString *URL = [NSString stringWithFormat:@"%@/get_token?appID=%@&userID=%lld",tokenUrl, kVEIMDemoAppID, user.userID];
        [TTNetworkManager.shareInstance requestForJSONWithResponse:URL params:nil method:@"GET" needCommonParams:YES callback:^(NSError *error, id obj, TTHttpResponse *response) {
            NSString *token = @"";
            if (error == nil && [obj isKindOfClass:[NSDictionary class]]) {
                token = [(NSDictionary *)obj objectForKey:@"Token"];
            }
            
            if (token.length && user) {
                self.currentUser = user;
                self.currentUser.userToken = token;
                [self saveCurrentUser:user];
                [[BIMUIClient sharedInstance] login:@(self.currentUser.userID).stringValue token:self.currentUser.userToken completion:^(BIMError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressHUD hideAnimated:YES];
                        if (completion){
                            completion(error);
                        }
                    });
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:kVEIMDemoUserDidLoginNotification object:nil];
            }else{
                [self.progressHUD hideAnimated:YES];
                if (completion) {
                    completion([NSError errorWithDomain:kVEIMDemoErrorDomain code:VEIMDemoErrorTypeFormatError userInfo:@{NSLocalizedDescriptionKey : @"Response params error"}]);
                }
            }
        }];
    }
}

- (NSMutableArray<VEIMDemoUser *> *)createTestUsers:(BOOL)needSelection{
    NSMutableArray *testUsers = [NSMutableArray array];
    for (int i = 1; i<11; i++) {
        long long userId = 10000+i;
        VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
        user.userID = userId;
        user.isNeedSelection = needSelection;
        user.name = [NSString stringWithFormat:@"测试用户%d",i];
        user.portrait = [NSString stringWithFormat:@"icon_recommond_user_%d",i];
        
        [testUsers addObject:user];
    }
    return testUsers;
}

- (void)saveCurrentUser: (VEIMDemoUser *)user{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:NO error:nil];
    if (userData) {
        [[NSUserDefaults standardUserDefaults] setValue:userData forKey:kVEIMDemoUserUserdefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)portraitForTestUser:(long long)userID{
    VEIMDemoUser *user = [self.userDict objectForKey:@(userID)];
    if (user.portrait) {
        return user.portrait;
    } else {
        return @"icon_recommond_user_1";
    }
}

- (NSString *)nicknameForTestUser:(long long)userID{
    VEIMDemoUser *user = [self.userDict objectForKey:@(userID)];
    if (user) {
        return user.name;
    } else {
        return [NSString stringWithFormat:@"测试用户%lld",userID];
    }
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

- (void)setupDefaultUser
{
    NSArray<VEIMDemoUser *> *users = [self createTestUsers:YES];
    for (VEIMDemoUser *user in users) {
        [self.userDict setObject:user forKey:@(user.userID)];
    }
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

- (void)onTokenInvalid {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"账号已过期，请重新登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }];
    [alertVC addAction:sure];
    
    [[BTDResponder topViewController] presentViewController:alertVC animated:YES completion:nil];
}

@end
