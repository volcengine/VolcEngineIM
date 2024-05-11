//
//  BIMLableTextField.m
//  Bolts
//
//  Created by yangzhanjiang on 2024/4/17.
//

#import "BIMLableTextField.h"
#import <Masonry/Masonry.h>

@interface BIMLableTextField ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation BIMLableTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.label];
    [self addSubview:self.textField];

}

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    
    [self.label sizeToFit];
    CGFloat labelW = self.label.bounds.size.width;
    
    self.label.frame = CGRectMake(0, 0, labelW, selfH);
    self.textField.frame = CGRectMake(CGRectGetMaxX(self.label.frame)+5, 0, selfW-labelW, selfH);
}

#pragma mark - getter

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}

@end
