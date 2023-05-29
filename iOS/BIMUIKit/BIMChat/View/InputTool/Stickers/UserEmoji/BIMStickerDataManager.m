//
//  TIMStickerDataManager.m
//  TTIMSDK
//
//  Created by 暖阳 on 2019/10/14.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import "BIMStickerDataManager.h"


@interface TIMStickerMatchingResult : NSObject
@property (nonatomic, assign) NSRange range;        // 匹配到的表情包文本的range
@property (nonatomic, strong) UIImage *emojiImage;  // 如果能在本地找到emoji的图片，则此值不为空
@property (nonatomic, strong) NSString *showingDes; // 表情的实际文本(形如：[微笑])，不为空
@end


@implementation TIMStickerMatchingResult
@end


@implementation BIMEmoji
@end


@implementation BIMSticker
@end

static NSString *const EMOJI_PREFIX = @"emoji_";


@interface BIMStickerDataManager ()
@property (nonatomic, strong, readwrite) NSArray<BIMSticker *> *allStickers;
@property (nonatomic, strong, readwrite) NSDictionary *emojiDict;
@end


@implementation BIMStickerDataManager

+ (instancetype)sharedInstance
{
    static BIMStickerDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BIMStickerDataManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initStickers];
    }
    return self;
}

- (void)initStickers
{
    NSString *emojiBundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"TIMOEmoji" ofType:@"bundle"];
    NSBundle *emojiBundle = [NSBundle bundleWithPath:emojiBundlePath];
    NSString *plistPath = [emojiBundle pathForResource:@"emoji_all" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray<BIMSticker *> *stickers = [[NSMutableArray alloc] init];
    BIMSticker *sticker = [[BIMSticker alloc] init];
    NSMutableArray<BIMEmoji *> *emojis = [[NSMutableArray alloc] init];
    for (NSDictionary *stickerDict in array) {
        BIMEmoji *emoji = [[BIMEmoji alloc] init];
        emoji.imageName = stickerDict[@"imageName"];
        emoji.emojiDes = stickerDict[@"emojiDes"];
        [emojis addObject:emoji];
    }
    sticker.emojis = emojis;
    [stickers addObject:sticker];
    self.allStickers = stickers;

    NSString *emojiPath = [emojiBundle pathForResource:@"emoji" ofType:@"plist"];
    self.emojiDict = [NSDictionary dictionaryWithContentsOfFile:emojiPath];
}

#pragma mark - public method

- (void)replaceEmojiForAttributedString:(NSMutableAttributedString *)attributedString font:(UIFont *)font
{
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<TIMStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];

    if (matchingResults && matchingResults.count) {
        NSUInteger offset = 0;
        for (TIMStickerMatchingResult *result in matchingResults) {
            if (result.emojiImage) {
                CGFloat emojiHeight = font.lineHeight;
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = result.emojiImage;
                attachment.bounds = CGRectMake(0, font.descender, emojiHeight, emojiHeight);
                NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDes.length);
                [attributedString replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
                offset += result.showingDes.length - emojiAttributedString.length;
            }
        }
    }
}

#pragma mark - private method

- (NSArray<TIMStickerMatchingResult *> *)matchingEmojiForString:(NSString *)string
{
    if (!string.length) {
        return nil;
    }

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^\\[\\]]*\\]" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (results && results.count) {
        NSMutableArray *emojiMatchingResults = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *result in results) {
            NSString *showingDescription = [string substringWithRange:result.range];
            BIMEmoji *emoji = [self emojiWithEmojiDescription:showingDescription];
            if (emoji) {
                TIMStickerMatchingResult *emojiMatchingResult = [[TIMStickerMatchingResult alloc] init];
                emojiMatchingResult.range = result.range;
                emojiMatchingResult.showingDes = showingDescription;
                emojiMatchingResult.emojiImage = [UIImage imageNamed:[@"TIMOEmoji.bundle" stringByAppendingPathComponent:emoji.imageName]];
                [emojiMatchingResults addObject:emojiMatchingResult];
            }
        }
        return emojiMatchingResults;
    }
    return nil;
}

- (BIMEmoji *)emojiWithEmojiDescription:(NSString *)emojiDescription
{
    if (self.emojiDict[emojiDescription]) {
        BIMEmoji *emoji = [[BIMEmoji alloc] init];
        emoji.emojiDes = emojiDescription;
        emoji.imageName = [NSString stringWithFormat:@"%@%@", EMOJI_PREFIX, self.emojiDict[emojiDescription]];
        return emoji;
    }
    return nil;
}

@end
