//
//  VEIMDemoConversationSettingCell.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMBaseTableViewCell.h"
#import "VEIMDemoSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoConversationSettingCell : BIMBaseTableViewCell

@property (nonatomic, strong) UILabel *settingTitle;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UISwitch *swt;

@property (nonatomic, strong) VEIMDemoSettingModel *model;


@end

NS_ASSUME_NONNULL_END
