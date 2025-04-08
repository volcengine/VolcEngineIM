//
//  BIMConversationListDataSourceProtocol.h
//  Pods
//
//  Created by hexi on 2023/11/19.
//

#import <Foundation/Foundation.h>

@class BIMError, BIMConversation;

// 数据源通用 filterBlock
typedef BOOL(^BIMConversationListDataSourceFilterBlock)(BIMConversation *conversation);

@protocol BIMConversationListDataSourceProtocol;

@protocol BIMConversationListDataSourceDelegate <NSObject>

// 后续可以再扩展下reason
- (void)conversationDataSourceDidReloadAllConversations:(id<BIMConversationListDataSourceProtocol> _Nullable)dataSource;

- (void)conversationDataSource:(id<BIMConversationListDataSourceProtocol> _Nullable)dataSource onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount;

@end

@protocol BIMConversationListDataSourceProtocol <NSObject>

@property (nonatomic, weak, nullable) id<BIMConversationListDataSourceDelegate> delegate;

/// 分页大小，默认100
@property (nonatomic, assign) int pageSize;

/// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasMore;

@property (nonatomic, assign, readonly) NSUInteger totalUnreadCount;

@property (nonatomic, strong, readonly, nullable) NSArray<BIMConversation *> *conversationList;

@property (nonatomic, copy, nullable) BIMConversationListDataSourceFilterBlock filterBlock;

- (void)loadNexPageConversationsWithCompletion:(void (^_Nullable)(BIMError *_Nullable error))completion;

@end
