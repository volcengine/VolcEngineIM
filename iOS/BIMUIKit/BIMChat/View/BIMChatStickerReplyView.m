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
#import "BIMUIClient.h"

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
    self.backgroundColor = kRGBCOLOR(234, 234, 234, 1);
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;

    self.replyLabel = [UILabel new];
    self.replyLabel.font = [UIFont systemFontOfSize:12];
    self.replyLabel.textColor = kIM_Sub_Color;
    self.replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.replyLabel.numberOfLines = 0;
    [self addSubview:self.replyLabel];
}

- (BOOL)containSticker:(BIMMessage *)message{
    return kValidDict(message.properties) && message.properties.count;
}

- (void)setupConstraints{
    [self.replyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_lessThanOrEqualTo(KScreenWidth - 120);
    }];
    [self.replyLabel sizeToFit];
}

- (void)refreshWithMessage:(BIMMessage *)message{
    NSDictionary *properties = message.properties;
    if (kValidDict(properties) && properties.count) {
        NSMutableString *replyText = [@"" mutableCopy];
        NSArray *allKeys = properties.allKeys;
        for (NSString *key in allKeys) {
            NSArray<BIMMessagePropertyItem *> *propertyItems = properties[key];
            if (!propertyItems.count) {
                continue;
            }
            [replyText appendString:[NSString stringWithFormat:@"%@ ", key]];
            for (BIMMessagePropertyItem *propertyItem in propertyItems) {
                [self appendReplyText:replyText withPropertyItem:propertyItem];
                if (propertyItems.lastObject != propertyItem) {
                    [replyText appendString:@"、"];
                }
            }
            if (allKeys.lastObject != key) {
                [replyText appendString:@" | "];
            }
        }

        if (!replyText.length) {
            self.replyLabel.hidden = YES;
        } else {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:replyText];
            [[BIMStickerDataManager sharedInstance] replaceEmojiForAttributedString:attr font:self.replyLabel.font];
            self.replyLabel.attributedText = attr;
            self.replyLabel.hidden = NO;
        }
    } else {
        self.replyLabel.hidden = YES;
    }
}

/// 添加属性的用户信息
- (void)appendReplyText:(NSMutableString *)replyText withPropertyItem:(BIMMessagePropertyItem *)item
{
    BIMUser *user = [BIMUIClient sharedInstance].userProvider(item.sender);
    NSString *appendString = user.alias;
    if (!appendString.length) {
        appendString = user.nickName;
    }
    if (!appendString.length) {
        appendString = [NSString stringWithFormat:@"用户%lld",item.sender];
    }
    [replyText appendString:appendString];
}

@end
