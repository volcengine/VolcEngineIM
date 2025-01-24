//
//  VEIMDemoIMManager+Conversation.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/25.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoIMManager+Conversation.h"
#import "VEIMDemoIMManager+Message.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoDefine.h"
#import "BIMToastView.h"
#import <im-uikit-tob/BIMUIClient.h>
#import <im-uikit-tob/BIMUICommonUtility.h>

@implementation VEIMDemoIMManager (Conversation)

- (void)addUsers:(NSArray<VEIMDemoUser *> *)users con:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (users.count<=0 || !con || con.conversationType != BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        return;
    }
    NSMutableOrderedSet *orderSet = [NSMutableOrderedSet orderedSet];
    BIMUser *currentUser = [BIMUIClient sharedInstance].userProvider([VEIMDemoUserManager sharedManager].currentUser.userID);
    NSString *msgStr = [NSString stringWithFormat:@"%@邀请", [BIMUICommonUtility getSystemMessageUserNameWithUser:currentUser]];
    for (VEIMDemoUser *user in users) {
        [orderSet addObject:@(user.userID)];
        BIMUser *u = [BIMUIClient sharedInstance].userProvider(user.userID);
        NSString *userName = [BIMUICommonUtility getSystemMessageUserNameWithUser:u];
        if (users.lastObject != user) {
            msgStr = [msgStr stringByAppendingFormat:@"%@、", userName];
        }else{
            msgStr = [msgStr stringByAppendingFormat:@"%@加入群聊", userName];
        }
    }
    
    [[BIMClient sharedInstance] addGroupMemberList:con.conversationID memberList:orderSet completion:^(NSSet<NSNumber *> * _Nonnull participants, BIMError * _Nullable error) {
        if (!error) {
            [self sendSystemMessage:msgStr convId:con.conversationID completion:nil];
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (void)removeUsers:(NSArray<VEIMDemoUser *> *)users con:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (users.count<=0 || !con || con.conversationType != BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        return;
    }
    NSMutableSet *set = [NSMutableSet set];
    NSMutableString *systemMsg = [@"" mutableCopy];
    for (VEIMDemoUser *user in users) {
        [set addObject:@(user.userID)];
        BIMUser *u = [BIMUIClient sharedInstance].userProvider(user.userID);
        NSString *userName = [BIMUICommonUtility getSystemMessageUserNameWithUser:u];
        if (users.lastObject != user) {
            [systemMsg appendFormat:@"%@、", userName];
        }else{
            [systemMsg appendFormat:@"%@退出群聊", userName];
        }
    }
    
    [self sendSystemMessage:systemMsg convId:con.conversationID completion:nil];
    [[BIMClient sharedInstance] removeGroupMemberList:con.conversationID uidList:set completion:^(NSSet<NSNumber *> * _Nonnull participants, BIMError * _Nullable bimError) {
        NSError *error;
        if (bimError) {
            error = [NSError errorWithDomain:kVEIMDemoErrorDomain code:bimError.code userInfo:@{NSLocalizedDescriptionKey : bimError.localizedDescription}];
            [BIMToastView toast:[NSString stringWithFormat:@"移除失败：%@", error.localizedDescription]];
        }
        BTD_BLOCK_INVOKE(completion, error);
    }];
}

- (void)quitCon:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    long long userID = [VEIMDemoUserManager sharedManager].currentUser.userID;
    BIMUser *u = [BIMUIClient sharedInstance].userProvider(userID);
    NSString *userName = [BIMUICommonUtility getSystemMessageUserNameWithUser:u];
    [self sendSystemMessage:[NSString stringWithFormat:@"%@退出聊天", userName] convId:con.conversationID completion:^(NSError * _Nullable error) {
        if (!error){
            [[BIMClient sharedInstance] leaveGroup:con.conversationID completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"退出失败：%@",error.localizedDescription]];
                }else{
        //            NSString *chatMsg = con.conversationType == ONE_TO_ONE_CHAT?@"聊天":@"群聊";
                    [[BIMClient sharedInstance] deleteConversation:con.conversationID completion:nil];
                }
                if (completion) {
                    completion(error);
                }
            }];
        }
    }];

}

- (void)dismissCon:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    [self sendSystemMessage:@" 群聊被解散 " convId:con.conversationID completion:nil];
    [[BIMClient sharedInstance] dissolveGroup:con.conversationID completion:^(BIMError * _Nullable bimError) {
        NSError *error;
        if (bimError) {
            error = [NSError errorWithDomain:kVEIMDemoErrorDomain code:bimError.code userInfo:@{NSLocalizedDescriptionKey : bimError.localizedDescription}];
            [BIMToastView toast:[NSString stringWithFormat:@"解散失败：%@", error.localizedDescription]];
        }
        BTD_BLOCK_INVOKE(completion, error);
    }];
}

- (void)setAdmins:(NSArray<VEIMDemoUser *> *)users con:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    //先把原来的管理员拿出来
    NSMutableArray *oldManagers = [NSMutableArray array];
    NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:con.conversationID];
    for (id <BIMMember>participant in participants) {
        if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
            [oldManagers addObject:@(participant.userID)];
        }
    }
    
    for (VEIMDemoUser *user in users) {
        for (int i = 0; i<oldManagers.count; i++) {
            NSNumber *userIDN = oldManagers[i];
            long long userID = [userIDN longLongValue];
            if (user.userID == userID) {
                [oldManagers removeObject:userIDN];
                break;
            }
        }
        [self promoteUser:user.userID con:con completion:completion];
    }
    
    for (NSNumber *userIdN in oldManagers) {
        [self downgradeUser:[userIdN longLongValue] con:con completion:completion];
    }
}

- (void)promoteUser:(long long)userID con:(nonnull BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (userID<=0 || !con) {
        return;
    }
    id <BIMMember>participant;
    NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:con.conversationID];
    for (id <BIMMember>participantInCon in participants) {
        if (participantInCon.userID == userID) {
            participant = participantInCon;
            break;
        }
    }
    
    if (!participant || participant.role != BIM_MEMBER_ROLE_NORMAL) {
        return;
    }
    
    [[BIMClient sharedInstance] setGroupMemberRole:con.conversationID uidList:[NSSet setWithObject:@(userID)] role: BIM_MEMBER_ROLE_ADMIN completion:^(BIMError * _Nullable error) {
        if (!error) {
            BIMUser *u = [BIMUIClient sharedInstance].userProvider(userID);
            NSString *userName = [BIMUICommonUtility getSystemMessageUserNameWithUser:u];
            NSString *sysMsg = [NSString stringWithFormat:@"%@成为管理员", userName];
            [self sendSystemMessage:sysMsg convId:con.conversationID completion:nil];
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (void)downgradeUser:(long long)userID con:(nonnull BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (userID<=0 || !con) {
        return;
    }
    id <BIMMember>participant;
    NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:con.conversationID];
    for (id <BIMMember>participantInCon in participants) {
        if (participantInCon.userID == userID) {
            participant = participantInCon;
            break;
        }
    }
    if (!participant || participant.role != BIM_MEMBER_ROLE_ADMIN) {
        return;
    }
    
    [[BIMClient sharedInstance] setGroupMemberRole:con.conversationID uidList:[NSSet setWithObject:@(userID)] role:BIM_MEMBER_ROLE_NORMAL completion:^(BIMError * _Nullable error) {
        if (!error) {
            BIMUser *u = [BIMUIClient sharedInstance].userProvider(userID);
            NSString *userName = [BIMUICommonUtility getSystemMessageUserNameWithUser:u];
            NSString *sysMsg = [NSString stringWithFormat:@"%@被取消管理员", userName];
            [self sendSystemMessage:sysMsg convId:con.conversationID completion:nil];
        }
        if (completion) {
            completion(error);
        }
    }];
}

@end
