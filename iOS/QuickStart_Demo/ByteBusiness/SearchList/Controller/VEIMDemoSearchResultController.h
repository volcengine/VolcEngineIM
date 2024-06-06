//
//  VEIMDemoSearchResultController.h
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/20.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"
#import "BIMMessage.h"
#import "BIMDefine.h"
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoSearchResultController : BIMBaseViewController

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, assign) BIMMessageType msgType;

- (instancetype)initWithConversationID:(NSString *)conversationID msgType:(BIMMessageType)msgType direction:(BIMPullDirection)direction;

- (void)becomeFirstResponder;

@end

NS_ASSUME_NONNULL_END
