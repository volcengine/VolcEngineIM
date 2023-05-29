//
//  BDIMDebugNetworkRequestCell.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/17.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIMDebugNetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugNetworkRequestCell : UITableViewCell

@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *urlDescLabel;
//@property (nonatomic, strong) UILabel *logidLabel;
//@property (nonatomic, strong) UILabel *errorLabel;
//@property (nonatomic, strong) UILabel *methodLabel;
@property (nonatomic, strong) UILabel *wsMethod;

@property (nonatomic, strong) BDIMDebugNetworkRequest *request;

@end

NS_ASSUME_NONNULL_END
