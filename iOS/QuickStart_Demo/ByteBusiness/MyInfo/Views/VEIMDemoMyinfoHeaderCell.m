//
//  VEIMDemoMyinfoHeaderCell.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/3.
//

#import "VEIMDemoMyinfoHeaderCell.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoDefine.h"
#import "UIImage+BTDAdditions.h"

#import <Masonry/Masonry.h>

@interface VEIMDemoMyinfoHeaderCell ()
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *uidLabel;
@end

@implementation VEIMDemoMyinfoHeaderCell

- (void)setupUIElemets{
    [super setupUIElemets];
    self.userInteractionEnabled = NO;
    
    self.portrait = [UIImageView new];
    [self.contentView addSubview:self.portrait];
    
    self.name = [UILabel new];
    self.name.textColor = [UIColor blackColor];
    self.name.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:self.name];
    
    self.uidLabel = [UILabel new];
    self.uidLabel.textColor = kIM_Sub_Color;
    self.uidLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.uidLabel];
    
    self.portrait.layer.cornerRadius = 18;
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.height.width.mas_equalTo(60);
        make.bottom.mas_equalTo(-36);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.equalTo(self.portrait.mas_right).with.offset(18);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).with.offset(12);
        make.left.equalTo(self.name);
    }];
}
- (void)refreshWithUser:(VEIMDemoUser *)user{
    if (!user) {
        self.portrait.image = [UIImage btd_imageWithColor:[UIColor lightGrayColor]];
        self.name.text = @"未登录";
        self.uidLabel.text = @"";
    }else{
        self.portrait.image = [UIImage imageNamed:[[VEIMDemoUserManager sharedManager] portraitForTestUser:user.userID]];
        self.name.text = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:user.userID];
        self.uidLabel.text = [NSString stringWithFormat:@"UID: %lld",user.userID];
    }
}

@end
