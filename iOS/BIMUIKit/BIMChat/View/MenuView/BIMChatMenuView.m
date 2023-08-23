//
//  MenuView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/22.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMChatMenuView.h"
#import "BIMChatMenuCollectionView.h"
#import "BIMChatMenuEmojiView.h"
#import "BIMUIDefine.h"


#import <OneKit/ByteDanceKit.h>

#define btnWid 40
#define selfMargin 16
#define selfWid (KScreenWidth - 2 * selfMargin)
#define emojiHei 52
#define emojiButtonWH 32

static NSInteger const menuItemMaxCount = 8;


@interface BIMChatMenuView () <BIMChatMenuCollectionViewDelegate, BIMChatMenuEmojiViewDelegate>

@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) UIView *containerBgView;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) BIMChatMenuCollectionView *tempCollectionView;
@property (nonatomic, strong) UIView *bottomEmojiView;
@property (nonatomic, strong) UIButton *moreEmojiBtn;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) BIMChatMenuEmojiView *emojiView;

@property (nonatomic, strong) NSMutableArray<BIMChatMenuItemModel *> *listMAry;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, strong) BIMSticker *sticker;

@end


@implementation BIMChatMenuView


#pragma mark - BIMChatMenuCollectionViewDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleTap:nil];

    BIMChatMenuItemModel *model = self.listMAry[indexPath.row];

    if (self.delegate && [self.delegate respondsToSelector:@selector(menuViewDidSelectItem:)]) {
        [self.delegate menuViewDidSelectItem:model.type];
    }
}


#pragma mark - MenuEmojiViewDelegate

- (void)menuEmojiViewDidClickEmoji:(BIMEmoji *)emoji
{
    [self handleTap:nil];

    if (self.delegate && [self.delegate respondsToSelector:@selector(menuViewDidSelectEmoji:)]) {
        [self.delegate menuViewDidSelectEmoji:emoji];
    }
}

- (void)menuEmojiViewDidClickCloseButton
{
    self.firstView.hidden = NO;
    self.secondView.hidden = YES;
    self.containerBgView.btd_height = self.firstView.btd_height;
    if (!self.isBottom) {
        self.containerBgView.btd_top += (self.secondView.btd_height - self.firstView.btd_height);
    }
}


#pragma mark - Action

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self.holderView removeFromSuperview];
    [self.containerBgView removeFromSuperview];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPtess
{
    if (self.typesMAry.count > 0) {
        BIMChatShowType type = (BIMChatShowType)[self.typesMAry.firstObject integerValue];
        if (type == BIMChatShowTypeNone) {
            return;
        }
    }

    [kAppWindow addSubview:self.holderView];

    [self setupDefaultView];

    CGRect rect = [self convertRect:self.frame toView:kAppWindow];

    if ((rect.origin.y - self.firstView.btd_height * 2) > (80 + 5)) {
        self.isBottom = NO;
        self.containerBgView.btd_top = rect.origin.y - self.containerBgView.btd_height - self.bottomEmojiView.btd_height;
    } else {
        self.isBottom = YES;
        self.containerBgView.btd_top = rect.origin.y + rect.size.height - self.bottomEmojiView.btd_height + 10;
    }

    [kAppWindow addSubview:self.containerBgView];
}

- (void)showEmojiView:(UIButton *)btn
{
    self.firstView.hidden = YES;
    self.secondView.hidden = NO;
    self.containerBgView.btd_height = self.secondView.btd_height;
    if (!self.isBottom) {
        self.containerBgView.btd_top -= (self.secondView.btd_height - self.firstView.btd_height);
    }
}

- (void)clickEmojiAction:(UIButton *)btn
{
    [self handleTap:nil];

    NSArray *ary = self.sticker.emojis;
    if (ary.count > 0 && (ary.count > btn.tag)) {
        BIMEmoji *emoji = ary[btn.tag];

        if (self.delegate && [self.delegate respondsToSelector:@selector(menuViewDidSelectEmoji:)]) {
            [self.delegate menuViewDidSelectEmoji:emoji];
        }
    }
}


#pragma mark - DATA

- (NSMutableArray<BIMChatMenuItemModel *> *)listMAry
{
    if (!_listMAry) {
        _listMAry = [NSMutableArray array];
    }

    return _listMAry;
}


#pragma mark - LifeCycle

- (instancetype)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.numberOfTouchesRequired = 1;
        longPress.minimumPressDuration = 1.f;
        [self addGestureRecognizer:longPress];

        self.backgroundColor = kWhiteColor;

        kViewBorderRadius(self, 4, 0.5, kRGBCOLOR(232, 232, 232, 1));
    }

    return self;
}

- (void)setupDefaultView
{
    self.firstView.hidden = NO;
    self.secondView.hidden = YES;

    [self setupFirstViews];
    [self setupSecondViews];
}

- (UIView *)holderView
{
    if (!_holderView) {
        _holderView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _holderView.backgroundColor = kClearColor;
        _holderView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_holderView addGestureRecognizer:tap];
    }

    return _holderView;
}

- (UIView *)containerBgView
{
    if (!_containerBgView) {
        _containerBgView = [[UIView alloc] initWithFrame:CGRectMake(selfMargin, 0, selfWid, 0)];
        _containerBgView.backgroundColor = kWhiteColor;
    }

    return _containerBgView;
}

- (UIView *)firstView
{
    if (!_firstView) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerBgView.btd_width, 0)];
        _firstView.backgroundColor = kWhiteColor;
    }

    return _firstView;
}

- (BIMChatMenuCollectionView *)tempCollectionView
{
    if (!_tempCollectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowlayout.itemSize = CGSizeMake(btnWid, 40);
        flowlayout.minimumInteritemSpacing = (self.firstView.btd_width - 15 * 2 - menuItemMaxCount * btnWid) / (menuItemMaxCount - 1);
        flowlayout.minimumLineSpacing = 16;
        flowlayout.sectionInset = UIEdgeInsetsMake(15, 16, 0, 15);

        _tempCollectionView = [[BIMChatMenuCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.firstView.btd_width, 66) collectionViewLayout:flowlayout];
        _tempCollectionView.menuDelegate = self;
    }

    return _tempCollectionView;
}

- (UIView *)bottomEmojiView
{
    if (!_bottomEmojiView) {
        _bottomEmojiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.firstView.btd_width, emojiHei)];
        _bottomEmojiView.backgroundColor = kWhiteColor;
    }

    return _bottomEmojiView;
}

- (UIButton *)moreEmojiBtn
{
    if (!_moreEmojiBtn) {
        _moreEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreEmojiBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_add") forState:UIControlStateNormal];
        [_moreEmojiBtn addTarget:self action:@selector(showEmojiView:) forControlEvents:UIControlEventTouchUpInside];
        _moreEmojiBtn.frame = CGRectMake(self.bottomEmojiView.btd_width - 16 - 20, 0, 20, 20);
        _moreEmojiBtn.btd_centerY = self.bottomEmojiView.btd_height / 2;
    }

    return _moreEmojiBtn;
}

- (UIView *)secondView
{
    if (!_secondView) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWid, 0)];
        _secondView.backgroundColor = kWhiteColor;
        _secondView.hidden = YES;
    }

    return _secondView;
}

- (BIMChatMenuEmojiView *)emojiView
{
    if (!_emojiView) {
        _emojiView = [[BIMChatMenuEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.secondView.btd_width, 0)];
        _emojiView.delegate = self;
    }

    return _emojiView;
}

- (void)setupFirstViews
{
    [self.containerBgView addSubview:self.firstView];
    [self.firstView addSubview:self.tempCollectionView];
    [self.firstView addSubview:self.bottomEmojiView];

    BIMChatMenuItemModel *copyModel = [[BIMChatMenuItemModel alloc] init];
    copyModel.type = BIMChatMenuTypeCopy;
    copyModel.titleStr = @"复制";
    copyModel.iconStr = @"icon_copy";

    BIMChatMenuItemModel *delModel = [[BIMChatMenuItemModel alloc] init];
    delModel.type = BIMChatMenuTypeDel;
    delModel.titleStr = @"删除";
    delModel.iconStr = @"icon_del";

    BIMChatMenuItemModel *forceDelItem = [[BIMChatMenuItemModel alloc] init];
    forceDelItem.type = BIMChatMenuTypeForceDel;
    forceDelItem.titleStr = @"强删";
    forceDelItem.iconStr = @"icon_del";

    BIMChatMenuItemModel *recallModel = [[BIMChatMenuItemModel alloc] init];
    recallModel.type = BIMChatMenuTypeRecall;
    recallModel.titleStr = @"撤回";
    recallModel.iconStr = @"icon_recall";

    BIMChatMenuItemModel *readReceiptModel = [[BIMChatMenuItemModel alloc] init];
    readReceiptModel.type = BIMChatMenuTypeReadReceipt;
    readReceiptModel.titleStr = @"已读";
    readReceiptModel.iconStr = @"icon_menu_read";

    BIMChatMenuItemModel *referItemModel = [[BIMChatMenuItemModel alloc] init];
    referItemModel.type = BIMChatMenuTypeReferMessage;
    referItemModel.titleStr = @"引用";
    referItemModel.iconStr = @"icon_menu_read";

    BIMChatMenuItemModel *pinModel = [[BIMChatMenuItemModel alloc] init];
    pinModel.type = BIMChatMenuTypePin;
    pinModel.titleStr = @"Pin";
    pinModel.iconStr = @"icon_menu_pin";

    BIMChatMenuItemModel *unpinModel = [[BIMChatMenuItemModel alloc] init];
    unpinModel.type = BIMChatMenuTypeUnPin;
    unpinModel.titleStr = @"Un-pin";
    unpinModel.iconStr = @"icon_menu_pin";

    BIMChatMenuItemModel *pinTagModel = [[BIMChatMenuItemModel alloc] init];
    pinTagModel.type = BIMChatMenuTypePinTag;
    pinTagModel.titleStr = @"PinTag";
    pinTagModel.iconStr = @"icon_menu_pin";

    BIMChatMenuItemModel *favModel = [[BIMChatMenuItemModel alloc] init];
    favModel.type = BIMChatMenuTypeFavorite;
    favModel.titleStr = @"收藏";
    favModel.iconStr = @"icon_menu_star";

    BIMChatMenuItemModel *markUneadModel = [[BIMChatMenuItemModel alloc] init];
    markUneadModel.type = BIMChatMenuTypeMarkUnRead;
    markUneadModel.titleStr = @"标记未读";
    markUneadModel.iconStr = @"icon_menu_markunread";

    BIMChatMenuItemModel *markReadModel = [[BIMChatMenuItemModel alloc] init];
    markReadModel.type = BIMChatMenuTypeMarkRead;
    markReadModel.titleStr = @"标记已读";
    markReadModel.iconStr = @"icon_menu_markread";

    BIMChatMenuItemModel *debugModel = [[BIMChatMenuItemModel alloc] init];
    debugModel.type = BIMChatMenuTypeDebug;
    debugModel.titleStr = @"调试";
    debugModel.iconStr = @"icon_menu_read";

    NSMutableArray *mAry = [NSMutableArray arrayWithArray:@[ copyModel, delModel, forceDelItem, recallModel, readReceiptModel, referItemModel, pinModel, unpinModel, pinTagModel, favModel, markUneadModel, markReadModel, debugModel ]];

    for (NSNumber *tp in self.typesMAry) {
        BIMChatShowType type = (BIMChatShowType)[tp integerValue];

        switch (type) {
            case BIMChatShowTypeNone: {
                [mAry removeAllObjects];
            } break;

            case BIMChatShowTypeNormal: {
            } break;

            case BIMChatShowTypeNoCopy: {
                [mAry removeObject:copyModel];
            } break;

            case BIMChatShowTypeNoReadReceipt: {
                [mAry removeObject:readReceiptModel];
            } break;

            case BIMChatShowTypeNoRecall: {
                [mAry removeObject:recallModel];
            } break;
            case BIMChatShowTypeNoPin: {
                [mAry removeObject:pinModel];
                [mAry removeObject:pinTagModel];
            } break;
            case BIMChatShowTypeNoUnPin: {
                [mAry removeObject:unpinModel];
            } break;
            case BIMChatShowTypeNoMarkUnRead: {
                [mAry removeObject:markUneadModel];
            } break;
            case BIMChatShowTypeNoMarkRead: {
                [mAry removeObject:markReadModel];
            } break;

            default:
                break;
        }
    }

    self.listMAry = [mAry copy];

    self.tempCollectionView.listMAry = self.listMAry;
    self.tempCollectionView.btd_height = self.tempCollectionView.collectionViewLayout.collectionViewContentSize.height + 10;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, self.tempCollectionView.btd_bottom, self.tempCollectionView.btd_width - 2 * 16, 1)];
    lineView.backgroundColor = kRGBCOLOR(232, 232, 232, 1);
    [self.firstView addSubview:lineView];

    self.bottomEmojiView.btd_top = lineView.btd_bottom;

    NSArray *allStickers = [[BIMStickerDataManager sharedInstance].allStickers copy];
    self.sticker = allStickers.firstObject;
    NSArray *ary = self.sticker.emojis;
    int max = 6;
    if (ary.count > 6) {
        max = 6;
    } else {
        max = (int)ary.count;
    }

    // 把+按钮增加上
    max += 1;

    CGFloat margin = (self.firstView.btd_width - max * emojiButtonWH) / (max + 1);

    for (int i = 0; i < max; i++) {
        if (i == (max - 1)) {
            [self.bottomEmojiView addSubview:self.moreEmojiBtn];
            break;
        } else {
            BIMEmoji *emoji = ary[i];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(margin + (margin + emojiButtonWH) * i, 0, emojiButtonWH, emojiButtonWH);
            btn.btd_centerY = self.bottomEmojiView.btd_height / 2;
            [btn setImage:[self emojiImageWithName:emoji.imageName] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self.bottomEmojiView addSubview:btn];
        }
    }

    self.firstView.btd_height = self.bottomEmojiView.btd_bottom;
    self.containerBgView.btd_height = self.firstView.btd_height;
}

- (void)setupSecondViews
{
    [self.containerBgView addSubview:self.secondView];
    [self.secondView addSubview:self.emojiView];
    self.emojiView.btd_height = [self.emojiView heightThatFits];
    self.secondView.btd_height = self.emojiView.btd_bottom;
}

- (UIImage *)emojiImageWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }

    return [UIImage imageNamed:[@"TIMOEmojiNew.bundle" stringByAppendingPathComponent:name]];
}

@end
