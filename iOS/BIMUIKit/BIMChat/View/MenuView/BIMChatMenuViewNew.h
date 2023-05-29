//
//ChatMenuViewNew.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/16.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMChatMenuCollectionView.h"


NS_ASSUME_NONNULL_BEGIN
@class BIMChatMenuViewNew, BIMMessage;
@protocol BIMChatMenuViewNewDelegate <NSObject>

- (void)menuView: (BIMChatMenuViewNew *)menu didClickType: (BIMChatMenuType)type message: (BIMMessage *)message;

- (void)menuView: (BIMChatMenuViewNew *)menu didClickEmoji: (BIMEmoji *)emoji message: (BIMMessage *)message;

@end

@interface BIMChatMenuViewNew : UIView

@property (nonatomic, weak) id <BIMChatMenuViewNewDelegate> delegate;

- (void)showItems:(NSMutableArray<BIMChatMenuItemModel *> *)items onView:(nonnull UIView *)view message: (BIMMessage *)message;

- (void)refreshMessage: (BIMMessage *)message;

- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
