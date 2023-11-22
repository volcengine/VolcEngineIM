//
//  IMDemoInputToolView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/17.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMInputMenuModel.h"

typedef NS_ENUM(NSInteger, BIMConversationType);
typedef NS_ENUM(NSUInteger, BIMInputToolPriority) {
    BIMInputToolPriorityLow = 0,
    BIMInputToolPriorityNormal = 1,
    BIMInputToolPriorityHigh = 2,
};
@class BIMMessage;
@protocol BIMInputToolViewDelegate <NSObject>

- (void)inputToolViewDidChange:(CGRect)frame keyboardFrame:(CGRect)keyboardFrame;

- (void)inputToolViewSendMessage:(BIMMessage *)sendMessage;

//视频聊天，视频还是语音
- (void)inputToolViewStartVOIP:(BOOL)useVideo;

- (void)inputToolViewLive;

- (void)inputToolDidTriggerMention;

@end

/// 聊天页输入view
@interface BIMInputToolView : UIView
@property (nonatomic, weak) id <BIMInputToolViewDelegate> delegate;
@property (nonatomic, assign) BOOL isBroadCast;
@property (nonatomic, strong) BIMMessage *referMessage;
@property (nonatomic, strong) NSString *referMessageHint;
@property (nonatomic, assign) BIMInputToolPriority priority;
@property (nonatomic, assign) NSInteger maxWordLimit;

- (instancetype)initWithConvType:(BIMConversationType)type;

/// 还原
- (void)revertToTheOriginalType;
- (void)enableInput;
- (void)disableInputWithReason:(NSString *)reason;

- (void)setRefreMessage: (BIMMessage *)message;

- (void)setDraft: (NSString *)draft;

- (NSString *)currentText;

- (void)addMentionUser: (NSNumber *)user;

- (void)becomeFirstResponder;

- (void)inputText: (NSString *)text;

@end
