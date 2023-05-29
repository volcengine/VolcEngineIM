//
//  BIMBaseTableViewController.m
//
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMBaseTableViewController.h"


@interface BIMBaseTableViewController ()

@end

@implementation BIMBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setupUIElements{
    [super setupUIElements];
    UINavigationBarAppearance *app = [[UINavigationBarAppearance alloc] init];
    app.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.standardAppearance = app;
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:[self tableviewStyle]];
    self.tableview.frame = self.view.bounds;
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    if ([self headerRefreshEnable]) {
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshed)];
    }
    if ([self footerPullEnable]) {
        self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerPulled)];
    }
}

- (BOOL)headerRefreshEnable{
    return NO;
}

- (void)headerRefreshed{
    
}

- (BOOL)footerPullEnable{
    return NO;
}

- (void)footerPulled{
    
}

- (UITableViewStyle)tableviewStyle{
    return UITableViewStylePlain;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}





@end
