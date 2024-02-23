//
//TextCell.m
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMTextChatCell.h"
#import "BIMUIDefine.h"
#import "BIMStickerDataManager.h"

@implementation BIMTextChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.chatTextLabel = [UILabel new];
    self.chatTextLabel.numberOfLines = 0;
    self.chatTextLabel.textColor = kIM_Main_Color;
    [self.contentView addSubview:self.chatTextLabel];
    
}

- (UIView*)bgTop{
    if (self.referMessageLabel.text.length) {
        return self.referMessageLabel;
    }else{
        return self.chatTextLabel;
    }
}

- (UIView*)bgLeft{
    if (self.referMessageLabel.text.length && self.isSelfMsg) {
        self.chatTextLabel.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        self.referMessageLabel.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        [self.chatTextLabel sizeToFit];
        [self.referMessageLabel sizeToFit];
        if (self.referMessageLabel.bounds.size.width >= self.chatTextLabel.bounds.size.width) {
            return self.referMessageLabel;
        }
    }
    
    return self.chatTextLabel;
}

- (UIView*)bgRight{
    if (self.referMessageLabel.text.length && !self.isSelfMsg) {
        self.chatTextLabel.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        self.referMessageLabel.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        [self.chatTextLabel sizeToFit];
        [self.referMessageLabel sizeToFit];
        if (self.referMessageLabel.bounds.size.width >= self.chatTextLabel.bounds.size.width) {
            return self.referMessageLabel;
        }
    }
    return self.chatTextLabel;
}

- (UIView*)bgBottom{
    return self.chatTextLabel;
}

- (void)setupConstraints{
    [super setupConstraints];
    
    //    if (self.message.messageType == TIMPBNMessageType_MessageTypeText) {
    //        self.chatTextLabel.bounds = CGRectMake(0, 0, KScreenWidth - 160, 9999);
    //        [self.chatTextLabel sizeToFit];
    
    CGFloat margin = 8;
    if (self.isSelfMsg) {
        [self.chatTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.portrait.mas_left).offset(-margin*2);
            make.width.mas_lessThanOrEqualTo(KScreenWidth - 160);
            if (self.referMessageLabel.text.length) {
                make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
            }else{
                make.top.equalTo(self.portrait).offset(margin);
            }
        }];
    }else{
        [self.chatTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel).offset(margin);
            make.width.mas_lessThanOrEqualTo(KScreenWidth - 160);
            if (self.referMessageLabel.text.length) {
                make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
            }else{
                make.top.equalTo(self.nameLabel.mas_bottom).offset(margin * 2);
            }
        }];
    }
    //        [self.chatTextBg mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(self.chatTextLabel).offset(-margin);
    //            make.top.equalTo(self.chatTextLabel).offset(-margin);
    //            make.right.equalTo(self.chatTextLabel).offset(margin);
    //            make.bottom.equalTo(self.chatTextLabel).offset(margin);
    //            make.bottom.mas_equalTo(-16);
    //        }];
    
    //    }
    
    
    
}

-(void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    
    if (message.msgType == BIM_MESSAGE_TYPE_TEXT) {
        BIMTextElement *element = (BIMTextElement *)message.element;
        NSString *str = element.text;
        if (str.length) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            [[BIMStickerDataManager sharedInstance] replaceEmojiForAttributedString:attStr font:self.chatTextLabel.font];
            if (message.editInfo.isEdit) {
                NSAttributedString *isEditedAttString = [[NSAttributedString alloc] initWithString:[self getIsEditedSuffixString] attributes:@{
                    NSForegroundColorAttributeName : kIM_Main_Color
                }];
                [attStr appendAttributedString:isEditedAttString];
            }
            self.chatTextLabel.attributedText = attStr;
        }else{
            self.chatTextLabel.text = @"";
        }
        
    }else{
        self.chatTextLabel.text = [NSString stringWithFormat:@"type: %zd 消息不支持显示",message.msgType];
    }
    
    //    }
    
    [self setupConstraints];
}

//- (CGFloat)heightForMessage:(TIMOMessage *)message inConversation:(TIMOConversation *)conversation sender:(id<TIMOConversationParticipant>)sender{
//    [self refreshWithMessage:message inConversation:conversation sender:sender];
//    
//    return CGRectGetMaxY(self.chatTextBg.frame) + 16;
//}

#pragma mark Private

- (NSString *)getIsEditedSuffixString
{
    BIMEditInfo *editInfo = self.message.editInfo;
    if (!editInfo.isEdit) {
        return @"";
    }
    return @"(已编辑)";
}

@end
