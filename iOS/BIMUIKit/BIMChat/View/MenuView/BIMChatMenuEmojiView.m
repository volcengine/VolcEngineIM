//
//  MenuEmojiView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/26.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMChatMenuEmojiView.h"
#import "BIMStickerPageView.h"
#import "BIMUIDefine.h"
#import "BIMStickerDataManager.h"

static CGFloat const TIMStickerTopInset = 12.0;
static CGFloat const TIMStickerScrollViewHeight = 132.0;
static CGFloat const TIMKeyboardPageControlTopMargin = 10.0;
static CGFloat const TIMKeyboardPageControlHeight = 7.0;
static CGFloat const TIMKeyboardPageControlBottomMargin = 6.0;

static NSString *const TIMStickerPageViewReuseID = @"TIMStickerPageView";


@interface BIMChatMenuEmojiView () <BIMStickerPageViewDelegate, BIMQueuingScrollViewDelegate, UIInputViewAudioFeedback>
@property (nonatomic, strong) NSArray<BIMSticker *> *stickers;
@property (nonatomic, strong) BIMQueuingScrollView *queuingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray<BIMSlideLineButton *> *stickerCoverButtons;


@property (nonatomic, assign) NSInteger currentStickerIndex;

@end


@implementation BIMChatMenuEmojiView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.currentStickerIndex = 0;
        self.stickers = [BIMStickerDataManager sharedInstance].allStickers.copy;

        self.backgroundColor = kWhiteColor;
        [self addSubview:self.queuingScrollView];
        [self addSubview:self.pageControl];

        [self changeStickerToIndex:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.currentStickerIndex = 0;
        self.stickers = [BIMStickerDataManager sharedInstance].allStickers.copy;

        self.backgroundColor = kWhiteColor;
        [self addSubview:self.queuingScrollView];
        [self addSubview:self.pageControl];

        [self changeStickerToIndex:0];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.queuingScrollView.contentSize = CGSizeMake([self numberOfPageForSticker:[self stickerAtIndex:_currentStickerIndex]] * CGRectGetWidth(self.bounds), TIMStickerScrollViewHeight);
    self.queuingScrollView.frame = CGRectMake(0, TIMStickerTopInset, CGRectGetWidth(self.bounds), TIMStickerScrollViewHeight);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.queuingScrollView.frame) + TIMKeyboardPageControlTopMargin, CGRectGetWidth(self.bounds), TIMKeyboardPageControlHeight);

    [self reloadScrollableSegment];
}

- (CGFloat)heightThatFits
{
    return TIMStickerTopInset + TIMStickerScrollViewHeight + TIMKeyboardPageControlTopMargin + TIMKeyboardPageControlHeight + TIMKeyboardPageControlBottomMargin;
}

#pragma mark - getter / setter

- (BIMQueuingScrollView *)queuingScrollView
{
    if (!_queuingScrollView) {
        _queuingScrollView = [[BIMQueuingScrollView alloc] init];
        _queuingScrollView.delegate = self;
        _queuingScrollView.pagePadding = 0;
        _queuingScrollView.alwaysBounceHorizontal = NO;
    }
    return _queuingScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:245.0 / 255.0 green:166.0 / 255.0 blue:35.0 / 255.0 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:188.0 / 255.0 green:188.0 / 255.0 blue:188.0 / 255.0 alpha:1.0];
    }
    return _pageControl;
}

#pragma mark - private method

- (BIMSticker *)stickerAtIndex:(NSUInteger)index
{
    if (self.stickers && index < self.stickers.count) {
        return self.stickers[index];
    }
    return nil;
}

- (NSUInteger)numberOfPageForSticker:(BIMSticker *)sticker
{
    if (!sticker) {
        return 0;
    }

    NSUInteger numberOfPage = (sticker.emojis.count / TIMStickerPageViewMaxEmojiCount) + ((sticker.emojis.count % TIMStickerPageViewMaxEmojiCount == 0) ? 0 : 1);
    return numberOfPage;
}

- (void)reloadScrollableSegment
{
    for (UIButton *button in self.stickerCoverButtons) {
        [button removeFromSuperview];
    }
    self.stickerCoverButtons = nil;

    if (!self.stickers || !self.stickers.count) {
        return;
    }

    NSMutableArray *stickerCoverButtons = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0, max = self.stickers.count; index < max; index++) {
        BIMSticker *sticker = self.stickers[index];
        if (!sticker) {
            return;
        }
    }
    self.stickerCoverButtons = stickerCoverButtons;
}

- (UIImage *)emojiImageWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }

    return [UIImage imageNamed:[@"TIMOEmoji.bundle" stringByAppendingPathComponent:name]];
}

- (void)changeStickerToIndex:(NSUInteger)toIndex
{
    if (toIndex >= self.stickers.count) {
        return;
    }

    BIMSticker *sticker = [self stickerAtIndex:toIndex];
    if (!sticker) {
        return;
    }

    _currentStickerIndex = toIndex;

    BIMStickerPageView *pageView = [self queuingScrollView:self.queuingScrollView pageViewForStickerAtIndex:0];
    [self.queuingScrollView displayView:pageView];

    [self reloadScrollableSegment];
}


#pragma mark - target / action

- (void)changeSticker:(UIButton *)button
{
    [self changeStickerToIndex:button.tag];
}


#pragma mark - TIMQueuingScrollViewDelegate

- (void)queuingScrollViewChangedFocusView:(BIMQueuingScrollView *)queuingScrollView previousFocusView:(UIView *)previousFocusView
{
    BIMStickerPageView *currentView = (BIMStickerPageView *)self.queuingScrollView.focusView;
    self.pageControl.currentPage = currentView.pageIndex;
}

- (UIView<BIMReusablePage> *)queuingScrollView:(BIMQueuingScrollView *)queuingScrollView viewBeforeView:(UIView *)view
{
    return [self queuingScrollView:queuingScrollView pageViewForStickerAtIndex:((BIMStickerPageView *)view).pageIndex - 1];
}

- (UIView<BIMReusablePage> *)queuingScrollView:(BIMQueuingScrollView *)queuingScrollView viewAfterView:(UIView *)view
{
    return [self queuingScrollView:queuingScrollView pageViewForStickerAtIndex:((BIMStickerPageView *)view).pageIndex + 1];
}

- (BIMStickerPageView *)queuingScrollView:(BIMQueuingScrollView *)queuingScrollView pageViewForStickerAtIndex:(NSUInteger)index
{
    BIMSticker *sticker = [self stickerAtIndex:_currentStickerIndex];
    if (!sticker) {
        return nil;
    }

    NSUInteger numberOfPages = [self numberOfPageForSticker:sticker];
    self.pageControl.numberOfPages = numberOfPages;
    if (index >= numberOfPages) {
        return nil;
    }

    BIMStickerPageView *pageView = [queuingScrollView reusableViewWithIdentifer:TIMStickerPageViewReuseID];
    if (!pageView) {
        pageView = [[BIMStickerPageView alloc] initWithReuseIdentifier:TIMStickerPageViewReuseID];
        pageView.delegate = self;
    }
    pageView.pageIndex = index;
    pageView.buttonType = BIMStickerButtonTypeClose;
    [pageView configureWithSticker:sticker];
    return pageView;
}


#pragma mark - TIMStickerPageViewDelegate

- (void)stickerPageView:(BIMStickerPageView *)stickerPageView didClickEmoji:(BIMEmoji *)emoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuEmojiViewDidClickEmoji:)]) {
        [self.delegate menuEmojiViewDidClickEmoji:emoji];
    }
}

- (void)stickerPageViewDidClickCloseButton:(BIMStickerPageView *)stickerPageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuEmojiViewDidClickCloseButton)]) {
        [self.delegate menuEmojiViewDidClickCloseButton];
    }
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}


@end
