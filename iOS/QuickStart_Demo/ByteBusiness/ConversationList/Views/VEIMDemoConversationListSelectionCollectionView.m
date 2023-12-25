//
//  VEIMDemoConversationListSelectionCollectionView.m
//  ByteBusiness
//
//  Created by hexi on 2023/11/20.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoConversationListSelectionCollectionView.h"

#import "VEIMDemoConversationListSelectionCollectionCell.h"

#import <OneKit/ByteDanceKit.h>
#import <Masonry/View+MASShorthandAdditions.h>
#import <im-uikit-tob/BIMBaseConversationListController.h>

@interface VEIMDemoConversationListSelectionModel : NSObject

@property (nonatomic, assign) BIMConversationListType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger totalUnreadCount;

@end

@implementation VEIMDemoConversationListSelectionModel

@end

@interface VEIMDemoConversationListSelectionCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSArray<NSNumber *> *selectionArray;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, VEIMDemoConversationListSelectionModel *> *selectionDict;

@end

@implementation VEIMDemoConversationListSelectionCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[VEIMDemoConversationListSelectionCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([VEIMDemoConversationListSelectionCollectionCell class])];
        self.backgroundColor = [UIColor whiteColor];
        self.selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0]; /// 默认选择第一个会话列表
    }
    return self;
}

- (void)setTotalUnreadCount:(NSUInteger)totalUnreadCount withType:(BIMConversationListType)type
{
    VEIMDemoConversationListSelectionModel *model = [self.selectionDict btd_objectForKey:@(type) default:nil];
    if (!model) {
        return;
    }
    model.totalUnreadCount = totalUnreadCount;
    [self.selectionDict btd_setObject:model forKey:@(type)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.selectionArray indexOfObject:@(type)] inSection:0];
    [self reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - UICollectionView delegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectionArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoConversationListSelectionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VEIMDemoConversationListSelectionCollectionCell class]) forIndexPath:indexPath];
    BIMConversationListType type = [self.selectionArray btd_objectAtIndex:indexPath.row].integerValue;
    VEIMDemoConversationListSelectionModel *model = [self.selectionDict btd_objectForKey:@(type) default:nil];
    [cell setSelectionName:[self getSelectionNameFromModel:model]];
    if ([self.selectIndexPath isEqual:indexPath]) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    if ([self.viewDelegate respondsToSelector:@selector(didSelectType:)]) {
        [self.viewDelegate didSelectType:[self.selectionArray btd_objectAtIndex:indexPath.row].integerValue];
    }
}

#pragma mark - Private

- (NSString *)getSelectionNameFromModel:(VEIMDemoConversationListSelectionModel *)model
{
    NSUInteger count = model.totalUnreadCount;
    BOOL exceed = NO;
    if (count > 99) {
        count = 99;
        exceed = YES;
    }
    NSString *countString = count > 0 ? [NSString stringWithFormat:@"%@ %@", @(count), exceed ? @"+":@""] : @"";
    return [[model.name stringByAppendingString:countString] copy];
}

#pragma mark - Getter

- (NSArray<NSNumber *> *)selectionArray
{
    if (!_selectionArray) {
        _selectionArray = @[@(BIMConversationListTypeAllConversation), @(BIMConversationListTypeFriendConversation)];
    }
    return _selectionArray;
}

- (NSMutableDictionary<NSNumber *,VEIMDemoConversationListSelectionModel *> *)selectionDict
{
    if (!_selectionDict) {
        _selectionDict = [NSMutableDictionary dictionary];

        VEIMDemoConversationListSelectionModel *allConversationModel = [[VEIMDemoConversationListSelectionModel alloc] init];
        allConversationModel.name = @"全部";
        allConversationModel.type = BIMConversationListTypeAllConversation;
        [_selectionDict btd_setObject:allConversationModel forKey:@(BIMConversationListTypeAllConversation)];

        VEIMDemoConversationListSelectionModel *friendConversationModel = [[VEIMDemoConversationListSelectionModel alloc] init];
        friendConversationModel.name = @"好友";
        friendConversationModel.type = BIMConversationListTypeFriendConversation;
        [_selectionDict btd_setObject:friendConversationModel forKey:@(BIMConversationListTypeFriendConversation)];
    }
    return _selectionDict;
}

@end
