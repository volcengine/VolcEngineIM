//
//  VEIMDemoFriendApplyListDataSource.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/28.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMFriendApplyInfo, VEIMDemoFriendApplyListDataSource;

@protocol VEIMDemoFriendApplyListDataSourceDelegate <NSObject>

- (void)friendApplyDataSourceDidReloadFriendApplyList:(VEIMDemoFriendApplyListDataSource *)dataSource;

@end

@interface VEIMDemoFriendApplyListDataSource : NSObject

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign, readonly) BOOL hasMore;

@property (nonatomic, copy, readonly) NSArray<BIMFriendApplyInfo *> *friendApplyList;

@property (nonatomic, weak) id<VEIMDemoFriendApplyListDataSourceDelegate> delegate;

- (void)loadFriendApplyWithCompletion:(void (^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
