//
//  VEIMDemoChatViewController.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMConversation;
@interface VEIMDemoChatViewController : UIViewController
+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation;
@end

NS_ASSUME_NONNULL_END
