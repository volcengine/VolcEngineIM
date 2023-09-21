//
//  VEIMDemoBlackListUserCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/8/31.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMPortraitBaseCell.h"

@class BIMBlackListFriendInfo, VEIMDemoBlackListUserCell;

@protocol VEIMDemoBlackListUserCellDelegate <NSObject>

- (void)cellDidLongPress:(VEIMDemoBlackListUserCell *)cell;

@end

@interface VEIMDemoBlackListUserCell : BIMPortraitBaseCell

@property (nonatomic, strong) BIMBlackListFriendInfo *blackInfo;
@property (nonatomic, weak) id<VEIMDemoBlackListUserCellDelegate> delegate;

@end
