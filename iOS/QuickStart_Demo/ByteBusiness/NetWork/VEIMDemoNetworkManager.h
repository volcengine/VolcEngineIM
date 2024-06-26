//
//  VEIMDemoNetworkManager.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2024/6/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VEIMNetworkJSONFinishBlock)(NSError *error, id obj);

@interface VEIMDemoNetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                                  callback:(VEIMNetworkJSONFinishBlock)callback;

- (void)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                               headerField:(NSDictionary *)headerField
                                    httpBody:(NSData *)httpBody
                                  callback:(VEIMNetworkJSONFinishBlock)callback;
@end

