//
//  BDIMDebugNetworkRequest.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/17.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugNetworkRequest.h"

@implementation BDIMDebugNetworkRequest

+ (instancetype)requestWithDic:(NSDictionary *)dic{
    BDIMDebugNetworkRequest *request = [BDIMDebugNetworkRequest new];
    request.host = [dic objectForKey:@"host"]?:@"unknown";
    request.error = [dic objectForKey:@"error"];
    request.path = [dic objectForKey:@"url"]?:@"unknown";
    request.method = [dic objectForKey:@"method"];
    request.wsMethod = [dic objectForKey:@"wsMethod"];
    request.cmd = [dic objectForKey:@"cmd"];
    request.logid = [dic objectForKey:@"logid"];
    request.statusCode = [dic objectForKey:@"statusCode"];
    request.responseObject = [dic objectForKey:@"responseObject"];
    request.requestObject = [dic objectForKey:@"requestObject"];
    request.date = [NSDate date];
    return request;
}

@end
