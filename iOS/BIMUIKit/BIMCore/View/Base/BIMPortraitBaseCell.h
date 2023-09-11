//
//  BIMPortraitBaseCell.h
//  
//
//  Created by Weibai on 2022/11/1.
//

#import "BIMBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BIMPortraitBaseCell : BIMBaseTableViewCell
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

NS_ASSUME_NONNULL_END
