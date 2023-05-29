//
//  TIMStickerPageView.h
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/15.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMSlideLineButton.h"
#import "BIMQueuingScrollView.h"
@class BIMStickerPageView;
@class BIMEmoji;
@class BIMSticker;

/// 表情面板显示删除按钮还是关闭按钮
typedef NS_ENUM(NSInteger, BIMStickerButtonType) {
    BIMStickerButtonTypeDel = 0,
    BIMStickerButtonTypeClose,
};

extern NSUInteger const TIMStickerPageViewMaxEmojiCount;

@protocol BIMStickerPageViewDelegate <NSObject>

- (void)stickerPageView:(BIMStickerPageView *)stickerPageView didClickEmoji:(BIMEmoji *)emoji;
- (void)stickerPageViewDidClickDeleteButton:(BIMStickerPageView *)stickerPageView;
- (void)stickerPageViewDidClickCloseButton:(BIMStickerPageView *)stickerPageView;

@end

// 表情View
@interface BIMStickerPageView : UIView <BIMReusablePage>

@property (nonatomic, weak) id<BIMStickerPageViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BIMStickerButtonType buttonType;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureWithSticker:(BIMSticker *)sticker;

@end
