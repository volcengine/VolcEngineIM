//
//  BIMLiveGroupCell.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMLiveGroupCell.h"
#import <imsdk-tob/BIMSDK.h>

@interface BIMLiveGroupCell ()

@end

@implementation BIMLiveGroupCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    // 长按会话手势
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [self.contentView addGestureRecognizer:longPressGes];
    
}

// 长按手势响应事件
- (void)longPress
{
    if ([self.delegate respondsToSelector:@selector(cellDidLongPress:)]) {
        [self.delegate cellDidLongPress:self];
    }
}

- (void)refreshWithCoversation:(BIMConversation *)conv
{
    self.conv = conv;
    if (conv.name.length) {
        self.nameLabel.text = conv.name;
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"未命名直播间"];
    }

    if (conv.portraitURL.length) {
        [self.portrait setImage:[self getImageFromURL:conv.portraitURL]];
        if (!self.portrait) {
            [self.portrait setImage:[UIImage imageNamed:@"icon_avatar_group"]];
        }
    } else {
        [self.portrait setImage:[UIImage imageNamed:@"icon_avatar_group"]];
    }
    
    long long currentUID = [BIMClient sharedInstance].getCurrentUserID.longLongValue;
    if (conv.ownerID == currentUID) {
        [self.subTitleLabel setText:@"群主"];
    }
    
    [self setupConstraints];
}

- (UIImage *)getImageFromURL:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if ([self contentTypeForImageData:data] == nil) {
        return [UIImage imageNamed:@"icon_avatar_group"];
    }
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
        if ([data length] < 12) {
            return nil;
        }
        NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
        if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
            return @"webp";
        }
        return nil;
    }
    return nil;
}

@end
