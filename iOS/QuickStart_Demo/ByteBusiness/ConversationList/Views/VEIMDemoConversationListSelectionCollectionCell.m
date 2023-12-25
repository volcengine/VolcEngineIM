//
//  VEIMDemoConversationListSelectionCollectionCell.m
//  ByteBusiness
//
//  Created by hexi on 2023/11/20.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoConversationListSelectionCollectionCell.h"

@interface VEIMDemoConversationListSelectionCollectionCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation VEIMDemoConversationListSelectionCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 15.0f;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor clearColor];
}

- (void)setSelectionName:(NSString *)name
{
    self.label.text = name;
}

#pragma mark - Getter

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
