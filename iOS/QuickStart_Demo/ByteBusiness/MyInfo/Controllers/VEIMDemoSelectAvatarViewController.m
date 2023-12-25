//
//  VEIMDemoSelectAvatarViewController.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/16.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoSelectAvatarViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VEIMDemoSelectAvatarCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, copy) NSString *url;
@end

@implementation VEIMDemoSelectAvatarCell

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setUrl:(NSString *)url
{
    _url = [url copy];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end

static NSString *const kReuseIdentifier = @"VEIMDemoSelectAvatarCell";
static CGFloat const kMargin = 33;

@interface VEIMDemoSelectAvatarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<NSString *> *dataArray;

@end

@implementation VEIMDemoSelectAvatarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = @[
        @"https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar1.png",
        @"https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar2.png",
        @"https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar3.png",
        @"https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar4.png",
        @"https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar5.png",
        @"https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar6.png",
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[VEIMDemoSelectAvatarCell class] forCellWithReuseIdentifier:kReuseIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath 
{
    CGFloat margin = kMargin;
    CGFloat padding = kMargin;
    int rowCount = 3;
    CGFloat width = (self.view.frame.size.width - 2 * margin - (rowCount - 1) * padding) / rowCount;
    CGFloat height = width;

    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section 
{
    return UIEdgeInsetsMake(20, kMargin, 0, kMargin);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section 
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VEIMDemoSelectAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.url = self.dataArray[indexPath.row];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectCallBack) {
        self.selectCallBack(self.dataArray[indexPath.row]);
    }
    [self dismiss];
}

@end
