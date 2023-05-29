//
//  VEIMDemoLiveGroupListDataSource.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoLiveGroupListDataSource : NSObject

/// 分页大小，默认100
@property (nonatomic, assign) int pageSize;

/// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasMore;

@end

NS_ASSUME_NONNULL_END
