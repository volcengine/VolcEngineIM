//
//  BIMUICommonUtility.m
//  im-uikit-tob
//
//  Created by hexi on 2025/1/7.
//

#import "BIMUICommonUtility.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>

#import "BIMUser.h"
#import "BIMUIClient.h"
#import "NSString+IMUtils.h"

@implementation BIMUICommonUtility

/// 好友备注 > 用户资料 > 兜底 userID
+ (NSString *)getShowNameWithUser:(BIMUser *)user
{
    if (!user) {
        return @"";
    }
    
    NSString *showName = [NSString stringWithFormat:@"用户%lld", user.userID];
    if (!BTD_isEmptyString(user.alias)) {
        showName = user.alias;
    } else if (!BTD_isEmptyString(user.nickName)) {
        showName = user.nickName;
    }
    return showName;
}

/// 好友备注 > 用户昵称 > 兜底 userID
+ (NSString *)getShowNameWithUserFullInfo:(BIMUserFullInfo *)userFullInfo
{
    if (!userFullInfo) {
        return @"";
    }
    
    NSString *showName = [NSString stringWithFormat:@"用户%lld", userFullInfo.uid];
    if (!BTD_isEmptyString(userFullInfo.alias)) {
        showName = userFullInfo.alias;
    } else if (!BTD_isEmptyString(userFullInfo.nickName)) {
        showName = userFullInfo.nickName;
    }
    return showName;
}

/// 好友备注 > 群内备注 > 用户资料 > 兜底 userID
+ (NSString *)getShowNameInGroupWithUser:(BIMUser *)user member:(id<BIMMember>)member
{
    if (!user && !member) {
        return @"";
    }
    
    NSString *showName = [NSString stringWithFormat:@"用户%lld", (user ?: member).userID];
    if (!BTD_isEmptyString(user.alias)) {
        showName = user.alias;
    } else if (!BTD_isEmptyString(member.alias)) {
        showName = member.alias;
    } else if (!BTD_isEmptyString(user.nickName)) {
        showName = user.nickName;
    }
    return showName;
}

+ (NSString *)getShowNameWithConversation:(BIMConversation *)conversation
{
    if (!conversation) {
        return @"";
    }
    
    NSString *showName = @"未命名群聊";
    if (conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        long long oppositeUserID = conversation.oppositeUserID;
        if (oppositeUserID > 0) {
            BIMUser *user = [BIMUIClient sharedInstance].userProvider(oppositeUserID);
            showName = [BIMUICommonUtility getShowNameWithUser:user];
        } else {
            showName = @"私聊";
        }
    } else if (conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        NSString *name = conversation.name;
        if (![NSString im_isBlankString:name]) {
            showName = name;
        }
    }
    return showName;
}

/// 用户资料 > 兜底 userID
+ (NSString *)getSystemMessageUserNameWithUser:(BIMUser *)user
{
    if (!user) {
        return @"";
    }
    
    NSString *showName = [NSString stringWithFormat:@"用户%lld", user.userID];
    if (!BTD_isEmptyString(user.nickName)) {
        showName = user.nickName;
    }
    return showName;
}

/// 群内备注 > 用户资料 > 兜底 userID
+ (NSString *)getSystemMessageUserNameWithUser:(BIMUser *)user member:(id<BIMMember>)member
{
    if (!user && !member) {
        return @"";
    }
    
    NSString *showName = [NSString stringWithFormat:@"用户%lld", (user ?: member).userID];
    if (!BTD_isEmptyString(member.alias)) {
        showName = member.alias;
    } else if (!BTD_isEmptyString(user.nickName)) {
        showName = user.nickName;
    }
    return showName;
}

@end
