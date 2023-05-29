//
//  TIMStickerKeyboard.h
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/14.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMStickerDataManager.h"
@class BIMStickerKeyboard;

NS_ASSUME_NONNULL_BEGIN
@protocol TIMStickerKeyboardDelegate <NSObject>

- (void)stickerKeyboard:(BIMStickerKeyboard *)stickerKeyboard didClickEmoji:(BIMEmoji *)emoji;
- (void)stickerKeyboardDidClickDeleteButton:(BIMStickerKeyboard *)stickerKeyboard;
- (void)stickerKeyboardDidClickSendButton:(BIMStickerKeyboard *)stickerKeyboard;

@end


@interface BIMStickerKeyboard : UIView

@property (nonatomic, weak) id<TIMStickerKeyboardDelegate> delegate;

- (CGFloat)heightThatFits;

@end

NS_ASSUME_NONNULL_END
