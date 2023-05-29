//
//InputMoreMenuCollectionCell.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/18.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMInputMenuModel.h"


@interface BIMInputMoreMenuCollectionCell : UICollectionViewCell

- (void)loadData:(BIMInputMenuModel *)model indexPath:(NSIndexPath *)indexPath;

@end
