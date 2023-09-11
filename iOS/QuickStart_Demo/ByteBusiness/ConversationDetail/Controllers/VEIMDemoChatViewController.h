//
//  VEIMDemoChatViewController.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMConversation, BIMMessage;
@interface VEIMDemoChatViewController : UIViewController
+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation;
@property (nonatomic, strong) BIMMessage *anchorMessage;
@end

NS_ASSUME_NONNULL_END
