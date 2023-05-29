//
//  BDIMDebugBaseController.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/12.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIMDebugModelProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugBaseController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <id <BDIMDebugModelProtocal>> *models;

- (void)prepareData;
@end

NS_ASSUME_NONNULL_END
