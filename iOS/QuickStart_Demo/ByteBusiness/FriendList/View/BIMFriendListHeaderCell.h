//
//  BIMFriendListHeaderCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <im-uikit-tob/BIMPortraitBaseCell.h>

typedef NS_ENUM(NSInteger, BIMFriendListHeaderCellType) {
    BIMFriendListHeaderApply = 1,  // 好友申请
    BIMFriendListHeaderBlackList = 2,  // 黑名单
    BIMFriendListHeaderRobotList = 3,  // 机器人
};

@interface BIMFriendListHeaderCell : BIMPortraitBaseCell

@property (nonatomic, assign) BIMFriendListHeaderCellType type;

- (void)configWithType:(BIMFriendListHeaderCellType)type;

- (void)showBadgeWithNum:(NSNumber *)num;

@end

