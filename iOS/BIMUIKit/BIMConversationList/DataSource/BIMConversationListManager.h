//
//  BIMConversationListManager.h
//  im-uikit-tob
//
//  Created by hexi on 2023/11/19.
//

#import <Foundation/Foundation.h>

@class BIMConversation;

@protocol BIMConversationListManagerDelegate <NSObject>

- (void)chatListDidProcessed:(NSArray<BIMConversation *> *_Nullable)chatList;

@end

@interface BIMConversationListManager : NSObject

@property (nonatomic, weak, nullable) id<BIMConversationListManagerDelegate> delegate;

- (void)binaryInsertChatList:(NSArray<BIMConversation *> *_Nullable)conversationList;

- (void)removeChatWithIdentifiers:(NSArray<NSString *> *_Nullable)conversationIdList;

@end
