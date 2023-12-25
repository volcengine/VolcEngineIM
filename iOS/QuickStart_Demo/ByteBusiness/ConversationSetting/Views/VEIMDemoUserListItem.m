//
//  VEIMDemoUserListItem.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoUserListItem.h"
#import "VEIMDemoDefine.h"
#import <imsdk-tob/BIMSDK.h>
#import "BIMUIClient.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VEIMDemoUserListItem

- (void)setupUIElemets{
    [super setupUIElemets];
//    self.userInteractionEnabled = NO;
    self.userPortrait = [UIImageView new];
    [self addSubview:self.userPortrait];
    
    self.userName = [UILabel new];
    self.userName.textColor = kIM_Sub_Color;
    self.userName.textAlignment = NSTextAlignmentCenter;
    self.userName.font = kFont(10);
    [self addSubview:self.userName];
}

- (void)setupConstraints{
    [super setupConstraints];
    
    [self.userPortrait mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(16);
    }];
    
    [self.userName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPortrait.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
}

- (void)refreshWithParticipant:(id<BIMMember>)participant {
    BIMUser *user = [BIMUIClient sharedInstance].userProvider(participant.userID);
    NSString *alias = user.alias.length ? user.alias : participant.alias;
    if (!alias.length) {
        alias = user.nickName;
    }
    self.userName.text = alias;
//    self.userPortrait.image = [UIImage imageNamed:[[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID]];
    NSString *avatarURL = participant.avatarURL;
    if (!avatarURL.length) {
        avatarURL = user.portraitUrl;
    }
    [self.userPortrait sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:[[VEIMDemoUserManager sharedManager] portraitForTestUser:participant.userID]]];
    
}

@end
