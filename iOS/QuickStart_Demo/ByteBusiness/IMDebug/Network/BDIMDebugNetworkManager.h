//
//  BDIMDebugNetworkManager.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/9.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDIMDebugNetworkRequest.h"
#import "BDIMDebugNetworkRequestMonitor.h"

NS_ASSUME_NONNULL_BEGIN

#define kBDIMDebugNetworkCountry @"BDIM-Debug-NetworkCountry"
#define kBDIMDebugNetworkEnv @"BDIM-Debug-NetworkEnv"
#define kBDIMDebugNetworkLane @"BDIM-Debug-NetworkLane"
#define kBDIMDebugNetworkCountryIsOverseasSwitch @"BDIM-Debug-NetworkCountryOverseas-Switch"
#define BDIMDebugNetworkChangeNotification @"BDIMDebugNetworkChangeNotification"
#define BDIMDebugNetworkRequestNotification @"BDIMDebugNetworkRequestNotification"
#define BDIMDebugNetworkResponseNotification @"BDIMDebugNetworkResponseNotification"

// qfmark 临时修改
typedef enum : NSUInteger {
    BDIMDebugNetworkEnvTypePPE,
    BDIMDebugNetworkEnvTypeBOE,
} BDIMDebugNetworkEnvType;

typedef enum : NSUInteger {
    BDIMDebugNetworkCountryTypeTob,
    BDIMDebugNetworkCountryTypeOverseas,
    BDIMDebugNetworkCountryTypeChina,
    BDIMDebugNetworkCountryTypeUSGCP,
    BDIMDebugNetworkCountryTypeUSEast,
    BDIMDebugNetworkCountryTypeSingapore,
    
} BDIMDebugNetworkCountryType;

@interface BDIMDebugNetworkManager : NSObject

@property (nonatomic, assign, readonly) BDIMDebugNetworkCountryType country;
@property (nonatomic, assign) BDIMDebugNetworkEnvType env;
@property (nonatomic, copy) NSString *netLane;
@property (nonatomic, assign) BOOL disableApplog;
@property (nonatomic, assign) BOOL disableApm;

@property (nonatomic, strong) BDIMDebugNetworkRequestMonitor *monitor;

@property (nonatomic, strong) NSMutableArray <BDIMDebugNetworkRequest *>*requests;

+ (instancetype)sharedManager;

- (NSString *)pathToDesc: (NSString *)path;

- (NSString *)countryDesc: (BDIMDebugNetworkCountryType)country;
- (NSString *)envDesc: (BDIMDebugNetworkEnvType)env;
- (NSString *)currentEnvDesc;
- (NSString *)currentCountryDesc;
- (NSString *)currentNetLane;
- (NSString *)networkDescription;

- (NSString *)tokenUrl;
- (NSString *)apiUrl;
- (NSString *)frontierUrl;
- (NSString *)uploadRegion;
- (NSString *)videoDomain;
- (NSString *)imageDomain;

- (void)showMonitor: (BOOL)showMonitor;

- (void)clearMonitorRequests;


@end

NS_ASSUME_NONNULL_END
