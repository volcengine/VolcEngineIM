//
//  BDIMDebugTableViewCell.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/13.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation BDIMDebugTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:self.titleLabel];
        
        self.descLabel = [UILabel new];
        self.descLabel.font = [UIFont systemFontOfSize:12];
        self.descLabel.numberOfLines = 0;
        self.descLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.descLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
            make.left.equalTo(self.titleLabel);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12);
        }];
        [self.descLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}

- (void)setModel:(id <BDIMDebugModelProtocal>)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

@end
