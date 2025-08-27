//
//  BIMFriendListUserCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMPortraitBaseCell.h"


@class BIMUserFullInfo, BIMFriendListUserCell;

@protocol BIMFriendListUserCellDelegate <NSObject>

- (void)cellDidLongPress:(BIMFriendListUserCell *)cell;

@end

@interface BIMFriendListUserCell : BIMPortraitBaseCell

//@property (nonatomic, strong) BIMUser *user;
@property (nonatomic, strong) BIMUserFullInfo *friendInfo;
@property (nonatomic, assign) BOOL isOnline;//在线状态
@property (nonatomic, weak) id<BIMFriendListUserCellDelegate> delegate;

@end
