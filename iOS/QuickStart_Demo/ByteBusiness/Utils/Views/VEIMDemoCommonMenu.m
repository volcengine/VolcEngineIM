//
//  IM_ListView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/7.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "VEIMDemoCommonMenu.h"
#import "VEIMDemoDefine.h"

#import <OneKit/UIView+BTDAdditions.h>

static CGFloat kTableView_margin = 8;
static CGFloat kTableView_width = 150;
static CGFloat kTableView_cell_height = 53;


@implementation VEIMDemoCommonMenuItemModel

@end


@interface VEIMDemoCommonMenu () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VEIMDemoSelectHandler selectBlock;
@property (nonatomic, strong) NSArray *listAry;

@end


@implementation VEIMDemoCommonMenu


#pragma mark - LifeCycle

- (instancetype)initWithListArray:(NSArray<VEIMDemoCommonMenuItemModel *> *)listAry selectBlock:(VEIMDemoSelectHandler)selectBlock
{
    if (self = [super init]) {
        self.listAry = listAry;
        self.backgroundColor = kRGBCOLOR(0, 0, 0, 0.1);
        self.frame = [UIScreen mainScreen].bounds;
        self.selectBlock = selectBlock;

        [self addSubview:self.tableView];
    }

    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.btd_width - kTableView_width - kTableView_margin, kDevice_iPhoneNavBarAndStatusBarHei + kTableView_margin, kTableView_width, kTableView_cell_height * self.listAry.count)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = kWhiteColor;

        kViewBorderRadius(_tableView, 4, 0.1, kWhiteColor);
    }

    return _tableView;
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableView_cell_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"listcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.textLabel.font = kFont(16);
        cell.textLabel.textColor = kIM_Main_Color;
        cell.backgroundColor = [UIColor clearColor];
    }

    VEIMDemoCommonMenuItemModel *model = self.listAry[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.imgStr];
    cell.textLabel.text = model.titleStr;

    if (indexPath.row < self.listAry.count - 1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kTableView_cell_height - 1, kTableView_width, 1)];
        lineView.backgroundColor = kIM_Line_Color;
        [cell.contentView addSubview:lineView];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideSelf];

    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideSelf];
}

- (void)hideSelf
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.tableView.btd_left = self.btd_width + kTableView_margin;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    self.alpha = 0.0;
    self.tableView.btd_left = self.btd_width + kTableView_margin;

    [kAppWindow addSubview:self];

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        self.alpha = 1.0;
        self.tableView.btd_left = self.btd_width - kTableView_width - kTableView_margin;
    } completion:^(BOOL finished){

    }];
}

@end
