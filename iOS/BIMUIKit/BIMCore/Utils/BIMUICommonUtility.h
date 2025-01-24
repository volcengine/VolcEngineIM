//
//  BIMUICommonUtility.h
//  im-uikit-tob
//
//  Created by hexi on 2025/1/7.
//

#import <Foundation/Foundation.h>

@class BIMUser, BIMUserFullInfo, BIMConversation;
@protocol BIMMember;

@interface BIMUICommonUtility : NSObject

/**
 * 获取用户展示名称
 */
+ (NSString *)getShowNameWithUser:(BIMUser *)user;

/**
 * 获取用户展示名称
 */
+ (NSString *)getShowNameWithUserFullInfo:(BIMUserFullInfo *)userFullInfo;

/**
 * 获取群成员展示名称
 */
+ (NSString *)getShowNameInGroupWithUser:(BIMUser *)user member:(id<BIMMember>)member;

/**
 * 获取会话展示名称
 */
+ (NSString *)getShowNameWithConversation:(BIMConversation *)conversation;

/**
 * 获取发系统消息的用户展示名称
 */
+ (NSString *)getSystemMessageUserNameWithUser:(BIMUser *)user;

/**
 * 获取发系统消息的用户展示名称
 */
+ (NSString *)getSystemMessageUserNameWithUser:(BIMUser *)user member:(id<BIMMember>)member;

@end
