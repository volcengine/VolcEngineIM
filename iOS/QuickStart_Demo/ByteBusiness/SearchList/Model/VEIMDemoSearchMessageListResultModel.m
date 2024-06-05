//
//  VEIMDemoSearchMessageListResultModel.m
//  ByteBusiness
//
//  Created by ByteDance on 2024/6/3.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <imsdk-tob/BIMClient+FTS.h>
#import "VEIMDemoSearchMessageListResultModel.h"


@implementation VEIMDemoSearchMessageListResultModel

- (instancetype)initWithAnchorMessage:(BIMSearchMsgInfo *)anchorMessage hasMore:(BOOL)hasMore searchInfoList:(NSArray<BIMSearchMsgInfo *> *)searchInfoList
{
    self = [super init];
    if (self) {
        self.anchorMessage = anchorMessage;
        self.hasMore = hasMore;
        self.searchInfoList = searchInfoList.copy;
    }
    return self;
}

@end
