//
//  VEIMDemoAppInfoCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/6/26.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoAppInfoCell.h"

@interface VEIMDemoAppInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation VEIMDemoAppInfoCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    self.titleLabel = [UILabel new];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:self.titleLabel];
    
    self.infoLabel = [UILabel new];
    [self.infoLabel setTextColor:[UIColor grayColor]];
    [self.infoLabel setFont:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:self.infoLabel];
}

- (void)setupConstraints
{
    [super setupConstraints];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
    }];
    
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        } else {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        }
        
    }];
}

- (void)configCellWithTitle:(NSString *)title info:(NSString *)info
{
    [self.titleLabel setText:title];
    [self.infoLabel setText:info];

    [self setupConstraints];
}

@end
