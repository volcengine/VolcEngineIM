//
//  VEIMDemoSearchResultViewCell.m
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/27.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoSearchResultViewCell.h"
#import <im-uikit-tob/BIMUIDefine.h>

@implementation VEIMDemoSearchResultViewCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = kIM_Sub_Color;
    [self.contentView addSubview:self.dateLabel];
}

- (void)setupConstraints
{
    [super setupConstraints];
    
    CGFloat rightOfNameLabel = 0;
    if (self.nameLabel.text.length) {
        rightOfNameLabel = self.msgType == BIM_MESSAGE_TYPE_TEXT ? -90 : -60;
    }
    
    if (self.subTitleLabel.text.length || self.subTitleLabel.attributedText.length) {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).with.offset(12);
            make.top.mas_equalTo(12);
            make.right.mas_lessThanOrEqualTo(rightOfNameLabel);
        }];
        if (self.msgType == BIM_MESSAGE_TYPE_FILE) {
            [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
                make.right.mas_equalTo(-12);
                make.centerY.equalTo(self.subTitleLabel);
            }];
            
            [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel);
                make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
                make.right.mas_lessThanOrEqualTo(-90);
            }];
        } else {
            [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel);
                make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
                make.right.mas_equalTo(-60);
            }];
        }
    } else {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).with.offset(12);
            make.centerY.equalTo(self.portrait);
            make.right.mas_lessThanOrEqualTo(rightOfNameLabel);
//            make.width.mas_equalTo(120); /// 不指定宽度可能导致名字不展示
        }];
    }
}

@end
