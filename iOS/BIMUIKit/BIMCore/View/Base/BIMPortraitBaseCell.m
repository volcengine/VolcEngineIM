//
//  BIMPortraitBaseCell.m
//  
//
//  Created by Weibai on 2022/11/1.
//

#import "BIMPortraitBaseCell.h"
#import "BIMUIDefine.h"
#import <Masonry/Masonry.h>

@implementation BIMPortraitBaseCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.portrait = [UIImageView new];
    [self.contentView addSubview:self.portrait];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = kIM_Sub_Color;
    [self.contentView addSubview:self.subTitleLabel];
    
//    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel);
//        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
//        make.right.mas_equalTo(-60);
//    }];
}

- (void)setupConstraints{
    [super setupConstraints];
    
    CGFloat portraitWH = 45;
    self.portrait.layer.cornerRadius = portraitWH*0.5;
    self.portrait.clipsToBounds = YES;
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(portraitWH);
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(24);
        make.bottom.mas_equalTo(-12);
    }];
    
    if (self.subTitleLabel.text.length) {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).with.offset(12);
            make.top.mas_equalTo(12);
        }];
        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
            make.right.mas_equalTo(-60);
        }];
    }else{
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).with.offset(12);
            make.centerY.equalTo(self.portrait);
        }];
    }
    
}

@end
