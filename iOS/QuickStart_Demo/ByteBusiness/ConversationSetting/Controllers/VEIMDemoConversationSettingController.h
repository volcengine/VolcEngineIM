//
//  VEIMDemoConversationSettingController.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMBaseTableViewController.h"

#import <imsdk-tob/BIMSDK.h>

NS_ASSUME_NONNULL_BEGIN


@interface VEIMDemoConversationSettingController : BIMBaseTableViewController

- (instancetype)initWithConversation: (BIMConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
