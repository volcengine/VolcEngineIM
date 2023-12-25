//
//  VEIMDemoAvatarSettingCell.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/20.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewCell.h"
#import "VEIMDemoAvatarSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoAvatarSettingCell : BIMBaseTableViewCell
@property (nonatomic, strong) UILabel *settingTitle;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) VEIMDemoAvatarSettingModel *model;

@end

NS_ASSUME_NONNULL_END
