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


@implementation VEIMDemoIMManager (Conversation)

- (void)addUsers:(NSArray<VEIMDemoUser *> *)users con:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (users.count<=0 || !con || con.conversationType != BIM_CONVERSATION_TYPE_GROUP_CHAT) {
        return;
    }
    NSMutableOrderedSet *orderSet = [NSMutableOrderedSet orderedSet];
    NSMutableString *systemMsg = [@"" mutableCopy];
    for (VEIMDemoUser *user in users) {
        [orderSet addObject:@(user.userID)];
        if (users.lastObject != user) {
            [systemMsg appendFormat:@"%@、",user.name];
        }else{
            [systemMsg appendFormat:@"%@加入群聊",user.name];
        }
    }
    
    [[BIMClient sharedInstance] addGroupMemberList:con.conversationID memberList:orderSet completion:^(NSSet<NSNumber *> * _Nonnull participants, BIMError * _Nullable error) {
        if (!error) {
            [self sendSystemMessage:systemMsg convId:con.conversationID completion:nil];
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
        if (users.lastObject != user) {
            [systemMsg appendFormat:@"%@、",user.name];
        }else{
            [systemMsg appendFormat:@"%@退出群聊",user.name];
        }
    }
    
    [[BIMClient sharedInstance] removeGroupMemberList:con.conversationID uidList:set completion:^(NSSet<NSNumber *> * _Nonnull participants, BIMError * _Nullable error) {
        if (!error) {
            [self sendSystemMessage:systemMsg convId:con.conversationID completion:nil];
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (void)quitCon:(BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    [self sendSystemMessage:[NSString stringWithFormat:@"%@退出聊天",[VEIMDemoUserManager sharedManager].currentUser.name] convId:con.conversationID completion:^(NSError * _Nullable error) {
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
    [[BIMClient sharedInstance] dissolveGroup:con.conversationID completion:^(BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"解散失败：%@",error.localizedDescription]];
        }
        if (completion) {
            completion(error);
        }
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
            NSString *sysMsg = [NSString stringWithFormat:@"%@成为管理员", [[VEIMDemoUserManager sharedManager] nicknameForTestUser:userID]];
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
            NSString *sysMsg = [NSString stringWithFormat:@"%@被取消管理员", [[VEIMDemoUserManager sharedManager] nicknameForTestUser:userID]];
            [self sendSystemMessage:sysMsg convId:con.conversationID completion:nil];
        }
        if (completion) {
            completion(error);
        }
    }];
}

@end
