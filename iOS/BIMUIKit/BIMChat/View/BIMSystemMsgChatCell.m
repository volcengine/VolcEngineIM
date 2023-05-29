//
//RecallChatCell.m
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMSystemMsgChatCell.h"
#import "BIMUIDefine.h"

@implementation BIMSystemMsgChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.msgLabel = [UILabel new];
    [self.contentView addSubview:self.msgLabel];
    self.msgLabel.font = kFont(12);
    self.msgLabel.numberOfLines = 2.0;
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.textColor = kIM_Sub_Color;
}

- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    if (message.isRecalled) {
        if (self.isSelfMsg) {
            self.msgLabel.text = @"你撤回了一条消息";
        }else{
            if (conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
                self.msgLabel.text = [NSString stringWithFormat:@"对方撤回了一条消息"];
            }else{
                self.msgLabel.text = [NSString stringWithFormat:@"%@撤回了一条消息",self.nameLabel.text];
            }
        }
    } else {
        BIMCustomElement *element = (BIMCustomElement *)message.element;
        self.msgLabel.text = element.dataDict[@"text"];
    }
    
    self.portrait.hidden = YES;
    self.nameLabel.hidden = YES;
    self.chatBg.hidden = YES;
    self.retrySentBtn.hidden = YES;
    self.referMessageLabel.hidden = YES;
    [self setupConstraints];
    
}

- (void)setupConstraints{
    [super setupConstraints];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_lessThanOrEqualTo(16);
        make.right.mas_lessThanOrEqualTo(-16);
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(-16);
    }];
//    self.msgLabel.bounds = CGRectMake(0, 0, KScreenWidth - 32, 999);
//    [self.msgLabel sizeToFit];
//    self.msgLabel.frame = CGRectMake(16, CGRectGetMaxY(self.dateLabel.frame)+16, KScreenWidth - 32, self.msgLabel.bounds.size.height);
}
//- (CGFloat)heightForMessage:(TIMOMessage *)message inConversation:(TIMOConversation *)conversation sender:(id<TIMOConversationParticipant>)sender{
//    [self refreshWithMessage:message inConversation:conversation sender:sender];
//
//    return CGRectGetMaxY(self.msgLabel.frame) + 16;
//}

@end
