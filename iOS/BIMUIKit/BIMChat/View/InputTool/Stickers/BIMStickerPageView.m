//
//  TIMStickerPageView.m
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/15.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import "BIMStickerPageView.h"
#import "BIMStickerDataManager.h"
#import "BIMUIDefine.h"

NSUInteger const TIMStickerPageViewMaxEmojiCount = 20;
static NSUInteger const TIMStickerPageViewLineCount = 3;
static NSUInteger const TIMStickerPageViewButtonPerLine = 7;
static CGFloat const TIMStickerPageViewEmojiButtonLength = 32.0;
static CGFloat const TIMStickerPageViewEmojiButtonVerticalMargin = 16.0;


@interface BIMStickerPageView ()
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSTimer *deleteEmojiTimer;
@property (nonatomic, strong) BIMSticker *sticker;
@property (nonatomic, strong) NSArray<UIButton *> *emojiButtons;
@end


@implementation BIMStickerPageView

@synthesize focused = _focused;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize nonreusable = _nonreusable;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame]) {
        NSMutableArray *emojiButtons = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < TIMStickerPageViewMaxEmojiCount; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            [button addTarget:self action:@selector(didClickEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
            //            UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressEmoji:)];
            //            longPressRecognizer.minimumPressDuration = 0.2;
            //            [button addGestureRecognizer:longPressRecognizer];
            [emojiButtons addObject:button];
            [self addSubview:button];
        }
        self.emojiButtons = emojiButtons;
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame reuseIdentifier:nil];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier];
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_input_emoji_delete") forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didTouchDownDeleteButton:) forControlEvents:UIControlEventTouchDown];
        [_deleteButton addTarget:self action:@selector(didTouchUpInsideDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton addTarget:self action:@selector(didTouchUpOutsideDeleteButton:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _deleteButton;
}

- (void)setButtonType:(BIMStickerButtonType)buttonType
{
    _buttonType = buttonType;

    if (buttonType == BIMStickerButtonTypeDel) {
        [self.deleteButton setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_input_emoji_delete") forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(didTouchDownDeleteButton:) forControlEvents:UIControlEventTouchDown];
        [self.deleteButton addTarget:self action:@selector(didTouchUpInsideDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton addTarget:self action:@selector(didTouchUpOutsideDeleteButton:) forControlEvents:UIControlEventTouchUpOutside];
    } else if (buttonType == BIMStickerButtonTypeClose) {
        [self.deleteButton setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_emoji_close") forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(didTouchUpInsideDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat screenWidth = CGRectGetWidth(self.bounds);
    CGFloat spaceBetweenButtons = (screenWidth - TIMStickerPageViewButtonPerLine * TIMStickerPageViewEmojiButtonLength) / (TIMStickerPageViewButtonPerLine + 1);
    for (UIButton *button in self.emojiButtons) {
        NSUInteger index = button.tag;
        if (index > self.sticker.emojis.count) {
            break;
        }

        NSUInteger line = index / TIMStickerPageViewButtonPerLine;
        NSUInteger row = index % TIMStickerPageViewButtonPerLine;

        CGFloat minX = row * TIMStickerPageViewEmojiButtonLength + (row + 1) * spaceBetweenButtons;
        CGFloat minY = line * (TIMStickerPageViewEmojiButtonLength + TIMStickerPageViewEmojiButtonVerticalMargin);
        button.frame = CGRectMake(minX, minY, TIMStickerPageViewEmojiButtonLength, TIMStickerPageViewEmojiButtonLength);
    }

    CGFloat minDeleteX = screenWidth - spaceBetweenButtons - TIMStickerPageViewEmojiButtonLength;
    CGFloat minDeleteY = (TIMStickerPageViewLineCount - 1) * (TIMStickerPageViewEmojiButtonLength + TIMStickerPageViewEmojiButtonVerticalMargin);
    self.deleteButton.frame = CGRectMake(minDeleteX, minDeleteY, TIMStickerPageViewEmojiButtonLength, TIMStickerPageViewEmojiButtonLength);
}

- (void)configureWithSticker:(BIMSticker *)sticker
{
    if (!sticker) {
        return;
    }
    self.sticker = sticker;

    NSArray<BIMEmoji *> *emojis = [self emojisForSticker:sticker atPage:self.pageIndex];
    NSUInteger index = 0;
    for (BIMEmoji *emoji in emojis) {
        if (index > TIMStickerPageViewMaxEmojiCount) {
            break;
        }

        UIButton *button = self.emojiButtons[index];
        [button setImage:[self emojiImageWithName:emoji.imageName] forState:UIControlStateNormal];
        index += 1;
    }

    [self setNeedsLayout];
}

#pragma mark - TIMReusablePage

- (void)prepareForReuse
{
    self.sticker = nil;
    for (UIButton *button in self.emojiButtons) {
        [button setImage:nil forState:UIControlStateNormal];
        button.frame = CGRectZero;
    }
}

#pragma mark - private method

- (void)didClickEmojiButton:(UIButton *)button
{
    NSUInteger index = button.tag;
    NSArray<BIMEmoji *> *emojis = [self emojisForSticker:self.sticker atPage:self.pageIndex];
    if (index >= emojis.count) {
        return;
    }

    BIMEmoji *emoji = emojis[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerPageView:didClickEmoji:)]) {
        [self.delegate stickerPageView:self didClickEmoji:emoji];
    }
}

- (void)didTouchDownDeleteButton:(UIButton *)button
{
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
    // 长按删除按钮
    self.deleteEmojiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delegateDeleteEmoji) userInfo:nil repeats:YES];
    [self deleteEmojiTimer];
}

- (void)didTouchUpInsideDeleteButton:(UIButton *)button
{
    if (self.buttonType == BIMStickerButtonTypeDel) {
        [self delegateDeleteEmoji];

        if (self.deleteEmojiTimer) {
            [self.deleteEmojiTimer invalidate];
            self.deleteEmojiTimer = nil;
        }
    } else if (self.buttonType == BIMStickerButtonTypeClose) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerPageViewDidClickCloseButton:)]) {
            [self.delegate stickerPageViewDidClickCloseButton:self];
        }
    }
}

- (void)didTouchUpOutsideDeleteButton:(UIButton *)button
{
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
}

- (void)delegateDeleteEmoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerPageViewDidClickDeleteButton:)]) {
        [self.delegate stickerPageViewDidClickDeleteButton:self];
    }
}

- (NSArray<BIMEmoji *> *)emojisForSticker:(BIMSticker *)sticker atPage:(NSUInteger)page
{
    if (!sticker || !sticker.emojis.count) {
        return nil;
    }

    NSUInteger totalPage = sticker.emojis.count / TIMStickerPageViewMaxEmojiCount + 1;
    if (page >= totalPage) {
        return nil;
    }

    BOOL isLastPage = (page == totalPage - 1 ? YES : NO);
    NSUInteger beginIndex = page * TIMStickerPageViewMaxEmojiCount;
    NSUInteger length = (isLastPage ? (sticker.emojis.count - page * TIMStickerPageViewMaxEmojiCount) : TIMStickerPageViewMaxEmojiCount);
    NSArray *emojis = [sticker.emojis subarrayWithRange:NSMakeRange(beginIndex, length)];
    return emojis;
}

- (UIImage *)emojiImageWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }

    UIImage *image = [UIImage imageNamed:[@"TIMOEmoji.bundle" stringByAppendingPathComponent:name]];
    return image;
}

- (void)didLongPressEmoji:(UILongPressGestureRecognizer *)recognizer
{
    if (!self.emojiButtons || !self.emojiButtons.count) {
        return;
    }

    NSArray<BIMEmoji *> *emojis = [self emojisForSticker:self.sticker atPage:self.pageIndex];
    if (!emojis || !emojis.count) {
        return;
    }
}


@end
