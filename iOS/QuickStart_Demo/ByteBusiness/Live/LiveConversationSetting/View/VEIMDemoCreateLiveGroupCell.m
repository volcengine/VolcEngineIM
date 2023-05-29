//
//  VEIMDemoCreateLiveGroupCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoCreateLiveGroupCell.h"

@implementation VEIMDemoCreateLiveGroupCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupConstraints
{
    [super setupConstraints];
    
}

- (void)setupCellLayoutWithStyle:(VEIMDemoCreateLiveGroupCellStyle)style
{
    // 设置项名
    [self.contentView addSubview:self.settingTitle];
    [self.settingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(24);
        make.bottom.mas_equalTo(-12);
    }];
    
    // arrow图片
    [self.contentView addSubview:self.arrow];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-24);
    }];
    
    if (style == VEIMDemoLiveGroupSettingCellStyle1) {
        return;
    } else if (style == VEIMDemoLiveGroupSettingCellStyle2) {
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrow);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.frame.size.width/2 - self.arrow.frame.size.width - 24);
        }];
//    } else if (style == VEIMDemoLiveGroupSettingCellStyle3) {
//        [self.contentView addSubview:self.groupAvatar];
//        [self.groupAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.arrow);
//            make.centerY.mas_equalTo(self.contentView);
//            make.width.height.mas_equalTo(self.contentView.frame.size.height * 2 / 3);
//        }];
    }
}

#pragma mark - Getter

- (UILabel *)settingTitle
{
    if (!_settingTitle) {
        _settingTitle = [[UILabel alloc] init];
    }
    return _settingTitle;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
    }
    return _detailLabel;
}

- (UIImageView *)arrow
{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        [_arrow setImage:[UIImage imageNamed:@"icon_detail"]];
    }
    return _arrow;
}

- (UIImageView *)groupAvatar
{
    if (!_groupAvatar) {
        _groupAvatar = [[UIImageView alloc] init];
    }
    return _groupAvatar;
}


@end
