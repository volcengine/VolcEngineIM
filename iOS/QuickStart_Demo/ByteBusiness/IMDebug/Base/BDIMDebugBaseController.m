//
//  BDIMDebugBaseController.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/12.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugBaseController.h"
#import "BDIMDebugTableViewCell.h"

@interface BDIMDebugBaseController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BDIMDebugBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIElements];
    
    [self prepareData];
}

- (void)prepareData{
    self.models = [NSMutableArray array];
    
}

- (void)setupUIElements{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BDIMDebugTableViewCell class] forCellReuseIdentifier:@"BDIMDebugTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BDIMDebugTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BDIMDebugTableViewCell"];
    id <BDIMDebugModelProtocal> model = [self.models objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id <BDIMDebugModelProtocal> model = [self.models objectAtIndex:indexPath.row];
    if (model.click) {
        model.click();
    }
}


@end
