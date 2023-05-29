//
//  MenuCollectionView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/26.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMChatMenuView.h"


@interface BIMChatMenuItemModel : NSObject

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, assign) BIMChatMenuType type;
+ (instancetype)modelWithTitle: (NSString *)title icon: (NSString *)icon type: (BIMChatMenuType)type;

@end

@protocol BIMChatMenuCollectionViewDelegate <NSObject>

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BIMChatMenuCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray<BIMChatMenuItemModel *> *listMAry;
@property (nonatomic, strong) id<BIMChatMenuCollectionViewDelegate> menuDelegate;

@end
