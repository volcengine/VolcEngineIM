//
//  BIMFriendListUserCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMFriendListUserCell.h"

#import <imsdk-tob/BIMClient+Friend.h>

@interface BIMFriendListUserCell ()

@end

@implementation BIMFriendListUserCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    UILongPressGestureRecognizer *longpPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [self.contentView addGestureRecognizer:longpPressGes];
}

- (void)setFriendInfo:(BIMFriendInfo *)friendInfo{
    _friendInfo = friendInfo;
    
    self.portrait.image = [UIImage imageNamed:@"icon_recommend_user_default"];
    self.nameLabel.text = (friendInfo.alias && friendInfo.alias.length) ? friendInfo.alias: [NSString stringWithFormat:@"用户%@", @(friendInfo.uid).stringValue];
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
