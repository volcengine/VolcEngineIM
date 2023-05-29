//
//CustomChatCell.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMCustomChatCell.h"
#import "BIMStickerDataManager.h"
#import "BIMUIDefine.h"

@interface  BIMCustomChatCell ()
@property (nonatomic, strong) NSString *link;
@end

@implementation BIMCustomChatCell

@dynamic delegate;

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.linkTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:self.linkTextButton];
    [self.linkTextButton setTitle:@"查看详情>>" forState:UIControlStateNormal];
    [self.linkTextButton addTarget:self action:@selector(linkClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.linkTextButton setTitleColor:kRGBCOLOR(28, 36, 92, 1) forState:UIControlStateNormal];
}

- (void)linkClicked: (id)sender{
    if ([self.delegate respondsToSelector:@selector(cell:didClickLink:)]) {
        [self.delegate cell:self didClickLink:self.link];
    }
}

- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    
    if (message.msgType ==     BIM_MESSAGE_TYPE_CUSTOM) {
        BIMCustomElement *element = (BIMCustomElement *)message.element;
        NSString *str = element.dataDict[@"text"];
        if (kValidStr(str)) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            [[BIMStickerDataManager sharedInstance] replaceEmojiForAttributedString:attStr font:self.chatTextLabel.font];
            self.chatTextLabel.attributedText = attStr;
        } else {
            self.chatTextLabel.text = str;
        }
        
        NSString *link = element.dataDict[@"link"];
        if (link.length) {
            self.link = link;
            self.linkTextButton.hidden = NO;
        }else{
            self.link = nil;
            self.linkTextButton.hidden = YES;
        }
    }
    [self setupConstraints];
}

- (UIView *)bgBottom{
    if (!self.linkTextButton.hidden) {
        return self.linkTextButton;
    }else{
        return self.chatTextLabel;
    }
}

- (UIView *)bgLeft{
    if (!self.linkTextButton.hidden && self.isSelfMsg) {
        self.linkTextButton.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        self.chatTextLabel.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        [self.chatTextLabel sizeToFit];
        [self.linkTextButton sizeToFit];
        if (self.linkTextButton.bounds.size.width >= self.chatTextLabel.bounds.size.width) {
            return self.linkTextButton;
        }
    }
    return self.chatTextLabel;
}

- (UIView *)bgRight{
    if (!self.linkTextButton.hidden && !self.isSelfMsg) {
        self.linkTextButton.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        self.chatTextLabel.bounds = CGRectMake(0, 0, self.contentMaxWidth, 999);
        [self.chatTextLabel sizeToFit];
        [self.linkTextButton sizeToFit];
        if (self.linkTextButton.bounds.size.width >= self.chatTextLabel.bounds.size.width) {
            return self.linkTextButton;
        }
    }
    return self.chatTextLabel;
}

- (void)setupConstraints{
    [super setupConstraints];
    
    
    [self.linkTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatTextLabel.mas_bottom).offset([self margin]);
        if (self.isSelfMsg) {
            make.right.equalTo(self.chatTextLabel);
        }else{
            make.left.equalTo(self.chatTextLabel);
        }
    }];
//    [self.chatTextBg mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.chatTextLabel).offset(-margin);
//        make.left.equalTo(self.chatTextLabel).offset(-margin);
//        make.right.equalTo(self.chatTextLabel).offset(margin);
//        make.bottom.equalTo(self.linkTextButton).offset(margin);
//        make.bottom.mas_equalTo(-16);
//    }];
}

@end
