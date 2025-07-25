//
//  BIMChatViewController.h
//
//  Created by Weibai on 2022/11/4.
//

#import "BIMBaseTableViewController.h"

@class BIMConversation, BIMMessage, BIMChatViewController;

@protocol BIMChatViewControllerDelegate <NSObject>

- (void)chatViewController:(BIMChatViewController *)controller didClickAvatar:(BIMMessage *)message;
- (void)chatViewController:(BIMChatViewController *_Nonnull)controller didClickReadDetailWithMessage:(BIMMessage *_Nonnull)message;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BIMChatViewController : BIMBaseTableViewController

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation;
+ (instancetype)chatVCWithToUserID:(NSString *)toUserID;

@property (nonatomic, strong) BIMMessage *anchorMessage;
@property (nonatomic, strong) NSArray<NSNumber *> *inputToolMenuTypeArray;
@property (nonatomic, weak) id<BIMChatViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
