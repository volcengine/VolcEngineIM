//
//  BIMCouponChatCell.m
//  im-uikit-tob
//
//  Created by yangzhanjiang on 2024/2/1.
//

#import "BIMCouponChatCell.h"

@interface BIMCouponChatCell ()

@end

@implementation BIMCouponChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
}

- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    
    if (message.msgType != BIM_MESSAGE_TYPE_CUSTOM) {
        return;
    }
    self.chatBg.backgroundColor = [UIColor redColor];
    self.chatTextLabel.textColor = [UIColor whiteColor];
    
    NSInteger status = [message.ext[@"a:coupon_status"] integerValue];
    if (status == 1) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"这是一张优惠券，已领取"];
        self.chatTextLabel.attributedText = attStr;
    } else {
        BIMCustomElement *element = (BIMCustomElement *)message.element;
        NSString *str = element.dataDict[@"detail"];
        NSInteger start = [element.dataDict[@"start"] integerValue];
        NSInteger end = [element.dataDict[@"end"] integerValue];
        if (str.length) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
            [attStr addAttributes:attributes range:NSMakeRange(start, end-start)];
            self.chatTextLabel.attributedText = attStr;
        } else{
            self.chatTextLabel.text = @"";
        }
    }
    
    [self setupConstraints];
}

- (void)bgDidClicked:(id)sender
{
    NSInteger status = [self.message.ext[@"a:coupon_status"] integerValue];
    if (status == 1) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(cellDidClickCouponLink:)]) {
        [self.delegate cellDidClickCouponLink:self];
    }
}

@end
