//
//  VEIMDemoSearchMessageListResultModel.h
//  ByteBusiness
//
//  Created by ByteDance on 2024/6/3.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMSearchMsgInfo;

@interface VEIMDemoSearchMessageListResultModel : NSObject

@property (nonatomic, strong) BIMSearchMsgInfo *anchorMessage;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSArray<BIMSearchMsgInfo *> *searchInfoList;

- (instancetype)initWithAnchorMessage:(BIMSearchMsgInfo * _Nullable)anchorMessage hasMore:(BOOL)hasMore searchInfoList:(NSArray<BIMSearchMsgInfo *> * _Nullable)searchInfoList;

@end

NS_ASSUME_NONNULL_END
