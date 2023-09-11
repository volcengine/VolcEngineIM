//
//  BIMChatViewController.h
//
//  Created by Weibai on 2022/11/4.
//

#import "BIMBaseTableViewController.h"

@class BIMConversation, BIMMessage;

NS_ASSUME_NONNULL_BEGIN

@interface BIMChatViewController : BIMBaseTableViewController

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation;

@property (nonatomic, strong) BIMMessage *anchorMessage;


@end

NS_ASSUME_NONNULL_END
