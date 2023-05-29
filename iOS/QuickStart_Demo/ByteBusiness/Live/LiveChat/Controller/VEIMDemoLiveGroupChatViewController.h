//
//  VEIMDemoLiveGroupChatViewController.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/24.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMConversation;
@interface VEIMDemoLiveGroupChatViewController : UIViewController
+ (instancetype)liveGroupChatVCWithConversation:(BIMConversation *)conversation;
@end

NS_ASSUME_NONNULL_END
