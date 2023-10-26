//
//  VEIMDemoTestUserCell.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import "VEIMDemoTestUserCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface VEIMDemoTestUserCell ()

@property (nonatomic, strong) UILabel *onlineLabel;

@end

@implementation VEIMDemoTestUserCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.checkMark = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_normal"] forState:UIControlStateNormal];
    [self.checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_sel"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.checkMark];
    self.checkMark.userInteractionEnabled = NO;
    
    [self.checkMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.right.mas_equalTo(-24);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.silentMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_forbid"]];
    [self.contentView addSubview:self.silentMark];
    [self.silentMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.right.mas_equalTo(-24);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.onlineLabel = [UILabel new];
    self.onlineLabel.font = [UIFont systemFontOfSize:12];
    self.onlineLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.onlineLabel];
    
    [self.onlineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(12);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.contentView addGestureRecognizer:longGesture];
}

- (void)setUser:(VEIMDemoUser *)user{
    _user = user;
    
//    self.portrait.image = [UIImage imageNamed:user.portrait];
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:user.portrait]];
    if (user.role.length) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",user.name, user.role];
    }else{
        self.nameLabel.text = user.name;
    }
    self.subTitleLabel.text = nil;
//    self.subTitleLabel.text = [NSString stringWithFormat:@"UserID: %lld",user.userID];
    self.checkMark.selected = user.isSelected;
    
    self.onlineLabel.text = user.onlineString;
    
    if (user.isNeedSelection) {
        self.checkMark.enabled = YES;
    }else{
        self.checkMark.enabled = NO;
    }
    
    [self setupConstraints];
}

- (void)hideCheckMark:(BOOL)hide{
    if (hide) {
        self.checkMark.hidden = YES;
    }else{
        self.checkMark.hidden = NO;
    }
}

- (void)hideSilentMark:(BOOL)hide {
    self.silentMark.hidden = hide;
}

- (void)longPress: (UILongPressGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (self.longPressHandler) {
            self.longPressHandler(ges);
        }
    }
}

@end
