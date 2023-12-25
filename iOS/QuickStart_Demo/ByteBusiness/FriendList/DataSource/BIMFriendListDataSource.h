//
//  BIMFriendListDataSource.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMUserFullInfo, BIMFriendListDataSource;
@protocol BIMFriendListDataSourceDelegate <NSObject>

- (void)friendListDataSourceDidReloadFriendList:(BIMFriendListDataSource *_Nullable)dataSource;

- (void)friendListDataSource:(BIMFriendListDataSource *_Nullable)dataSource onApplyUnreadCountChanged:(NSInteger)unreadCount;

@end

@interface BIMFriendListDataSource : NSObject

@property (nonatomic, weak) id<BIMFriendListDataSourceDelegate> delegate;

@property (nonatomic, copy, readonly) NSArray<BIMUserFullInfo *> *friendList;

@property (nonatomic, assign, readonly) NSInteger unreadCount;

//+ (instancetype)sharedInstance;

- (void)loadFriendListWithCompletion:(void(^)(NSError *_Nullable))completion;

- (void)getFriendApplyUnreadCount;

@end

NS_ASSUME_NONNULL_END
