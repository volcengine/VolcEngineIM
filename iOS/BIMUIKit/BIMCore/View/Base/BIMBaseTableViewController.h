//
//  BIMBaseTableViewController.h
//
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMBaseViewController.h"
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMBaseTableViewController : BIMBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

//@overwrite
- (UITableViewStyle)tableviewStyle;

- (BOOL)headerRefreshEnable;
- (void)headerRefreshed;
- (BOOL)footerPullEnable;
- (void)footerPulled;

@end

NS_ASSUME_NONNULL_END
