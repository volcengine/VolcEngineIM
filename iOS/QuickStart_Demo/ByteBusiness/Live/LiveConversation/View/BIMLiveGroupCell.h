//
//  BIMLiveGroupCell.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMPortraitBaseCell.h"

@class BIMLiveGroupCell, BIMConversation;
@protocol BIMLiveGroupCellDelegate <NSObject>

- (void)cellDidLongPress:(BIMLiveGroupCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BIMLiveGroupCell : BIMPortraitBaseCell

@property(nonatomic, strong) BIMConversation *conv;
@property(nonatomic, weak) id<BIMLiveGroupCellDelegate> delegate;

- (void)refreshWithCoversation:(BIMConversation *)conv;

@end

NS_ASSUME_NONNULL_END
