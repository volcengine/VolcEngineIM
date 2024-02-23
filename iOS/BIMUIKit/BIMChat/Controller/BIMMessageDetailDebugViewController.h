//
//  BIMMessageDetailDebugViewController.h
//  im-uikit-tob
//
//  Created by yangzhanjiang on 2024/1/31.
//

#import "BIMBaseViewController.h"

@class BIMMessage;
NS_ASSUME_NONNULL_BEGIN
@interface BIMMessageDetailDebugViewController : BIMBaseViewController
@property (nonatomic, strong) BIMMessage *message;
@property (nonatomic, assign) NSInteger conversationShortID;
@end

NS_ASSUME_NONNULL_END
