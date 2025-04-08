//
//  BIMBaseConversationListController+Private.h
//  Pods
//
//  Created by hexi on 2023/12/5.
//

#import "BIMBaseConversationListController.h"

@class BIMConversationCell;

@interface BIMBaseConversationListController()

@property (nonatomic, strong, nullable) id<BIMConversationListDataSourceProtocol> conversationDataSource;

- (void)userDidLogin;

- (void)userDidLogout;

- (void)setupDataSourceIfNeed;

- (void)setupDataSource;

- (void)loadNexPageConversations;

- (void)conversationDataSourceDidReloadAllConversations:(id<BIMConversationListDataSourceProtocol> _Nullable)dataSource;

- (void)reloadData;

- (void)prepareCell:(BIMConversationCell *_Nullable)cell forConverastion:(BIMConversation *_Nullable)converastion;

@end
