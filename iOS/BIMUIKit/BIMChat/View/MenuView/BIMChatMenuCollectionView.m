//
//  MenuCollectionView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/26.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMChatMenuCollectionView.h"
#import "BIMChatMenuCollectionViewCell.h"
#import "BIMUIDefine.h"


@implementation BIMChatMenuItemModel
+ (instancetype)modelWithTitle:(NSString *)title icon:(NSString *)icon type:(BIMChatMenuType)type{
    BIMChatMenuItemModel *item = [[BIMChatMenuItemModel alloc] init];
    item.titleStr = title;
    item.iconStr = icon;
    item.type = type;
    return item;
}
@end


@interface BIMChatMenuCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end


@implementation BIMChatMenuCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[BIMChatMenuCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BIMChatMenuCollectionViewCell class])];
        self.backgroundColor = kWhiteColor;
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
    BIMChatMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BIMChatMenuCollectionViewCell class]) forIndexPath:indexPath];

    BIMChatMenuItemModel *model = self.listMAry[indexPath.row];
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
