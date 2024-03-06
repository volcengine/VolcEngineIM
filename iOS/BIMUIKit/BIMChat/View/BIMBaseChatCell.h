//
//BaseChatCell.h
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMBaseTableViewCell.h"
#import "BIMChatStickerReplyView.h"

#import <imsdk-tob/BIMSDK.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN
@class BIMBaseChatCell;
@protocol BIMBaseChatCellDelegate <NSObject>

- (void)chatCell:(BIMBaseChatCell *)cell didClickRetryBtnWithMessage:(BIMMessage *)message;
- (void)chatCell:(BIMBaseChatCell *)cell didClickAvatarWithMessage:(BIMMessage *)message;

@end


@interface BIMBaseChatCell : BIMBaseTableViewCell

@property (nonatomic, weak) id <BIMBaseChatCellDelegate> delegate;

@property (nonatomic, strong) BIMMessage *message;
@property (nonatomic, strong) BIMConversation *converstaion;
@property (nonatomic, strong) id <BIMMember> sender;

@property (nonatomic, assign) BOOL isSelfMsg;

@property (nonatomic, strong) UIButton *chatBg;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *referMessageLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) BIMChatStickerReplyView *replyView;

@property (nonatomic, strong) UIButton *retrySentBtn;

@property (nonatomic, strong, nullable) void(^longPressHandler)(UILongPressGestureRecognizer *gesture);

- (void)refreshWithMessage: (BIMMessage *)message inConversation: (BIMConversation *)conversation sender: (id <BIMMember>)sender;

//- (CGFloat)heightForMessage: (TIMOMessage *)message inConversation: (TIMOConversation *)conversation sender: (id <TIMOConversationParticipant>)sender;

- (void)setupConstraints;

- (NSString *)convertDate:(NSDate *)otherDate;

- (void)bgDidClicked: (id)sender;

- (BOOL)isNeedBg;
- (UIView*)bgLeft;
- (UIView*)bgTop;
- (UIView*)bgRight;
- (UIView*)bgBottom;
- (CGFloat)bgWidth;
- (CGFloat)bgHeight;
- (CGFloat)margin;

- (CGFloat)contentMaxWidth;

@end

NS_ASSUME_NONNULL_END
