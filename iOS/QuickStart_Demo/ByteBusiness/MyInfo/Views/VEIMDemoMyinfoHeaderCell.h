//
//  VEIMDemoMyinfoHeaderCell.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/3.
//

#import "BIMBaseTableViewCell.h"
#import "VEIMDemoUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoMyinfoHeaderCell : BIMBaseTableViewCell

- (void)refreshWithUser: (VEIMDemoUser *)user;

@end

NS_ASSUME_NONNULL_END
