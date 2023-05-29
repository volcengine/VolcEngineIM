//
//  VEIMDemoLiveGroupSettingViewController.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/25.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMBaseTableViewController.h"
#import <imsdk-tob/BIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoLiveGroupSettingViewController : BIMBaseTableViewController
- (instancetype)initWithConversation:(BIMConversation *)conversation;
@end

NS_ASSUME_NONNULL_END
