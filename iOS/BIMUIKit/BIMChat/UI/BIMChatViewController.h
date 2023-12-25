//
//  BIMChatViewController.h
//
//  Created by Weibai on 2022/11/4.
//

#import "BIMBaseTableViewController.h"

@class BIMConversation, BIMMessage, BIMChatViewController;

@protocol BIMChatViewControllerDelegate <NSObject>

- (void)chatViewController:(BIMChatViewController *)controller didClickAvatar:(BIMMessage *)message;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BIMChatViewController : BIMBaseTableViewController

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation;

@property (nonatomic, strong) BIMMessage *anchorMessage;

@property (nonatomic, weak) id<BIMChatViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
