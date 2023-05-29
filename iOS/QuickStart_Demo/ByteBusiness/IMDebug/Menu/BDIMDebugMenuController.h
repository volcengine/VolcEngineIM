//
//  BDIMDebugViewController.h
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIMDebugMenuIconModel.h"
#import "BDIMDebugMenuItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugMenuController : UIViewController
@property (nonatomic, strong) NSMutableArray <BDIMDebugMenuItem *> *items;

- (void)refreshWithItemModels: (NSArray <BDIMDebugMenuIconModel *> *)itemModels;

@end

NS_ASSUME_NONNULL_END
