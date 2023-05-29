//
//  VEIMDemoLiveGroupChatTitleView.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/24.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoLiveGroupChatTitleView.h"
#import <Masonry/Masonry.h>

@interface VEIMDemoLiveGroupChatTitleView ()

@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *onlineUserNum;

@end

@implementation VEIMDemoLiveGroupChatTitleView

- (instancetype)initWithTitle:(NSString *)title onlineUsrNum:(NSInteger)onlineUsrNum
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 400, 30);
        self.title.text = [NSString stringWithFormat:@"%@", title];
        self.onlineUserNum.text = [NSString stringWithFormat:@"%@ 人", @(onlineUsrNum)];
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI
{
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.onlineUserNum];
    [self.onlineUserNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right);
        make.bottom.mas_equalTo(self.title);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
}


#pragma mark - Getter
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)onlineUserNum
{
    if (!_onlineUserNum) {
        _onlineUserNum = [[UILabel alloc] init];
        _onlineUserNum.textColor = [UIColor grayColor];
        _onlineUserNum.font = [UIFont systemFontOfSize:10];
    }
    return _onlineUserNum;
}

@end
