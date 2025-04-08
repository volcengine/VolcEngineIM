//
//  BDIMDebugNetworkManager.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/9.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugNetworkManager.h"

static NSString *kApplogDisableKey = @"kApplogDisableKey";
static NSString *kApmDisableKey = @"kApmDisableKey";

@interface BDIMDebugNetworkManager ()
@property (nonatomic, strong) NSDictionary *config;

@end

@implementation BDIMDebugNetworkManager
+ (instancetype)sharedManager {
    static BDIMDebugNetworkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BDIMDebugNetworkManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadNetworkConfig];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:BDIMDebugNetworkResponseNotification object:nil];
    }
    return self;
}

- (NSDictionary *)pathToDescDic{
    return @{
        @"v1/stranger/get_conversation_list":@"陌生人盒子数据",
        @"v1/message/get_by_user":@"老混链",
        @"v1/message/get_recent_message":@"新混链",
        @"v1/message/get_cmd_message/":@"新混链命令消息",
        @"v1/conversation/get_audit_unread":@"群申请盒子数据",
        @"v1/conversation/get_checkinfo":@"会话完整性校验",
        @"v1/client/report_metrics":@"SDK监控",
        @"v1/config/get":@"拉取配置",
        @"v1/client/unread_count":@"上报未读数",
        @"v1/conversation/batch_get_conversation_participants_readindex":@"获取成员已读状态",
        @"v2/conversation/get_info":@"更新会话",
        @"v2/conversation/get_info_list":@"更新会话",
        @"v3/conversation/mark_read":@"标记已读",
        @"v1/message/get_by_conversation":@"老单链消息",
        @"v2/message/get_by_user_init":@"老init接口",
        @"v1/message/get_message_by_index_v2_range/":@"新单链消息",
        @"v1/client/ack":@"消息ACK",
    };
}

- (NSString *)pathToDesc:(NSString *)path{
    return [self.pathToDescDic objectForKey:path];
}

- (NSMutableArray *)requests{
    if (!_requests) {
        _requests = [NSMutableArray array];
    }
    return _requests;
}


- (void)didReceiveNoti: (NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([noti.name isEqualToString:BDIMDebugNetworkResponseNotification]) {
            BDIMDebugNetworkRequest *request = [BDIMDebugNetworkRequest requestWithDic:noti.userInfo];
            [self.requests insertObject:request atIndex:0];
            if (self.monitor && !self.monitor.hidden) {
                [self.monitor.tableview reloadData];
            }
        }
    });
}

- (void)clearMonitorRequests{
    [self.requests removeAllObjects];
    [self.monitor.tableview reloadData];
}


- (NSString *)tokenUrl{
    return [[self currentConfig] objectForKey:@"tokenUrl"];
}
- (NSString *)apiUrl{
    return [[self currentConfig] objectForKey:@"apiUrl"];
}
- (NSString *)frontierUrl{
    return [[self currentConfig] objectForKey:@"frontierUrl"];
}
- (NSString *)uploadRegion{
    return [[self currentConfig] objectForKey:@"uploadRegion"];
}
- (NSString *)videoDomain{
    return [[self currentConfig] objectForKey:@"videoDomain"];
}
- (NSString *)imageDomain{
    return [[self currentConfig] objectForKey:@"imageDomain"];
}

- (NSString *)networkDescription{
    return [NSString stringWithFormat:@"Current Network Env: %@ (%@)",[self currentCountryDesc], [self currentEnvDesc]];
}

- (NSString *)envDesc:(BDIMDebugNetworkEnvType)env{
    switch (env) {
        case BDIMDebugNetworkEnvTypePPE:{
            return @"PPE";
        }
        case BDIMDebugNetworkEnvTypeBOE:{
            return @"BOE";
        }
    }
    return @"PPE";
}

- (NSString *)currentEnvDesc{
    return [self envDesc:self.env];
}

- (NSString *)countryDesc:(BDIMDebugNetworkCountryType)country{
    switch (country) {
        case BDIMDebugNetworkCountryTypeChina:{
            return @"China";
        }
        case BDIMDebugNetworkCountryTypeUSGCP:{
            return @"US-East-GCP";
        }
        case BDIMDebugNetworkCountryTypeUSEast:{
            return @"US-East";
        }
        case BDIMDebugNetworkCountryTypeSingapore:{
            return @"Singapore";
        }
        case BDIMDebugNetworkCountryTypeTob:{
            return @"Tob";
        }
        case BDIMDebugNetworkCountryTypeOverseas: {
            return @"Overseas";
        }
    }
    return @"China";
}

- (NSString *)currentNetLane{
    return self.netLane;
}

- (NSString *)currentCountryDesc{
    return [self countryDesc:self.country];
}

- (NSDictionary *)currentConfig{
    NSDictionary *fullConfig = [self.config objectForKey:[self currentCountryDesc]];
    return [fullConfig objectForKey:[self currentEnvDesc]];
}

- (void)setEnv:(BDIMDebugNetworkEnvType)env{
    if (_env == env) {
        return;
    }
    _env = env;
    [[NSUserDefaults standardUserDefaults] setObject:@(env) forKey:kBDIMDebugNetworkEnv];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:BDIMDebugNetworkChangeNotification object:nil userInfo:@{kBDIMDebugNetworkCountryIsOverseasSwitch:@(NO)}];
}

//- (void)setCountry:(BDIMDebugNetworkCountryType)country{
//    if (_country == country) {
//        return;
//    }
//    BOOL isOverseaSwitch = NO;
//    if ((_country == BDIMDebugNetworkCountryTypeChina && country != BDIMDebugNetworkCountryTypeChina) || (_country != BDIMDebugNetworkCountryTypeChina && _country == BDIMDebugNetworkCountryTypeChina)) {
//        isOverseaSwitch = YES;
//    }
//    _country = country;
//    [[NSUserDefaults standardUserDefaults] setObject:@(country) forKey:kBDIMDebugNetworkCountry];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSNotificationCenter defaultCenter] postNotificationName:BDIMDebugNetworkChangeNotification object:nil userInfo:@{kBDIMDebugNetworkCountryIsOverseasSwitch:@(isOverseaSwitch)}];
//}

- (void)setNetLane:(NSString *)netLane
{
    if ([_netLane isEqualToString:netLane]) {
        return;
    }
    _netLane = netLane;
    [[NSUserDefaults standardUserDefaults] setObject:netLane forKey:kBDIMDebugNetworkLane];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:BDIMDebugNetworkChangeNotification object:nil userInfo:@{kBDIMDebugNetworkCountryIsOverseasSwitch:@(NO)}];
}

#warning 调试代码，后续删除
- (void)setDisableApplog:(BOOL)disableApplog
{
    _disableApplog = disableApplog;
    [[NSUserDefaults standardUserDefaults] setBool:disableApplog forKey:kApplogDisableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDisableApm:(BOOL)disableApm
{
    _disableApm = disableApm;
    [[NSUserDefaults standardUserDefaults] setBool:disableApm forKey:kApmDisableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadNetworkConfig{
    _config = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BDIMNetworkConfig" ofType:@"plist"]];
//    _country = [[[NSUserDefaults standardUserDefaults] objectForKey:kBDIMDebugNetworkCountry] intValue];
    if (NSClassFromString(@"TIMInnerConfigCN")) {
        _country = BDIMDebugNetworkCountryTypeTob;
    } else {
        _country = BDIMDebugNetworkCountryTypeOverseas;
    }
    
    _env = [[[NSUserDefaults standardUserDefaults] objectForKey:kBDIMDebugNetworkEnv] intValue];
    _netLane = [[NSUserDefaults standardUserDefaults] objectForKey:kBDIMDebugNetworkLane];
    
    _disableApplog = [[NSUserDefaults standardUserDefaults] boolForKey:kApplogDisableKey];
    _disableApm = [[NSUserDefaults standardUserDefaults] boolForKey:kApmDisableKey];
}


- (void)showMonitor: (BOOL)showMonitor{
    if (showMonitor) {
        if (!self.monitor) {
            CGRect screenR = [UIScreen mainScreen].bounds;
            self.monitor = [[BDIMDebugNetworkRequestMonitor alloc] initWithFrame:CGRectMake(0, screenR.size.height * 0.55, screenR.size.width, screenR.size.height * 0.45 - 90)];
            [[UIApplication sharedApplication].delegate.window addSubview:self.monitor];
        }
        [self.monitor.tableview reloadData];
    }
    self.monitor.hidden = !showMonitor;
}
@end

