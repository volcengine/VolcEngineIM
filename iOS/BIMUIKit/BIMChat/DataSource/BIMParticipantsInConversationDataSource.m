//
//  BIMParticipantsInConversationDataSource.m
//  ByteBusiness
//
//  Created by zhanjiang on 2022/11/22.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMParticipantsInConversationDataSource.h"
#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>

@interface BIMParticipantsInConversationDataSource ()<BIMConversationListListener, BIMGroupMemberListener>
@property (nonatomic, strong) NSString *conversationID;
@property (nonatomic, strong) NSArray<id<BIMMember>> *participants;
@property (nonatomic, strong) NSArray<id<BIMMember>> *admParticipants;

@end

@implementation BIMParticipantsInConversationDataSource

- (instancetype)initWithConversationID:(NSString *)conversationID
{
    self = [super init];
    if (self) {
        NSParameterAssert(conversationID);
        _conversationID = conversationID;

        self.participants = [[BIMClient sharedInstance] getConversationMemberList:conversationID];
        [[BIMClient sharedInstance] addConversationListener:self];
        [[BIMClient sharedInstance] addGroupMemberListener:self];
        [self fetchAllAdministrator];
    }
    return self;
}

- (void)fetchAllAdministrator
{
    if (self.participants.count <= 0) {
        self.admParticipants = @[];
        return;
    }
    self.admParticipants = [self.participants filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id<BIMMember> _Nullable participant, NSDictionary<NSString *, id> *_Nullable bindings) {
                                                  if (participant.role == BIM_MEMBER_ROLE_ADMIN) {
                                                      return YES;
                                                  }
                                                  return NO;
                                              }]];
}

- (void)fetchParticipantsAlias:(NSSet<NSNumber *> *_Nullable)participants completion:(void (^_Nullable)(NSArray<id<BIMMember>> *participants, NSError *_Nullable error))completion
{
    if (self.participants.count <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:@"has no participants" code:-1 userInfo:nil];
            completion(@[], error);
        });
        return;
    }
    if (participants) {
        NSArray *filtersArray = [self.participants filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id<BIMMember> _Nullable participant, NSDictionary<NSString *, id> *_Nullable bindings) {
                                                       if ([participants containsObject:@(participant.userID)]) {
                                                           return YES;
                                                       }
                                                       return NO;
                                                   }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(filtersArray, nil);
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = [NSError errorWithDomain:@"parameter error" code:-2 userInfo:nil];
        completion(@[], error);
    });
}

#pragma mark - BIMGroupMemberListener

- (void)onBatchMemberInfoChanged:(BIMConversation *)conversation members:(NSArray<id<BIMMember>> *)members
{
    if (![conversation.conversationID isEqualToString:self.conversationID]) {
        return;
    }
    
    NSMutableDictionary<NSNumber *, id<BIMMember>> *memberDict = [NSMutableDictionary dictionary];
    [members enumerateObjectsUsingBlock:^(id<BIMMember>  _Nonnull member, NSUInteger idx, BOOL * _Nonnull stop) {
        [memberDict btd_setObject:member forKey:@(member.userID)];
    }];
    
    NSMutableArray *participants = [NSMutableArray array];
    [self.participants enumerateObjectsUsingBlock:^(id<BIMMember>  _Nonnull participant, NSUInteger idx, BOOL * _Nonnull stop) {
        id<BIMMember> member = [memberDict btd_objectForKey:@(participant.userID) default:nil];
        if (member) {
            [participants btd_addObject:member];
        } else {
            [participants btd_addObject:participant];
        }
    }];
    self.participants = [participants copy];
    [self fetchAllAdministrator];
    if (self.delegate && [self.delegate respondsToSelector:@selector(participantsDataSourceDidUpdate:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate participantsDataSourceDidUpdate:self];
        });
    }
}

#pragma mark - BIMConversationListListener

//- (void)onParticipantsInConversationChanged:(NSArray<BIMConversation *> *)conversationList
//{
//    BOOL containCon = NO;
//    for (BIMConversation *con in conversationList) {
//        if ([con.conversationID isEqualToString:self.conversationID]) {
//            containCon = YES;
//            break;
//        }
//    }
//    if (!containCon) {
//        return;
//    }
//
//    NSArray *newList = [[BIMClient sharedInstance] getConversationMemberList:self.conversationID];
//    if ([self.participants isEqual:newList]) {
//        return;
//    }
//
//    self.participants = newList;
//    [self fetchAllAdministrator];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(participantsDataSourceDidUpdate:)]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate participantsDataSourceDidUpdate:self];
//        });
//    }
//}

@end
