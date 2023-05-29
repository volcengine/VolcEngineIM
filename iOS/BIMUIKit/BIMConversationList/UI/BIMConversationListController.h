//
//ConversationListController.h
//
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMBaseTableViewController.h"

@class BIMConversationListController, BIMConversation;
@protocol BIMConversationListControllerDelegate <NSObject>

- (void)conversationListController:(BIMConversationListController *_Nullable)controller didSelectConversation:(BIMConversation *)conversation;

- (void)conversationListController:(BIMConversationListController *_Nullable)controller onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BIMConversationListController : BIMBaseTableViewController
@property (nonatomic, weak) id<BIMConversationListControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
