//
//  MenuEmojiView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/26.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMStickerDataManager.h"

@protocol BIMChatMenuEmojiViewDelegate <NSObject>

- (void)menuEmojiViewDidClickEmoji:(BIMEmoji *)emoji;
- (void)menuEmojiViewDidClickCloseButton;

@end


@interface BIMChatMenuEmojiView : UIView
@property (nonatomic, weak) id <BIMChatMenuEmojiViewDelegate>delegate;

- (CGFloat)heightThatFits;

@end
