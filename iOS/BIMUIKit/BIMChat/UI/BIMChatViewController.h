//
//  BIMChatViewController.h
//
//  Created by Weibai on 2022/11/4.
//

#import "BIMBaseTableViewController.h"

@class BIMConversation;

NS_ASSUME_NONNULL_BEGIN

@interface BIMChatViewController : BIMBaseTableViewController

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
