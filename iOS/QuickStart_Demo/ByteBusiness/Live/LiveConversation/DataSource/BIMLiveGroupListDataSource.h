//
//  BIMLiveGroupListDataSource.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, VEIMDemoLiveGroupListType);

@class BIMConversation, BIMLiveGroupListDataSource;
@protocol BIMLiveGroupListDataSourceDelegate <NSObject>

// 后续可以再扩展下reason
- (void)liveGroupDataSourceDidReloadAllLiveGroup:(BIMLiveGroupListDataSource *_Nullable)dataSource;

- (void)liveGroupDataSOurce:(BIMLiveGroupListDataSource *_Nullable)dataSource onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BIMLiveGroupListDataSource : NSObject

// 分页大小
@property(nonatomic, assign) int pageSize;
// hasMore，对外只读
@property(nonatomic, assign, readonly) BOOL hasMore;
// 直播群列表，对外只读
@property(nonatomic, copy, readonly) NSArray<BIMConversation *> *liveGroupList;

@property(nonatomic, weak) id<BIMLiveGroupListDataSourceDelegate> delegate;

@property(nonatomic, assign) VEIMDemoLiveGroupListType type;

- (instancetype)initWithType:(VEIMDemoLiveGroupListType)type;

- (void)loadNexPageLiveGroupWithCompletion:(void(^)(NSError *_Nullable))completion;

- (void)updateLiveGroupWithConv:(BIMConversation *)conv;

- (void)addLiveGroupToListWithConv:(BIMConversation *)conv;

- (void)removeLiveGroupFromListWith:(BIMConversation *)conv;

@end

NS_ASSUME_NONNULL_END
