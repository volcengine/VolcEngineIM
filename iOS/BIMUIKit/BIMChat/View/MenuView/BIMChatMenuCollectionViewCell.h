//
//  MenuCollectionViewCell.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/26.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMChatMenuCollectionView.h"


@interface BIMChatMenuCollectionViewCell : UICollectionViewCell

- (void)loadData:(BIMChatMenuItemModel *)model indexPath:(NSIndexPath *)indexPath;

@end
