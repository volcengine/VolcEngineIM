//
//  VEIMDemoCreateLiveGroupCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewCell.h"

typedef enum : NSUInteger {
    VEIMDemoLiveGroupSettingCellStyle1,
    VEIMDemoLiveGroupSettingCellStyle2,
    VEIMDemoLiveGroupSettingCellStyle3,
} VEIMDemoCreateLiveGroupCellStyle;

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoCreateLiveGroupCell : BIMBaseTableViewCell

@property(nonatomic, strong) UILabel *settingTitle;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *arrow;
@property(nonatomic, strong) UIImageView *groupAvatar;

- (void)setupCellLayoutWithStyle:(VEIMDemoCreateLiveGroupCellStyle)style;

@end

NS_ASSUME_NONNULL_END
