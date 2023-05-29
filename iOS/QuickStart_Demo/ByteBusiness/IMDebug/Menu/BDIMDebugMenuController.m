//
//  BDIMDebugViewController.m
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugMenuController.h"
#import "BDIMDebugNetworkEnvironmentController.h"
#import "BDIMDebugNetworkManager.h"
#import <Masonry/Masonry.h>
#define kBDIMDebugRowCount 3

@interface BDIMDebugMenuController ()
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UILabel *conditionLabel;

@end

@implementation BDIMDebugMenuController

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.conditionLabel = [[UILabel alloc] init];
    self.conditionLabel.text = [[BDIMDebugNetworkManager sharedManager] networkDescription];
    self.conditionLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:self.conditionLabel];
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(24);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UIScrollView alloc] init];
    [self.view addSubview:self.contentView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(self.view.bounds.size.width - 24 - 8, 24, 24, 24);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:BDIMDebugNetworkChangeNotification object:nil];
}


- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:BDIMDebugNetworkChangeNotification]) {
        self.conditionLabel.text = [[BDIMDebugNetworkManager sharedManager] networkDescription];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)close: (id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshWithItemModels:(NSArray<BDIMDebugMenuIconModel *> *)itemModels{
    if (self.items.count) {
        for (UIView *items in self.items) {
            [items removeFromSuperview];
        }
        [self.items removeAllObjects];
    }
    for (BDIMDebugMenuIconModel *model in itemModels) {
        BDIMDebugMenuItem *item = [BDIMDebugMenuItem itemWithModel:model];
        [self.contentView addSubview:item];
        [self.items addObject:item];
    }
    [self.view setNeedsLayout];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.contentView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    CGFloat itemWidth = self.view.bounds.size.width / kBDIMDebugRowCount;
    CGFloat itemHeight = 100;
    for (int i = 0; i<self.items.count; i++) {
        int row = i%kBDIMDebugRowCount;
        int col = i/kBDIMDebugRowCount;
        BDIMDebugMenuItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(row * itemWidth, col * itemHeight, itemWidth, itemHeight);
    }
}
@end
