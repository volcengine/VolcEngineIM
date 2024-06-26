//
//  VEIMDemoNetworkManager.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2024/6/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoNetworkManager.h"
#if __has_include(<TTNetworkManager/BDNetworkManager.h>)
#import <TTNetworkManager/BDNetworkManager.h>
#else
#import <TTNetworkManager/TTNetworkManager.h>
#endif

@implementation VEIMDemoNetworkManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (void)requestForJSONWithResponse:(NSString *)URL params:(id)params method:(NSString *)method callback:(VEIMNetworkJSONFinishBlock)callback
{
    [self requestForJSONWithResponse:URL params:params method:method headerField:nil httpBody:nil callback:callback];
}


- (void)requestForJSONWithResponse:(NSString *)URL params:(id)params method:(NSString *)method headerField:(NSDictionary *)headerField httpBody:(NSData *)httpBody callback:(nonnull VEIMNetworkJSONFinishBlock)callback
{
#if __has_include(<TTNetworkManager/BDNetworkManager.h>)
    TTHttpTask *task = [[BDNetworkManager shareInstance] requestForJSONWithResponse:URL params:params method:method headerField:headerField requestSerializer:nil responseSerializer:nil autoResume:YES isCustomizedCookie:NO callback:^(NSError * _Nullable error, id  _Nullable obj, TTHttpResponse * _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(error, obj);
            }
        });
    }];
    
    if (httpBody) {
        task.request.HTTPBody = httpBody;
    }
#else
    TTHttpTask *task = [[TTNetworkManager shareInstance] requestForJSONWithResponse:URL params:params method:method needCommonParams:NO callback:^(NSError * _Nullable error, id  _Nullable obj, TTHttpResponse * _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(error, obj);
            }
        });
    }];
    
    if (httpBody) {
        task.request.HTTPBody = httpBody;
    }
#endif
}

@end
