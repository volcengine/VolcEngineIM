//
//  BIMFriendListUserCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMFriendListUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <imsdk-tob/BIMClient+Friend.h>

@interface BIMFriendListUserCell ()

@end

@implementation BIMFriendListUserCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    UILongPressGestureRecognizer *longpPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [self.contentView addGestureRecognizer:longpPressGes];
}

- (void)setFriendInfo:(BIMUserFullInfo *)friendInfo{
    _friendInfo = friendInfo;
    
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:friendInfo.portraitUrl] placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
    NSString *nickName = friendInfo.alias.length ? friendInfo.alias : friendInfo.nickName;
    if (!nickName.length) {
        nickName = [NSString stringWithFormat:@"用户%@", @(friendInfo.uid).stringValue];
    }
    self.nameLabel.text = nickName;
    self.subTitleLabel.text = nil;

    [self setupConstraints];
}

- (void)longPress
{
    if ([self.delegate respondsToSelector:@selector(cellDidLongPress:)]) {
        [self.delegate cellDidLongPress:self];
    }
}

- (void)setupConstraints
{
    [super setupConstraints];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
    }];
    
}

@end
