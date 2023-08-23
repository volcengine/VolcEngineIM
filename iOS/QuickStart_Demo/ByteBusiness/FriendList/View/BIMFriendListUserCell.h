//
//  BIMFriendListUserCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMPortraitBaseCell.h"


@class BIMFriendInfo, BIMFriendListUserCell;

@protocol BIMFriendListUserCellDelegate <NSObject>

- (void)cellDidLongPress:(BIMFriendListUserCell *)cell;

@end

@interface BIMFriendListUserCell : BIMPortraitBaseCell

//@property (nonatomic, strong) BIMUser *user;
@property (nonatomic, strong) BIMFriendInfo *friendInfo;
@property (nonatomic, weak) id<BIMFriendListUserCellDelegate> delegate;

@end
