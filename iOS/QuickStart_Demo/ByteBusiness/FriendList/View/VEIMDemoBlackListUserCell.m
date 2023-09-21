//
//  VEIMDemoBlackListUserCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/8/31.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoBlackListUserCell.h"

#import <imsdk-tob/BIMClient+Friend.h>
#import <Masonry/Masonry.h>

@interface VEIMDemoBlackListUserCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation VEIMDemoBlackListUserCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    UILongPressGestureRecognizer *longpPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [self.contentView addGestureRecognizer:longpPressGes];
}

- (void)setBlackInfo:(BIMBlackListFriendInfo *)blackInfo
{
    _blackInfo = blackInfo;
    
    self.nameLabel.text = [NSString stringWithFormat:@"用户%@", @(self.blackInfo.uid)];
    self.portrait.image = [UIImage imageNamed:@"icon_recommend_user_default"];
    self.subTitleLabel.text = nil;
    
    [self setupConstraints];
}

- (void)longPress
{
    if ([self.delegate respondsToSelector:@selector(cellDidLongPress:)]) {
        [self.delegate cellDidLongPress:self];
    }
}

@end
