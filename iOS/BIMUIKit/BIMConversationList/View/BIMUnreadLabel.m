//
//UnreadLabel.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMUnreadLabel.h"
#import "BIMUIDefine.h"

#import <Masonry/Masonry.h>

#import <imsdk-tob/BIMSDK.h>

@implementation BIMUnreadLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:12];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)refreshWithConversation:(BIMConversation *)conv{
    [self refreshWithCount:conv.unreadCount color:conv.isMute?kIM_Sub_Color:kIM_Red_Color];
}

- (void)refreshWithCount:(NSInteger)count color:(UIColor *)color{
    self.hidden = count == 0;
    
    BOOL exceed = NO;
    if (count > 99) {
        count = 99;
        exceed = YES;
    }
    
    self.text = [NSString stringWithFormat:@"%zd%@",count,exceed?@"+":@""];
    [self sizeToFit];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.bounds.size.width+8);
    }];
    self.layer.cornerRadius = self.bounds.size.height * 0.5;
    self.backgroundColor = color;
}

@end
