//
//  BIMCouponChatCell.h
//  im-uikit-tob
//
//  Created by yangzhanjiang on 2024/2/1.
//

#import "BIMTextChatCell.h"

@class BIMCouponChatCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BIMCouponChatCellDelegate <BIMBaseChatCellDelegate>

- (void)cellDidClickCouponLink:(BIMCouponChatCell *)cell;

@end

@interface BIMCouponChatCell : BIMTextChatCell
@property (nonatomic, weak) id<BIMCouponChatCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
