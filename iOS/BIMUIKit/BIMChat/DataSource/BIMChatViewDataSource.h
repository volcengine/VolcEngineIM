//
//  BIMChatViewDataSource.h
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/16.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BIMChatViewDataSource, BIMError;

@protocol BIMChatViewDataSourceDelegate <NSObject>
//
- (void)chatViewDataSourceDidReloadAllMessage:(BIMChatViewDataSource *_Nullable)dataSource scrollToBottom:(BOOL)scrollToBottom;

@end

@class BIMConversation, BIMMessage;
NS_ASSUME_NONNULL_BEGIN

@interface BIMChatViewDataSource : NSObject

- (instancetype)initWithConversation:(BIMConversation *)conversation;

- (instancetype)initWithConversation:(BIMConversation *)conversation joinMessageCursor:(long long)joinMessageCursor;


@property (nonatomic, weak) id<BIMChatViewDataSourceDelegate> delegate;

/// 分页大小，默认20
@property (nonatomic, assign) int pageSize;

/// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasMore;

/**
 数据源目前所包含消息个数
 @return 目前所包含消息个数
 */
- (NSUInteger)numberOfItems;

- (nullable BIMMessage *)itemAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfItem:(nonnull BIMMessage *)item;

- (void)loadOlderMessagesWithCompletionBlock:(void (^)(BIMError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
