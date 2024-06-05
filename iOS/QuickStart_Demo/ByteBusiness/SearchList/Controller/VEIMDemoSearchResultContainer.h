//
//  VEIMDemoSearchResultContainer.h
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/17.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <im-uikit-tob/BIMBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoSearchResultContainer : BIMBaseViewController

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, assign) BIMConversationType convType;
- (instancetype)initWithConversationID:(NSString *)conversationID conversationType:(BIMConversationType)convType direction:(BIMPullDirection)direction;

@end

NS_ASSUME_NONNULL_END
