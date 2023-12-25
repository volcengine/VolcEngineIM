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
#import "BIMToastView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <Masonry/Masonry.h>

@interface VEIMDemoMyinfoHeaderCell ()
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *uidLabel;
@property (nonatomic, strong) BIMUserProfile *user;
@end

@implementation VEIMDemoMyinfoHeaderCell

- (void)setupUIElemets{
    [super setupUIElemets];
//    self.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.portrait = [UIImageView new];
    [self.contentView addSubview:self.portrait];
    
    self.name = [UILabel new];
    self.name.textColor = [UIColor blackColor];
    self.name.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:self.name];
    
    self.uidLabel = [UILabel new];
    self.uidLabel.userInteractionEnabled = YES;
    self.uidLabel.textColor = kIM_Sub_Color;
    self.uidLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.uidLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyUid)];
    [self.uidLabel addGestureRecognizer:tap];
    
    
    self.portrait.layer.cornerRadius = 18;
    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.height.width.mas_equalTo(60);
        make.bottom.mas_equalTo(-36);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.equalTo(self.portrait.mas_right).with.offset(18);
        make.right.equalTo(self.contentView.mas_right).offset(-18);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).with.offset(12);
        make.left.equalTo(self.name);
    }];
}
- (void)refreshWithUser:(BIMUserProfile *)user{
    _user = user;
    if (!user) {
        self.portrait.image = [UIImage btd_imageWithColor:[UIColor lightGrayColor]];
        self.name.text = @"未登录";
        self.uidLabel.text = @"";
    }else{
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:[UIImage imageNamed:[[VEIMDemoUserManager sharedManager] portraitForTestUser:user.uid]]];
        self.name.text = user.nickName.length ? user.nickName : [[VEIMDemoUserManager sharedManager] nicknameForTestUser:user.uid];
        self.uidLabel.text = [NSString stringWithFormat:@"UID: %lld",user.uid];
    }
}

- (void)copyUid
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @(self.user.uid).stringValue;
    [BIMToastView toast:[NSString stringWithFormat:@"已复制UID:%@", pasteboard.string] withDuration:0.5];
}



@end
