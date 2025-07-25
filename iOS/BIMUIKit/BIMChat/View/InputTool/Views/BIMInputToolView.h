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

typedef NS_ENUM(NSInteger, BIMInputToolMenuType) {
    BIMInputToolMenuTypePhoto = 0,
    BIMInputToolMenuTypeCamera = 1,
    BIMInputToolMenuTypeFile = 2,
    BIMInputToolMenuTypeCustomMessage = 3,
    BIMInputToolMenuTypeCoupon = 4,
    BIMInputToolMenuTypeVideoV2 = 5,
};

typedef NS_ENUM(NSUInteger, BIMInputToolRecordStatus) {
    BIMInputToolRecordHiden = 0,
    BIMInputToolRecordNormal = 1,
    BIMInputToolRecordRecording = 2,
    BIMInputToolRecordPreCancel = 3,
};

@class BIMMessage;
@protocol BIMInputToolViewDelegate <NSObject>

- (void)inputToolViewDidChange:(CGRect)frame keyboardFrame:(CGRect)keyboardFrame;

- (void)inputToolViewSendMessage:(BIMMessage *)sendMessage;

- (void)inputToolDidTriggerMention;

- (void)inputToolViewModifyMessage:(BIMMessage *)message newContent:(NSString *)newContent mentionedUsers:(NSArray<NSNumber *> *)mentionedUsers;

@end

/// 聊天页输入view
@interface BIMInputToolView : UIView
@property (nonatomic, weak) id <BIMInputToolViewDelegate> delegate;
@property (nonatomic, assign) BOOL isBroadCast;
@property (nonatomic, strong) BIMMessage *referMessage;
@property (nonatomic, strong) NSString *referMessageHint;
@property (nonatomic, assign) BIMInputToolPriority priority;
@property (nonatomic, assign) NSInteger maxWordLimit;
@property (nonatomic, assign) BOOL isModifyMessage;
@property (nonatomic, strong) NSArray<NSNumber *> *menuTypeArray;

- (instancetype)initWithConvType:(BIMConversationType)type conversationID:(NSString *)conversationID;

/// 还原
- (void)revertToTheOriginalType;
- (void)enableInput;
- (void)disableInputWithReason:(NSString *)reason;

- (void)setDraft: (NSString *)draft;

- (NSString *)currentText;

- (void)addMentionUser: (NSNumber *)user;

- (void)becomeFirstResponder;

- (void)inputText: (NSString *)text;

- (void)hideAudioInput;

- (void)hideAddInput;

@end
