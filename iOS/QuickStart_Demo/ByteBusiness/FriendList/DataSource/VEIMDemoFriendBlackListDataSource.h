//
//  VEIMDemoFriendBlackListDataSource.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/8/30.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VEIMDemoFriendBlackListDataSource, BIMUserFullInfo, BIMError;
@protocol VEIMDemoBlackListDataSourceDelegate <NSObject>

- (void)blackListDataSourceDidReloadBlackList:(VEIMDemoFriendBlackListDataSource *_Nullable)dataSource;

@end

@interface VEIMDemoFriendBlackListDataSource : NSObject

@property (nonatomic, weak) id<VEIMDemoBlackListDataSourceDelegate> delegate;

@property (nonatomic, copy, readonly)NSArray<BIMUserFullInfo *> *blackList;

- (void)loadBlackListWithCompletion:(void (^_Nullable)(BIMError *_Nullable e))completion;

@end

NS_ASSUME_NONNULL_END
