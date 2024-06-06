//
//  VEIMDemoMediaCollectionViewCell.m
//  ByteBusiness
//
//  Created by ByteDance on 2024/5/22.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoMediaCollectionViewCell.h"
#import <im-uikit-tob/BIMUIDefine.h>
#import <Masonry/Masonry.h>

@implementation VEIMDemoMediaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageContent];
        
        self.playBtn = [UIImageView new];
        [self.contentView addSubview:self.playBtn];
        [self.playBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_play")];
        self.playBtn.hidden = YES;
        [self setupConstraints];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor clearColor];
}

- (UIImageView *)imageContent
{
    if (!_imageContent) {
        UIImageView *imageContent = [UIImageView new];
        imageContent.contentMode = UIViewContentModeScaleAspectFill;

        _imageContent = imageContent;
    }
    
    return _imageContent;
}

- (void)setupConstraints
{
    self.imageContent.clipsToBounds = YES;
    [self.imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageContent);
        make.width.height.mas_equalTo(20);
    }];
}

@end
