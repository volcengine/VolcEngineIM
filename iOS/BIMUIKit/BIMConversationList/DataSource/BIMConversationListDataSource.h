//
//ConversationListDataSource.h
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BIMConversation, BIMConversationListDataSource;

@protocol BIMConversationListDataSourceDelegate <NSObject>

// 后续可以再扩展下reason
- (void)conversationDataSourceDidReloadAllConversations:(BIMConversationListDataSource *_Nullable)dataSource;

- (void)conversationDataSource:(BIMConversationListDataSource *_Nullable)dataSource onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount;

@end


NS_ASSUME_NONNULL_BEGIN

@interface BIMConversationListDataSource : NSObject

@property (nonatomic, weak) id<BIMConversationListDataSourceDelegate> delegate;

/// 分页大小，默认100
@property (nonatomic, assign) int pageSize;

/// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasMore;

@property (nonatomic, assign, readonly) NSUInteger totalUnreadCount;

@property (nonatomic, strong, readonly) NSArray<BIMConversation *> *conversationList;

- (void)loadNexPageConversationsWithCompletion:(void (^)(NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
