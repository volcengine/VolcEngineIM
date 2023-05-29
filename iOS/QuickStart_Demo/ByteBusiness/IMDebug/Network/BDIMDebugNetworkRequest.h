//
//  BDIMDebugNetworkRequest.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/17.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugNetworkRequest : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *wsMethod;
@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *logid;
@property (nonatomic, strong) NSNumber *cmd;
@property (nonatomic, strong) NSObject *requestObject;
@property (nonatomic, strong) NSObject *responseObject;
@property (nonatomic, strong) NSDate *date;

+ (instancetype)requestWithDic: (NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
