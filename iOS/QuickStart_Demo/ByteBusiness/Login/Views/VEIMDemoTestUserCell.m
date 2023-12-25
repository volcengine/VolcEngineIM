//
//  VEIMDemoTestUserCell.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import "VEIMDemoTestUserCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <im-uikit-tob/BIMUIClient.h>

@interface VEIMDemoTestUserCell ()

@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UILabel *markTypesLabel;

@end

@implementation VEIMDemoTestUserCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.checkMark = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_normal"] forState:UIControlStateNormal];
    [self.checkMark setImage:[UIImage imageNamed:@"icon_duoxuan_sel"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.checkMark];
    self.checkMark.userInteractionEnabled = NO;
    
    self.silentMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_forbid"]];
    [self.contentView addSubview:self.silentMark];
    
    self.onlineLabel = [UILabel new];
    self.onlineLabel.font = [UIFont systemFontOfSize:12];
    self.onlineLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.onlineLabel];
    
    self.roleLabel = [UILabel new];
    self.roleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.roleLabel];

    self.markTypesLabel = [UILabel new];
    self.markTypesLabel.font = [UIFont systemFontOfSize:12];
    self.markTypesLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.markTypesLabel];

    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.contentView addGestureRecognizer:longGesture];
}

- (void)setupConstraints
{
    [super setupConstraints];
    
    [self.checkMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.right.mas_equalTo(-24);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.silentMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.right.mas_equalTo(-24);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *leftView = self.nameLabel;
    if (self.roleLabel.text.length) {
        [self.roleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right).offset(12);
            make.centerY.equalTo(leftView);
        }];
        leftView = self.roleLabel;
    }
    
    if (self.onlineLabel.text.length) {
        [self.onlineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right).offset(12);
            make.centerY.equalTo(leftView);
        }];
        leftView = self.onlineLabel;
    }
    
    if (self.markTypesLabel.text.length) {
        [self.markTypesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right).with.offset(12);
            make.centerY.equalTo(self.nameLabel);
        }];
        leftView = self.markTypesLabel;
    }
    
    UIView *rightEndView = self.contentView;
    if (!self.checkMark.hidden) {
        rightEndView = self.checkMark;
    }
    
    if (!self.silentMark.hidden) {
        rightEndView = self.silentMark;
    }
    
    if (rightEndView == self.contentView) {
        [leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(rightEndView.mas_right).offset(-24);
        }];
    } else {
        [leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(rightEndView.mas_left).offset(-20);
        }];
    }
    
    [leftView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setUser:(VEIMDemoUser *)user{
    _user = user;
    
    self.nameLabel.text = user.name;
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:user.portrait]];
    
    if (user.role.length) {
        self.roleLabel.text = [NSString stringWithFormat:@"[%@]", user.role];
    } else {
        self.roleLabel.text = nil;
    }
    self.subTitleLabel.text = nil;
    self.checkMark.selected = user.isSelected;
    
    if (user.onlineString.length) {
        self.onlineLabel.text = user.onlineString;
        self.onlineLabel.hidden = NO;
    } else {
        self.onlineLabel.hidden = YES;
    }
    self.markTypesLabel.text = [user.markTypes componentsJoinedByString:@" "];

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
