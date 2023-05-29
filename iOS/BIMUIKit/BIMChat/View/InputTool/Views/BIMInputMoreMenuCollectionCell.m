//
//InputMoreMenuCollectionCell.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/18.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMInputMoreMenuCollectionCell.h"
#import "BIMUIDefine.h"

#import <Masonry/Masonry.h>


@interface BIMInputMoreMenuCollectionCell ()
@property (nonatomic, strong) UIView *iconBgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation BIMInputMoreMenuCollectionCell

- (void)loadData:(BIMInputMenuModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.iconImgView.image = kIMAGE_IN_BUNDLE_NAMED(model.iconStr);
    self.titleLabel.text = model.titleStr;
}


#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconBgView];
        [self.iconBgView addSubview:self.iconImgView];
        [self.contentView addSubview:self.titleLabel];

        [self makeSubViewsConstraints];
    }

    return self;
}

- (UIView *)iconBgView
{
    if (!_iconBgView) {
        _iconBgView = [[UIView alloc] init];
        _iconBgView.backgroundColor = kWhiteColor;

        kViewBorderRadius(_iconBgView, 6, 0.5, kIM_Line_Color)
    }

    return _iconBgView;
}

- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _iconImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kRGBCOLOR(85, 85, 85, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont(12);
    }

    return _titleLabel;
}


#pragma mark - 约束布局

- (void)makeSubViewsConstraints
{
    [self.iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.iconBgView.mas_width);
    }];

    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.center.mas_equalTo(0);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconBgView.mas_bottom).offset(8);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

@end
