//
//ChatStickerReplyView.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/18.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMChatStickerReplyView.h"
#import "BIMUIDefine.h"
#import "BIMStickerDataManager.h"

#import <Masonry/Masonry.h>

@interface BIMChatStickerReplyView ()
@property (nonatomic, strong) UILabel *replyLabel;
@end

@implementation BIMChatStickerReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIElemets];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUIElemets{
//    self.backgroundColor = kRGBCOLOR(234, 234, 234, 1);
//    self.layer.cornerRadius = 8;
//    self.clipsToBounds = YES;
//
//    self.replyLabel = [UILabel new];
//    self.replyLabel.font = [UIFont systemFontOfSize:12];
//    self.replyLabel.textColor = kIM_Sub_Color;
//    [self addSubview:self.replyLabel];
}

- (BOOL)containSticker:(BIMMessage *)message{
    return NO;
//    return kValidDict(message.properties) && message.properties.count;
}

- (void)setupConstraints{
//    [self.replyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(8);
//        make.left.mas_equalTo(8);
//        make.right.mas_equalTo(-8);
//        make.bottom.mas_equalTo(-8);
//        make.width.mas_lessThanOrEqualTo(KScreenWidth - 120);
//    }];
}

- (void)refreshWithMessage:(BIMMessage *)message{
//    NSDictionary *properties = message.properties;
//    if (kValidDict(properties) && message.properties.count) {
//        NSMutableString *replyText = [@"" mutableCopy];
//        NSArray *allKeys = properties.allKeys;
//        for (NSString *k in allKeys) {
//            [replyText appendString:[NSString stringWithFormat:@"%@ ",k]];
//            NSArray <BIMMessagePropertyItem *>*pValue = properties[k];
//            for (BIMMessagePropertyItem *item in pValue) {
//                [replyText appendString:[NSString stringWithFormat:@"%@",[[VEIMDemoUserManager sharedManager] nicknameForTestUser:item.sender]]];
//                if (pValue.lastObject != item) {
//                    [replyText appendString:@"、"];
//                }
//            }
//            if (allKeys.lastObject != k) {
//                [replyText appendString:@" | "];
//            }
//        }
//
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:replyText];
//
//        [[BIMStickerDataManager sharedInstance] replaceEmojiForAttributedString:attr font:self.replyLabel.font];
//        self.replyLabel.attributedText = attr;
//        self.replyLabel.hidden = NO;
//    }else{
//        self.replyLabel.hidden = YES;
//    }

}

@end
