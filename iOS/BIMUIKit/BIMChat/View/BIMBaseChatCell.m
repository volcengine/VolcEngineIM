//
//BaseChatCell.m
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMBaseChatCell.h"
#import "BIMUIDefine.h"
#import "UIImage+IMUtils.h"
#import "BIMUIClient.h"

@interface BIMBaseChatCell ()

@end

@implementation BIMBaseChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.retrySentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.retrySentBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_retrySend") forState:UIControlStateNormal];
    [self.retrySentBtn addTarget:self action:@selector(retryBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.retrySentBtn];
    
    self.chatBg = [UIButton new];
    self.chatBg.layer.cornerRadius = 8;
    [self.chatBg addTarget:self action:@selector(bgDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chatBg];
    
    self.referMessageLabel = [UILabel new];
//    self.referMessageLabel.backgroundColor = [UIColor whiteColor];
    self.referMessageLabel.font = [UIFont systemFontOfSize:12];
    self.referMessageLabel.textColor = kIM_Sub_Color;
    self.referMessageLabel.numberOfLines = 1;
    [self.contentView addSubview:self.referMessageLabel];
    
    self.dateLabel = [UILabel new];
    [self.contentView addSubview:self.dateLabel];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = kFont(12);
    self.dateLabel.textColor = kIM_Sub_Color;
    
    self.portrait = [UIImageView new];
    self.portrait.clipsToBounds = YES;
    [self.contentView addSubview:self.portrait];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = kFont(12);
    self.nameLabel.textColor = kIM_Sub_Color;
    
    UILongPressGestureRecognizer *longges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longges.minimumPressDuration = 1.0;
    [self.chatBg addGestureRecognizer:longges];
    
    self.replyView = [[BIMChatStickerReplyView alloc] init];
    self.replyView.hidden = YES;
    [self.contentView addSubview:self.replyView];
}

- (void)longPress: (UILongPressGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (self.longPressHandler) {
            self.longPressHandler(ges);
        }
    }
}

- (void)retryBtnDidClicked: (id)sender{
    if ([self.delegate respondsToSelector:@selector(chatCell:didClickRetryBtnWithMessage:)]) {
        [self.delegate chatCell:self didClickRetryBtnWithMessage:self.message];
    }
}


- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    self.message = message;
    self.converstaion = conversation;
    self.sender = sender;
    
    self.isSelfMsg = message.senderUID == [BIMClient sharedInstance].getCurrentUserID.longLongValue;
    
    self.dateLabel.text = [self convertDate:message.createdTime];
    
    long long userID = message.senderUID;
    NSString *senderName;
    if (kValidStr(sender.alias)) {
        senderName = sender.alias;
    } else {
        senderName = [BIMUIClient sharedInstance].userProvider(userID).nickName;
    }
    if (self.isSelfMsg) {
        self.chatBg.backgroundColor = kIM_Blue_Color;
        self.retrySentBtn.hidden = message.msgStatus != BIM_MESSAGE_STATUS_FAILED;
    }else{
        self.retrySentBtn.hidden = YES;
        self.chatBg.backgroundColor = [UIColor whiteColor];
    }
    self.nameLabel.hidden = self.isSelfMsg;
    self.nameLabel.text = senderName;
    UIImage *portrait = [BIMUIClient sharedInstance].userProvider(userID).headImg;
    if (!portrait) {
        portrait = [UIImage im_avatarWithUserId:@(userID).stringValue];
    }
    self.portrait.image = portrait;
    
    if (message.referenceInfo.hint.length) {
        if (message.referenceInfo.status == 3) {
            self.referMessageLabel.text = [NSString stringWithFormat:@"| %@",@"消息已被撤回"];
        } else if (message.referenceInfo.status == 4) {
            self.referMessageLabel.text = [NSString stringWithFormat:@"| %@",@"消息已被删除"];
        } else {
            self.referMessageLabel.text = [NSString stringWithFormat:@"| %@",message.referenceInfo.hint];
        }
    }else{
        self.referMessageLabel.text = nil;
    }
    
    if ([self.replyView containSticker:message]) {
        self.replyView.hidden = NO;
        [self.replyView refreshWithMessage:message];
    }else{
        self.replyView.hidden = YES;
    }
    
    
    [self setupConstraints];
}

- (void)bgDidClicked: (id)sender{
    
}

- (CGFloat)contentMaxWidth{
    return KScreenWidth - 160;
}

- (CGFloat)margin{
    return 8;
}

- (UIView*)bgTop{
    return nil;
}

- (UIView*)bgLeft{
    return nil;
}

- (UIView *)bgRight{
    return nil;
}

- (UIView *)bgBottom{
    return nil;
}

- (CGFloat)bgWidth{
    return 0;
}

- (CGFloat)bgHeight{
    return 0;
}

- (void)setupConstraints{
    
//    if (!self.chatBg.hidden) {
        [self.chatBg mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([[self bgTop] isKindOfClass:[UIView class]]) {
                make.top.equalTo([self bgTop]).offset(-[self margin]);
            }
            if ([[self bgLeft] isKindOfClass:[UIView class]]) {
                make.left.equalTo([self bgLeft]).offset(-[self margin]);
            }
            if ([[self bgRight] isKindOfClass:[UIView class]]) {
                make.right.equalTo([self bgRight]).offset([self margin]);
            }
            if ([[self bgBottom] isKindOfClass:[UIView class]]) {
                make.bottom.equalTo([self bgBottom]).offset([self margin]);
            }
            if ([self bgWidth]!=0) {
                make.width.mas_equalTo([self bgWidth]);
            }
            
            if ([self bgHeight]!=0) {
                make.height.mas_equalTo([self bgHeight]);
            }
            if (self.replyView.hidden) {
                make.bottom.mas_equalTo(-[self margin]*2);
            }
        }];
//    }
    
    if (self.isSelfMsg) {
        [self.retrySentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.chatBg.mas_left).offset(-16);
            make.centerY.equalTo(self.chatBg);
        }];
    }
    if (self.referMessageLabel.text.length) {
        if (self.isSelfMsg) {
            [self.referMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.portrait.mas_left).offset(-[self margin]*2);
                make.width.mas_lessThanOrEqualTo(self.contentMaxWidth);
                make.top.equalTo(self.portrait).offset([self margin]);
            }];
        }else{
            [self.referMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel).offset([self margin]);
                make.width.mas_lessThanOrEqualTo(self.contentMaxWidth);
                make.top.equalTo(self.nameLabel.mas_bottom).offset([self margin] * 2);
            }];
        }
    }else{
        [self.referMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }

    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];

    CGFloat portraitWH = 36;
    
    self.portrait.layer.cornerRadius = portraitWH * 0.5;
    if (self.isSelfMsg) {
        [self.portrait mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.width.height.mas_equalTo(portraitWH);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(8);
        }];
        
        if (!self.replyView.hidden) {
            [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chatBg.mas_bottom).offset(16);
                make.right.equalTo(self.chatBg);
                make.bottom.mas_equalTo(-[self margin]*2);
            }];
        }
    }else{
        [self.portrait mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.width.height.mas_equalTo(portraitWH);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(8);
        }];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).offset(8);
            make.top.equalTo(self.portrait);
        }];
        
        if (!self.replyView.hidden) {
            [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chatBg.mas_bottom).offset(16);
                make.left.equalTo(self.chatBg);
                make.bottom.mas_equalTo(-[self margin]*2);
            }];
        }
    }
    
    
}

/**
 根据给定日期转换（当天是HH:mm，之前的日期是年/月/日）
 */
- (NSString *)convertDate:(NSDate *)otherDate
{
    NSDate *today = [[NSDate alloc] init];

    NSString *yearString = [[today description] substringToIndex:4];
    NSString *todayString = [[today description] substringToIndex:10];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:otherDate];

    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy"];
    NSString *dateString2 = [dateFormatter2 stringFromDate:otherDate];

    if ([dateString isEqualToString:todayString]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:otherDate];
        return dateString;
    } else if ([dateString2 isEqualToString:yearString]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:otherDate];
        return dateString;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:otherDate];
        return dateString;
    }
}


@end
