//
//InputMoreMenuView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/18.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMInputMoreMenuView.h"
#import "BIMInputMoreMenuCollectionCell.h"


@interface BIMInputMoreMenuView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end


@implementation BIMInputMoreMenuView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[BIMInputMoreMenuCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([BIMInputMoreMenuCollectionCell class])];
        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)setListMAry:(NSMutableArray *)listMAry
{
    _listMAry = listMAry;
    [self reloadData];
}


#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listMAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BIMInputMoreMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BIMInputMoreMenuCollectionCell class]) forIndexPath:indexPath];

    BIMInputMenuModel *model = self.listMAry[indexPath.row];
    [cell loadData:model indexPath:indexPath];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuDelegate && [self.menuDelegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.menuDelegate didSelectItemAtIndexPath:indexPath];
    }
}

@end
