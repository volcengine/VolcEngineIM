//
//  VEIMDemoIMManager+Conversation.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/25.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoIMManager.h"
#import "VEIMDemoUser.h"

#import <imsdk-tob/BIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoIMManager (Conversation)

- (void)addUsers: (NSArray <VEIMDemoUser *> *)users con: (BIMConversation *)con completion:( void (^ _Nullable)(NSError *_Nullable error))completion;
- (void)removeUsers: (NSArray <VEIMDemoUser *> *)users con: (BIMConversation *)con completion:(void (^ _Nullable)(NSError *_Nullable error))completion;

- (void)setAdmins: (NSArray <VEIMDemoUser *>*)users con: (BIMConversation *)con completion:(void(^ _Nullable)(NSError *_Nullable error))completion;

- (void)quitCon: (BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion;

- (void)dismissCon: (BIMConversation *)con completion:(void (^ _Nullable)(NSError * _Nullable))completion;

/// 设置管理员
- (void)promoteUser:(long long)userID con: (BIMConversation *)con completion:(void(^ _Nullable)(NSError *_Nullable error))completion;
/// 降级管理员
- (void)downgradeUser:(long long)userID con: (BIMConversation *)con completion:(void(^ _Nullable)(NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
