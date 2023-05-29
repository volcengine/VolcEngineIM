//
//InputMoreMenuView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/18.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BIMInputMoreMenuViewDelegate <NSObject>

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BIMInputMoreMenuView : UICollectionView
@property (nonatomic, strong) NSMutableArray *listMAry;
@property (nonatomic, weak) id <BIMInputMoreMenuViewDelegate>menuDelegate;

@end
