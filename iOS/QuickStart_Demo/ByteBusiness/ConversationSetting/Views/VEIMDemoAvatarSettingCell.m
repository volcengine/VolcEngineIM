//
//  VEIMDemoAvatarSettingCell.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/20.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoAvatarSettingCell.h"
#import "VEIMDemoDefine.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VEIMDemoAvatarSettingCell

- (void)setupUIElemets{
    [super setupUIElemets];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.settingTitle = [UILabel new];
    self.settingTitle.font = kFont(18);
    self.settingTitle.textColor = kIM_Main_Color;
    [self.contentView addSubview:self.settingTitle];
    
    self.arrow = [UIImageView new];
    self.arrow.image = [UIImage imageNamed:@"icon_detail"];
    [self.contentView addSubview:self.arrow];
    
    self.avatarImageView = [UIImageView new];
    [self.contentView addSubview:self.avatarImageView];
}

- (void)setModel:(VEIMDemoAvatarSettingModel *)model{
    _model = model;
    self.settingTitle.text = model.title;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
}

- (void)setupConstraints{
    [super setupConstraints];
    
    [self.settingTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-8);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_lessThanOrEqualTo(60);
    }];
    
    [self.arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
}

@end
