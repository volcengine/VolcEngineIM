//
//ChatMenuViewNew.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/16.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMChatMenuViewNew.h"
#import "BIMUIDefine.h"
#import "BIMChatMenuEmojiView.h"

#import <imsdk-tob/BIMSDK.h>
#import <im-uikit-tob/BIMStickerDataManager.h>

@interface BIMChatMenuViewNew () <BIMChatMenuCollectionViewDelegate, BIMChatMenuEmojiViewDelegate>
@property (nonatomic, strong) UIButton *bg;
@property (nonatomic, strong) BIMChatMenuCollectionView *collectionView;

@property (nonatomic, strong) BIMChatMenuEmojiView *emojiView;

@property (nonatomic, strong) UIView *bottomEmojiView;
@property (nonatomic, strong) UIButton *moreEmojiBtn;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) BIMMessage *message;

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, weak) BIMSticker *sticker;
@end


@implementation BIMChatMenuViewNew
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (void)showItems:(NSMutableArray<BIMChatMenuItemModel *> *)items onView:(nonnull UIView *)view referView:(UIView *)referView message: (BIMMessage *)message{
    if (!self.hidden) {
        return;
    }
    self.hidden = NO;
    self.message = message;
    
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    
    if (!self.bg) {
        self.bg = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bg addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.bg];
    CGRect convertedFrame = [view.superview convertRect:view.frame toView:kAppWindow];
    CGFloat menuY = CGRectGetMaxY(convertedFrame)+6;
//    CGFloat menuBottomHeight = 52;
    CGFloat menuBottomHeight = 0;
    CGFloat menuTopHeight = items.count > 7?121:121-45;
    BOOL showingDownward;
    if (referView) {
        CGRect referViewFrame = [referView.superview convertRect:referView.frame toView:kAppWindow];
        CGFloat referViewMinY = CGRectGetMinY(referViewFrame);
        showingDownward = menuY + menuTopHeight + menuBottomHeight >= referViewMinY;
    } else {
        showingDownward = menuY + menuTopHeight + menuBottomHeight >= kAppWindow.bounds.size.height - 120;
    }
    if (showingDownward) {
        menuY = convertedFrame.origin.y - 6 - menuTopHeight - menuBottomHeight;
    }
    
    self.frame = kAppWindow.bounds;
    self.bg.frame = self.bounds;
    [kAppWindow addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    self.items = items;
    if (!self.collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowlayout.itemSize = CGSizeMake(40, 40);
        flowlayout.minimumInteritemSpacing = ((KScreenWidth - 32) - 7 * 40)/6.0;
        flowlayout.minimumLineSpacing = 16;
        flowlayout.sectionInset = UIEdgeInsetsMake(15, 16, 0, 15);
        self.collectionView = [[BIMChatMenuCollectionView alloc] initWithFrame:CGRectMake(16, menuY, KScreenWidth - 32, menuTopHeight) collectionViewLayout:flowlayout];
        self.collectionView.menuDelegate = self;
    }
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(16, menuY, KScreenWidth - 32, menuTopHeight);
    self.collectionView.listMAry = items;
    [self.collectionView reloadData];
    
    if (message.serverMessageID) {
        [[BIMClient sharedInstance] getConversation:message.conversationID completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
            if (conversation && conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
                [self showEmojiViewWithShowingDownward:showingDownward];
            }
        }];
    }
}

- (void)refreshMessage:(BIMMessage *)message{
    self.message = message;
}

- (void)moreEmojiBtnClicked: (id)sender{
    self.emojiView.hidden = NO;
}

- (void)clickEmojiAction: (UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(menuView:didClickEmoji:message:)]) {
        NSArray *ary = self.sticker.emojis;
        if (ary.count > 0 && (ary.count > btn.tag)) {
            BIMEmoji *emoji = ary[btn.tag];
            [self.delegate menuView:self didClickEmoji:emoji message:self.message];
        }
    }
    [self dismiss];
}

- (void)dismiss{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(menuView:didClickType:message:)]) {
        BIMChatMenuItemModel *item = [self.items objectAtIndex:indexPath.row];
        [self.delegate menuView:self didClickType:item.type message:self.message];
    }
    [self dismiss];
}

- (UIImage *)emojiImageWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }

    return [UIImage imageNamed:[@"TIMOEmojiNew.bundle" stringByAppendingPathComponent:name]];
}

- (void)menuEmojiViewDidClickEmoji:(BIMEmoji *)emoji{
    if ([self.delegate respondsToSelector:@selector(menuView:didClickEmoji:message:)]) {
        [self.delegate menuView:self didClickEmoji:emoji message:self.message];
    }
    self.emojiView.hidden = YES;
    [self dismiss];
}

- (void)menuEmojiViewDidClickCloseButton{
    self.emojiView.hidden = YES;
}

#pragma mark - Private

- (void)showEmojiViewWithShowingDownward:(BOOL)showingDownward
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.collectionView.frame.origin.x, CGRectGetMaxY(self.collectionView.frame), self.collectionView.bounds.size.width - 2 * 16, 1)];
    lineView.backgroundColor = kRGBCOLOR(232, 232, 232, 1);
    [self addSubview:lineView];

    if (!self.bottomEmojiView) {
        self.bottomEmojiView = [[UIView alloc] init];
        self.bottomEmojiView.backgroundColor = [UIColor whiteColor];
    }
    self.bottomEmojiView.frame = CGRectMake(self.collectionView.frame.origin.x, CGRectGetMaxY(lineView.frame), self.collectionView.bounds.size.width, 52);
    [self addSubview:self.bottomEmojiView];


    NSArray *allStickers = [[BIMStickerDataManager sharedInstance].allStickers copy];
    self.sticker = allStickers.firstObject;
    NSArray *emojis = self.sticker.emojis;
    NSUInteger maxBottomEmojis = 6;
    if (emojis.count > 6) {
        maxBottomEmojis = 6;
    } else {
        maxBottomEmojis = emojis.count;
    }

    if (!self.moreEmojiBtn) {
        self.moreEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreEmojiBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_add") forState:UIControlStateNormal];
        [self.moreEmojiBtn addTarget:self action:@selector(moreEmojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.bottomEmojiView addSubview:self.moreEmojiBtn];

    // 把+按钮增加上
    CGFloat emojiButtonWH = 32;
    CGFloat margin = (self.bounds.size.width - (maxBottomEmojis + 1) * emojiButtonWH) / (maxBottomEmojis + 2);

    for (NSUInteger emojiIndex = 0; emojiIndex < maxBottomEmojis; emojiIndex++) {
        BIMEmoji *emoji = emojis[emojiIndex];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin + (margin + emojiButtonWH) * emojiIndex, (self.bottomEmojiView.bounds.size.height - emojiButtonWH) * 0.5, emojiButtonWH, emojiButtonWH);
        UIImage *btnImage = [self emojiImageWithName:emoji.imageName];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = emojiIndex;
        [self.bottomEmojiView addSubview:btn];
    }
    self.moreEmojiBtn.frame = CGRectMake(self.bottomEmojiView.bounds.size.width - 16 - 20, (self.bottomEmojiView.bounds.size.height - 20) * 0.5, 20, 20);

    self.emojiView = [[BIMChatMenuEmojiView alloc] init];
    CGFloat emojiHeight = [self.emojiView heightThatFits];
    self.emojiView.frame = CGRectMake(16, showingDownward?CGRectGetMaxY(self.bottomEmojiView.frame) - emojiHeight:self.collectionView.frame.origin.y, self.collectionView.bounds.size.width, emojiHeight);
    self.emojiView.hidden = YES;
    self.emojiView.delegate = self;
    [self addSubview:self.emojiView];
}

@end
