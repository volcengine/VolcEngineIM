//
//  VEIMDemoMediaResultController.h
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/22.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"
#import "BIMMessage.h"
#import "BIMConversation.h"
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoMediaResultController : BIMBaseViewController

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, assign) BIMConversationType convType;
@property (nonatomic, assign) BIMMessageType msgType;

- (instancetype)initWithConversationID:(NSString *)conversationID convtype:(BIMConversationType)convType msgType:(BIMMessageType)msgType direction:(BIMPullDirection)direction;

@end

NS_ASSUME_NONNULL_END
