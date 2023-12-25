//
//  VEIMDemoMyinfoHeaderCell.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/3.
//

#import "BIMBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BIMUserProfile;
@interface VEIMDemoMyinfoHeaderCell : BIMBaseTableViewCell

- (void)refreshWithUser: (BIMUserProfile *)user;

@end

NS_ASSUME_NONNULL_END
