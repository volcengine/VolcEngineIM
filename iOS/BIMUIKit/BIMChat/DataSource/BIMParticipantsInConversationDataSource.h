//
//  BIMParticipantsInConversationDataSource.h
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/22.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class BIMParticipantsInConversationDataSource;
@protocol BIMMember;

/**
 会话参与者数据源回调。所有回调会在主线程。
 */
@protocol BIMParticipantsInConversationDataSourceDelegate <NSObject>
/**
 数据源更改
 @param dataSource 更改的实例
 */
//- (void)participantsDataSourceDidUpdate:(BIMParticipantsInConversationDataSource *)dataSource;
@end


@interface BIMParticipantsInConversationDataSource : NSObject

/**
 数据源初始化
 @param conversationID 想要获取参与者的会话 ID
 @return 构建的数据源
 */
- (instancetype)initWithConversationID:(NSString *)conversationID;

/**
 所属会话
 */
@property (nonatomic, strong, readonly) NSString *conversationID;
/**
 所有参与者，可 KVO 观察
 */
@property (nonatomic, strong, readonly) NSArray<id<BIMMember>> *participants;
/**
 所有管理员，可 KVO 观察
*/
@property (nonatomic, strong, readonly) NSArray<id<BIMMember>> *admParticipants;

/**
 参与者数据源回调 Delegate
 */
@property (nonatomic, weak) id<BIMParticipantsInConversationDataSourceDelegate> delegate;

/**
 批量查询会话内的成员信息
 @param participants  查询成员的userID
 @param completion 结果回调， 如果失败，error 描述失败原因。回调会在主线程。participants 为查询的信息
*/
- (void)fetchParticipantsAlias:(NSSet<NSNumber *> *_Nullable)participants completion:(void (^_Nullable)(NSArray<id<BIMMember>> *participants, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
