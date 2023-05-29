//
//ConversationCell.h
//
//
//  Created by Weibai on 2022/11/1.
//

#import "BIMPortraitBaseCell.h"


NS_ASSUME_NONNULL_BEGIN
@class BIMConversationCell, BIMConversation;
@protocol BIMConversationCellDelegate <NSObject>

- (void)cellDidLongPress: (BIMConversationCell *)cell;

@end

@interface BIMConversationCell : BIMPortraitBaseCell

@property (nonatomic, strong) BIMConversation *conversation;

@property (nonatomic, weak) id <BIMConversationCellDelegate> delegate;

- (void)refreshWithConversation: (BIMConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
