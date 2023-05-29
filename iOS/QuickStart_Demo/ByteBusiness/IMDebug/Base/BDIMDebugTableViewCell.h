//
//  BDIMDebugTableViewCell.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/13.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIMDebugModelProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugTableViewCell : UITableViewCell
@property (nonatomic, strong) id <BDIMDebugModelProtocal> model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;


@end

NS_ASSUME_NONNULL_END
