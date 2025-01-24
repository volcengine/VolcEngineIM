//
//  VEIMDemoFriendApplyListCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendApplyListCell.h"

#import <imsdk-tob/BIMClient+Friend.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <im-uikit-tob/BIMUICommonUtility.h>

@interface VEIMDemoFriendApplyListCell ()

@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *rejectBtn;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *processContainer;
//@property (nonatomic, assign) BOOL hasProcessed;

@end

@implementation VEIMDemoFriendApplyListCell


- (void)configCell
{
    [self setupConstraints];
    
    BIMUserFullInfo *info = self.applyInfo.userFullInfo;
//    if (self.applyInfo.status == 1) {
//        displayName = [[BIMClient sharedInstance] getFriend:self.applyInfo.fromUid].alias;
//        displayName = (displayName && displayName.length) ? displayName : [NSString stringWithFormat:@"用户%@", @(self.applyInfo.fromUid).stringValue];
//    } else {
//        displayName = [NSString stringWithFormat:@"用户%@", @(self.applyInfo.fromUid).stringValue];
//    }
    self.nameLabel.text = [BIMUICommonUtility getShowNameWithUserFullInfo:info];
//    self.subTitleLabel.text = [NSString stringWithFormat:@"uid:%lld",self.applyInfo.fromUid];
    
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:info.portraitUrl] placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
    // 防止cell复用导致控件重叠
    if ([self.processContainer superview]) {
        [self.processContainer removeFromSuperview];
    }
    if ([self.stateLabel superview]) {
        [self.stateLabel removeFromSuperview];
    }
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(190);
    }];
    
    if (self.applyInfo.status == BIM_FRIEND_STATUS_APPLY) {
        [self addSubview:self.processContainer];
        [self.processContainer addSubview:self.acceptBtn];
        [self.processContainer addSubview:self.rejectBtn];
    } else {
        self.stateLabel.text = self.applyInfo.status == BIM_FRIEND_STATUS_AGREE ? @"已通过" : @"已拒绝";
        [self addSubview:self.stateLabel];
    }
    
    if (self.applyInfo.status == BIM_FRIEND_STATUS_APPLY) {
        [self.processContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(130);
            make.right.mas_equalTo(self).offset(-30);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(50);
        }];
        
        [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(self.processContainer);
            make.centerY.mas_equalTo(self.processContainer);
            make.height.mas_equalTo(30);
        }];
        
        [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(self.acceptBtn.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.processContainer);
            make.height.mas_equalTo(30);
        }];
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rejectBtn.mas_left);
        }];
        
    } else {
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-30);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(30);
        }];
        
//        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.stateLabel.mas_left);
//        }];
    }
}

#pragma mark - action
/// 接受好友申请
/// toast：操作成功
/// btn消失，显示“已通过”状态
/// 向对方发出 “我已通过你的好友申请”
/// 通讯录列表出现A
- (void)acceptFriendApply:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didAcceptFriendApply:)]) {
        [self.delegate didAcceptFriendApply:self];
    }
    
//    self.stateLabel.text = @"已通过";
//    if ([self.processContainer superview]) {
//        [self.processContainer removeFromSuperview];
//    }
//    [self addSubview:self.stateLabel];
//    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-30);
//        make.centerY.mas_equalTo(self);
//        make.height.mas_equalTo(30);
//    }];
}

/// 拒绝好友申请
/// toast：操作成功
/// btn消失，显示“已拒绝”状态
- (void)rejectFriendApply:(id)sender
{
//    self.stateLabel.text = @"已拒绝";
//    if ([self.processContainer superview]) {
//        [self.processContainer removeFromSuperview];
//    }
    if ([self.delegate respondsToSelector:@selector(didRejectFriendApply:)]) {
        [self.delegate didRejectFriendApply:self];
    }
//    [self addSubview:self.stateLabel];
//    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-30);
//        make.centerY.mas_equalTo(self);
//        make.height.mas_equalTo(30);
//    }];
}

#pragma mark - getter

- (UIButton *)acceptBtn
{
    if (!_acceptBtn) {
        _acceptBtn = [[UIButton alloc] init];
        
        [_acceptBtn setTitle:@"通过" forState:UIControlStateNormal];
        _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_acceptBtn.layer setMasksToBounds:YES];
        [_acceptBtn.layer setCornerRadius:10];
        [_acceptBtn.layer setBorderWidth:1];
        CGColorRef colorRef = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0, 0, 0, 1});
        [_acceptBtn.layer setBorderColor:colorRef];
        
        [_acceptBtn addTarget:self action:@selector(acceptFriendApply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptBtn;
}

- (UIButton *)rejectBtn
{
    if (!_rejectBtn) {
        _rejectBtn = [[UIButton alloc] init];
        [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_rejectBtn.layer setMasksToBounds:YES];
        [_rejectBtn.layer setCornerRadius:10];
        [_rejectBtn.layer setBorderWidth:1];
        CGColorRef colorRef = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0, 0, 0, 1});
        [_rejectBtn.layer setBorderColor:colorRef];
        
        [_rejectBtn addTarget:self action:@selector(rejectFriendApply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectBtn;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:16];
        _stateLabel.textColor = [UIColor grayColor];
    }
    return _stateLabel;
}

- (UIView *)processContainer
{
    if (!_processContainer) {
        _processContainer = [[UIView alloc] init];
    }
    return _processContainer;
}

@end
