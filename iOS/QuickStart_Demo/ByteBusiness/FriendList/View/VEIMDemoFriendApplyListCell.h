//
//  VEIMDemoFriendApplyListCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/18.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <im-uikit-tob/BIMPortraitBaseCell.h>

@class VEIMDemoFriendApplyListCell, BIMFriendApplyInfo;
@protocol VEIMDemoFriendApplyListCellDelegate <NSObject>

// 同意
- (void)didAcceptFriendApply:(VEIMDemoFriendApplyListCell *)cell;
// 拒绝
- (void)didRejectFriendApply:(VEIMDemoFriendApplyListCell *)cell;

@end

@interface VEIMDemoFriendApplyListCell : BIMPortraitBaseCell

@property (nonatomic, strong) BIMFriendApplyInfo *applyInfo;
@property (nonatomic, weak) id<VEIMDemoFriendApplyListCellDelegate> delegate;

- (void)configCell;

@end
