//
//  BIMUnreadMessageListViewController.h
//  im-uikit-tob
//
//  Created by jacky on 2024/7/9.
//

#import "BIMBaseViewController.h"

@class BIMConversation;

NS_ASSUME_NONNULL_BEGIN

@interface BIMUnreadMessageListViewController : BIMBaseViewController

@property (nonatomic, strong) BIMConversation *conversation;

@end

NS_ASSUME_NONNULL_END
