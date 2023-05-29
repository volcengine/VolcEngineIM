//
//  VEIMDemoConversationSettingCell.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoConversationSettingCell.h"
#import "VEIMDemoDefine.h"

@implementation VEIMDemoConversationSettingCell

- (void)setupUIElemets{
    [super setupUIElemets];
    self.settingTitle = [UILabel new];
    self.settingTitle.font = kFont(18);
    self.settingTitle.textColor = kIM_Main_Color;
    [self.contentView addSubview:self.settingTitle];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.textColor = kIM_Sub_Color;
    self.detailLabel.font = kFont(16);
    [self.contentView addSubview:self.detailLabel];
    
    self.arrow = [UIImageView new];
    self.arrow.image = [UIImage imageNamed:@"icon_detail"];
    [self.contentView addSubview:self.arrow];
    
    self.swt = [[UISwitch alloc] init];
    [self.swt addTarget:self action:@selector(swt:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.swt];
}

- (void)swt: (UISwitch *)swt{
    if (self.model.switchHandler) {
        self.model.switchHandler(swt);
    }
}

- (void)setModel:(VEIMDemoSettingModel *)model{
    _model = model;
    
    self.settingTitle.text = model.title;
    self.detailLabel.text = model.detail;
    
    if (model.isNeedSwitch) {
        self.arrow.hidden = YES;
        self.swt.hidden = NO;
        
        self.swt.on = model.switchOn;
    }else{
        self.arrow.hidden = NO;
        self.swt.hidden = YES;
    }
}

- (void)setupConstraints{
    [super setupConstraints];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.settingTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.model.isNeedSwitch) {
            make.right.equalTo(self.swt.mas_left).offset(-8);
        }else{
            make.right.equalTo(self.arrow.mas_left).offset(-8);
        }
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(180);
    }];
    
    [self.arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
    
    [self.swt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
}

@end
