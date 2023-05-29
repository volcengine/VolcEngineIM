//
//  MenuCollectionViewCell.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/26.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMChatMenuCollectionViewCell.h"
#import "BIMUIDefine.h"

#import <Masonry/Masonry.h>


@interface BIMChatMenuCollectionViewCell ()


@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation BIMChatMenuCollectionViewCell

- (void)loadData:(BIMChatMenuItemModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.iconImgView.image = kIMAGE_IN_BUNDLE_NAMED(model.iconStr);
    self.titleLabel.text = model.titleStr;
}


#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.titleLabel];

        [self makeSubViewsConstraints];
    }

    return self;
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
        _titleLabel.textColor = kRGBCOLOR(34, 34, 34, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont(12);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }

    return _titleLabel;
}


#pragma mark - 约束布局

- (void)makeSubViewsConstraints
{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(7);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

@end
