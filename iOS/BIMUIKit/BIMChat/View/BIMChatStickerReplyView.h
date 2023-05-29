//
//ChatStickerReplyView.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/18.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <imsdk-tob/BIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMChatStickerReplyView : UIView

- (void)refreshWithMessage: (BIMMessage *)message;

- (BOOL)containSticker: (BIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
