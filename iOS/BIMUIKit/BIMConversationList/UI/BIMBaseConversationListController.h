//
//  BIMBaseConversationListController.h
//  im-uikit-tob
//
//  Created by hexi on 2023/11/20.
//

#import "BIMBaseTableViewController.h"

@class BIMBaseConversationListController, BIMConversation;
@protocol BIMConversationListDataSourceProtocol;

typedef NS_ENUM(NSInteger, BIMConversationListType) {
    BIMConversationListTypeAllConversation = 0,        // 全部会话
    BIMConversationListTypeFriendConversation = 1,     // 好友会话
};

@protocol BIMConversationListControllerDelegate <NSObject>

- (void)conversationListController:(BIMBaseConversationListController *_Nullable)controller didSelectConversation:(BIMConversation *_Nullable)conversation;

- (void)conversationListController:(BIMBaseConversationListController *_Nullable)controller onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount;

@end

@interface BIMBaseConversationListController : BIMBaseTableViewController

@property (nonatomic, assign) BIMConversationListType type;

@property (nonatomic, weak, nullable) id<BIMConversationListControllerDelegate> delegate;

@end
