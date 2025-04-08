//
//  BIMFriendListHeaderCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMFriendListHeaderCell.h"


@interface BIMFriendListHeaderCell ()

@property (nonatomic, strong) UILabel *headBadge;

@end

@implementation BIMFriendListHeaderCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    self.headBadge = [[UILabel alloc] init];
    self.headBadge.backgroundColor = [UIColor redColor];
    self.headBadge.layer.cornerRadius = 8;
    self.headBadge.layer.masksToBounds = YES;
    self.headBadge.textColor = [UIColor whiteColor];
    self.headBadge.font = [UIFont systemFontOfSize:10];
    self.headBadge.textAlignment = NSTextAlignmentCenter;
    self.headBadge.numberOfLines = 0;
    self.headBadge.hidden = YES;
}

- (void)setupConstraints
{
    [super setupConstraints];
    
    self.portrait.clipsToBounds = NO;
    [self.portrait addSubview:self.headBadge];
    [self.headBadge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(16);
        make.top.mas_equalTo(self.portrait.mas_top);
        make.right.mas_equalTo(self.portrait.mas_right);
    }];
    
}

- (void)configWithType:(BIMFriendListHeaderCellType)type
{
    self.type = type;
    
    if (type == BIMFriendListHeaderApply) {
        self.nameLabel.text = @"好友申请";
    } else if (type == BIMFriendListHeaderBlackList) {
        self.nameLabel.text = @"黑名单";
    } else if (type == BIMFriendListHeaderRobotList) {
        self.nameLabel.text = @"机器人列表";
    }
    [self.portrait setImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
}

- (void)showBadgeWithNum:(NSNumber *)num
{
    if (num && num.integerValue != 0) {
        self.headBadge.text = num.integerValue > 99 ? @"99+" : num.stringValue;
        NSDictionary *attr = @{NSFontAttributeName : self.headBadge.font};
        CGSize textSize = [self.headBadge.text sizeWithAttributes:attr];
        
        if (self.headBadge.text.length > 1) {
            [self.headBadge mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(textSize.width + 2 * 4.f);
            }];
        }
        
        self.headBadge.hidden = NO;
    } else {
        self.headBadge.text = nil;
        self.headBadge.hidden = YES;
    }
}

@end
