//
//  TIMStickerDataManager.h
//  TTIMSDK
//
//  Created by 暖阳 on 2019/10/14.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface BIMEmoji : NSObject

@property (nonatomic, strong) NSString *imageName; //表情对应的图片名称
@property (nonatomic, strong) NSString *emojiDes;  //表情对应字符（例如微笑表情对应[微笑]）

@end


@interface BIMSticker : NSObject

@property (nonatomic, strong) NSArray<BIMEmoji *> *emojis;

@end


@interface BIMStickerDataManager : NSObject

+ (instancetype)sharedInstance;

// 表情包数据源
@property (nonatomic, strong, readonly) NSArray<BIMSticker *> *allStickers;

/* 匹配给定attributedString中的所有emoji，如果匹配到的emoji有本地图片的话会直接换成本地的图片
 *
 * @param attributedString 可能包含表情包的attributedString
 * @param font 表情图片的对齐字体大小
 */
- (void)replaceEmojiForAttributedString:(NSMutableAttributedString *)attributedString font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
