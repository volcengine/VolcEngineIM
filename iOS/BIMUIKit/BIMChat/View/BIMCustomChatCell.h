//
//CustomChatCell.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMTextChatCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BIMCustomChatCell;

@protocol BIMCustomChatCellDelegate <BIMBaseChatCellDelegate>

- (void)cell:(BIMCustomChatCell *)cell didClickLink:(NSString *)link;

@end

@interface BIMCustomChatCell : BIMTextChatCell

@property (nonatomic, weak) id<BIMCustomChatCellDelegate> delegate;

@property (nonatomic, strong) UIButton *linkTextButton;

@end

NS_ASSUME_NONNULL_END
