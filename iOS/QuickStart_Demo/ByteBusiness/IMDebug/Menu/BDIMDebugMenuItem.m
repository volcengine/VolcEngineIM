//
//  BDIMDebugMenuItem.m
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugMenuItem.h"
#import <Masonry/Masonry.h>

@interface BDIMDebugMenuItem ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *descriptionL;
@property (nonatomic, copy) void(^click)(void);


@end

@implementation BDIMDebugMenuItem

+ (instancetype)itemWithModel:(BDIMDebugMenuIconModel *)model{
    BDIMDebugMenuItem *item = [BDIMDebugMenuItem new];
    item.model = model;
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [UILabel new];
        self.titleL.font = [UIFont boldSystemFontOfSize:12];
        self.titleL.textColor = [UIColor blackColor];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleL];
        self.descriptionL = [UILabel new];
        self.descriptionL.font = [UIFont systemFontOfSize:10];
        self.descriptionL.numberOfLines = 3;
        self.descriptionL.textAlignment = NSTextAlignmentCenter;
        self.descriptionL.textColor = [UIColor darkGrayColor];
        [self addSubview:self.descriptionL];
        self.iconV = [UIImageView new];
        [self addSubview:self.iconV];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(8);
            make.width.height.equalTo(self.mas_width).with.offset(-48);
        }];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.iconV.mas_bottom).with.offset(8);
            make.width.equalTo(self);
        }];
        [self.descriptionL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.titleL.mas_bottom).with.offset(8);
            make.width.equalTo(self);
        }];
    }
    return self;
}

- (void)click: (UIButton *)btn{
    if (self.model.click) {
        self.model.click();
    }
}

- (void)setModel:(BDIMDebugMenuIconModel *)model{
    _model = model;
    self.descriptionL.text = model.desc;
    self.titleL.text = model.title;
    self.iconV.image = [UIImage imageNamed:model.icon];
    [self setNeedsLayout];
}

@end
