//
//  SSDebugViewControllerBase.h
//  Article
//
//  Created by liufeng on 2017/8/14.
//
//

#import <UIKit/UIKit.h>
#import "TTDebugItem.h"


@interface SSDebugViewControllerBase : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray<STTableViewSectionItem *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL disableKeyboardNotificationHandling;

@end
