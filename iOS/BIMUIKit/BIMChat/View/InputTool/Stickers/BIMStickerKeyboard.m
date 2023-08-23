//
//  TIMStickerKeyboard.m
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/14.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import "BIMStickerKeyboard.h"
#import "BIMStickerPageView.h"
#import "BIMStickerDataManager.h"
#import "BIMUIDefine.h"
static CGFloat const TIMStickerTopInset = 12.0;
static CGFloat const TIMStickerScrollViewHeight = 132.0;
static CGFloat const TIMKeyboardPageControlTopMargin = 10.0;
static CGFloat const TIMKeyboardPageControlHeight = 7.0;
static CGFloat const TIMKeyboardPageControlBottomMargin = 6.0;
static CGFloat const TIMKeyboardCoverButtonWidth = 50.0;
static CGFloat const TIMKeyboardCoverButtonHeight = 44.0;


static NSString *const TIMStickerPageViewReuseID = @"TIMStickerPageView";


@interface BIMStickerKeyboard () <BIMStickerPageViewDelegate, BIMQueuingScrollViewDelegate, UIInputViewAudioFeedback>
@property (nonatomic, strong) NSArray<BIMSticker *> *stickers;
@property (nonatomic, strong) BIMQueuingScrollView *queuingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray<BIMSlideLineButton *> *stickerCoverButtons;
@property (nonatomic, strong) BIMSlideLineButton *sendButton;
@property (nonatomic, strong) UIScrollView *bottomScrollableSegment;
@property (nonatomic, strong) UIView *bottomBGView;

@end


@implementation BIMStickerKeyboard
{
    NSUInteger _currentStickerIndex;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentStickerIndex = 0;
        _stickers = [BIMStickerDataManager sharedInstance].allStickers.copy;

        self.backgroundColor = [UIColor colorWithRed:244.0 / 255.0 green:244.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
        [self addSubview:self.queuingScrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.bottomBGView];
        [self addSubview:self.sendButton];
        [self addSubview:self.bottomScrollableSegment];

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

    self.bottomScrollableSegment.contentSize = CGSizeMake(self.stickerCoverButtons.count * TIMKeyboardCoverButtonWidth, TIMKeyboardCoverButtonHeight);
    if (@available(iOS 11.0, *)) {
        self.bottomScrollableSegment.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - TIMKeyboardCoverButtonHeight - self.safeAreaInsets.bottom, CGRectGetWidth(self.bounds) - TIMKeyboardCoverButtonWidth, TIMKeyboardCoverButtonHeight);
    } else {
        self.bottomScrollableSegment.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - TIMKeyboardCoverButtonHeight - UIEdgeInsetsZero.bottom, CGRectGetWidth(self.bounds) - TIMKeyboardCoverButtonWidth, TIMKeyboardCoverButtonHeight);
    }
    [self reloadScrollableSegment];

    self.sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - TIMKeyboardCoverButtonWidth, CGRectGetMinY(self.bottomScrollableSegment.frame), TIMKeyboardCoverButtonWidth, TIMKeyboardCoverButtonHeight);
    if (@available(iOS 11.0, *)) {
        self.bottomBGView.frame = CGRectMake(0, CGRectGetMinY(self.bottomScrollableSegment.frame), CGRectGetWidth(self.frame), TIMKeyboardCoverButtonHeight + self.safeAreaInsets.bottom);
    } else {
        self.bottomBGView.frame = CGRectMake(0, CGRectGetMinY(self.bottomScrollableSegment.frame), CGRectGetWidth(self.frame), TIMKeyboardCoverButtonHeight + UIEdgeInsetsZero.bottom);
    }
}

- (CGFloat)heightThatFits
{
    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
//        bottomInset = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    return TIMStickerTopInset + TIMStickerScrollViewHeight + TIMKeyboardPageControlTopMargin + TIMKeyboardPageControlHeight + TIMKeyboardPageControlBottomMargin + TIMKeyboardCoverButtonHeight + bottomInset;
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

- (BIMSlideLineButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[BIMSlideLineButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithRed:33.0 / 255.0 green:150.0 / 255.0 blue:243.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _sendButton.linePosition = BIMSlideLineButtonPositionLeft;
        _sendButton.lineColor = [UIColor colorWithRed:209.0 / 255.0 green:209.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIScrollView *)bottomScrollableSegment
{
    if (!_bottomScrollableSegment) {
        _bottomScrollableSegment = [[UIScrollView alloc] init];
        _bottomScrollableSegment.showsHorizontalScrollIndicator = NO;
        _bottomScrollableSegment.showsVerticalScrollIndicator = NO;
    }
    return _bottomScrollableSegment;
}

- (UIView *)bottomBGView
{
    if (!_bottomBGView) {
        _bottomBGView = [[UIView alloc] init];
        _bottomBGView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBGView;
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

        BIMSlideLineButton *button = [[BIMSlideLineButton alloc] init];
        button.tag = index;
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.linePosition = BIMSlideLineButtonPositionRight;
        button.lineColor = [UIColor colorWithRed:209.0 / 255.0 green:209.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
        button.backgroundColor = (_currentStickerIndex == index ? [UIColor colorWithRed:237 green:237 blue:237 alpha:1.0] : [UIColor clearColor]);
        
        [button setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_input_emoji") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeSticker:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomScrollableSegment addSubview:button];
        [stickerCoverButtons addObject:button];
        button.frame = CGRectMake(index * TIMKeyboardCoverButtonWidth, 0, TIMKeyboardCoverButtonWidth, TIMKeyboardCoverButtonHeight);
    }
    self.stickerCoverButtons = stickerCoverButtons;
}

- (UIImage *)emojiImageWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }

    return [UIImage imageNamed:[@"TIMOEmojiNew.bundle" stringByAppendingPathComponent:name]];
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

- (void)sendAction:(BIMSlideLineButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerKeyboardDidClickSendButton:)]) {
        [self.delegate stickerKeyboardDidClickSendButton:self];
    }
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
    [pageView configureWithSticker:sticker];
    return pageView;
}

#pragma mark - TIMStickerPageViewDelegate

- (void)stickerPageView:(BIMStickerPageView *)stickerPageView didClickEmoji:(BIMEmoji *)emoji
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerKeyboard:didClickEmoji:)]) {
        [[UIDevice currentDevice] playInputClick];
        [self.delegate stickerKeyboard:self didClickEmoji:emoji];
    }
}

- (void)stickerPageViewDidClickDeleteButton:(BIMStickerPageView *)stickerPageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerKeyboardDidClickDeleteButton:)]) {
        [[UIDevice currentDevice] playInputClick];
        [self.delegate stickerKeyboardDidClickDeleteButton:self];
    }
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}


@end
