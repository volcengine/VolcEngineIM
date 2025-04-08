//
//  TTDebugItem.m
//  TTDebugCore
//
//  Created by 李琢鹏 on 2020/4/28.
//

#import "TTDebugItem.h"
#import <OneKit/ByteDanceKit.h>
#import "BIMUIDefine.h"

@implementation NSMutableArray (TTDebugCore)

- (void)ttd_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (!anObject) {
        return;
    }
    if (index > self.count) {
        [self addObject:anObject];
    } else {
        [self insertObject:anObject atIndex:index];
    }
}
@end


@interface STTableViewCellItem ()

@property (nonatomic, weak) STTableViewCell *cell;

@end


@implementation STTableViewCellItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textFieldEditable = YES;
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self = [self init];
    if (self) {
        self.title = title;
        self.target = target;
    }
    return self;
}

- (void)setTextFieldContent:(NSString *)textFieldContent
{
    _textFieldContent = textFieldContent;
    self.cell.cellItem = self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.cell.cellItem = self;
}

- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    self.cell.cellItem = self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    self.cell.cellItem = self;
}

@end


@interface STTableViewSectionItem ()

@property (nonatomic, strong) NSMutableArray<STTableViewCellItem *> *mutableItems;

@end


@implementation STTableViewSectionItem

- (instancetype)initWithSectionTitle:(NSString *)title items:(NSArray *)items
{
    return [self initWithSectionHeaderTitle:title footerTitle:nil items:items];
}

- (instancetype)initWithSectionHeaderTitle:(NSString *)title footerTitle:(NSString *)footerTitle items:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.headerTitle = title;
        self.footerTitle = footerTitle;
        self.mutableItems = items.mutableCopy ?: NSMutableArray.array;
    }
    return self;
}

- (void)addCellItem:(STTableViewCellItem *)cellItem
{
    [self.mutableItems btd_addObject:cellItem];
}

- (void)insertCellItem:(STTableViewCellItem *)cellItem atIndex:(NSUInteger)index
{
    [self.mutableItems ttd_insertObject:cellItem atIndex:index];
}

- (NSArray *)items
{
    return self.mutableItems.copy;
}

@end


@implementation STTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = kIM_Main_Color;
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self _textFieldBeginEditActionFired:textField];
    if (self.cellItem.pickerViewStyle) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self _textFieldActionFired:textField];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; //关闭键盘
    return YES;
}

- (void)_textFieldActionFired:(UITextField *)textField
{
    if ([self.cellItem.target respondsToSelector:self.cellItem.textFieldAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.cellItem.target performSelector:_cellItem.textFieldAction withObject:textField];
#pragma clang diagnostic pop
    }
    self.cellItem.textFieldContent = textField.text;
}

- (void)_textFieldBeginEditActionFired:(UITextField *)textField
{
    if ([self.cellItem.target respondsToSelector:self.cellItem.textFieldBeginEditAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.cellItem.target performSelector:_cellItem.textFieldBeginEditAction withObject:textField];
#pragma clang diagnostic pop
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.accessoryView.btd_centerY = self.btd_height / 2;
}

#pragma mark - event

- (void)switchViewAction
{
    if (self.cellItem.switchActionBlock) {
        self.cellItem.switchActionBlock(self.cellItem);
    }
}

#pragma mark - Getter & Setter

- (UILabel *)labelView
{
    if (!_labelView) {
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(0, 0, 150, 31);
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = kIM_Sub_Color;

        _labelView = lab;
    }
    return _labelView;
}

- (UISwitch *)switchView
{
    if (!_switchView) {
        UISwitch *swh = [[UISwitch alloc] init];
        [swh addTarget:self action:@selector(switchViewAction) forControlEvents:UIControlEventTouchUpInside];

        _switchView = swh;
    }
    return _switchView;
}

- (UITextField *)textFieldView
{
    if (!_textFieldView) {
        UITextField *txt = [[UITextField alloc] init];
        txt.frame = CGRectMake(0, 0, 150, 31);
        txt.borderStyle = UITextBorderStyleRoundedRect;
        txt.returnKeyType = UIReturnKeyDone;
        txt.textColor = UIColor.blackColor;
        txt.font = [UIFont systemFontOfSize:14];
        txt.delegate = self;

        _textFieldView = txt;
    }
    return _textFieldView;
}

- (void)setCellItem:(STTableViewCellItem *)cellItem
{
    self.textLabel.text = cellItem.title;
    self.detailTextLabel.text = cellItem.detail;

    switch (cellItem.style) {
        case STTableViewCellStyleNone: {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.accessoryView = nil;
        } break;
        case STTableViewCellStyleLabel: {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.accessoryView = self.labelView;
            self.labelView.text = cellItem.labelText;
        } break;
        case STTableViewCellStyleSwitch: {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.accessoryView = self.switchView;
            self.switchView.on = cellItem.checked;
        } break;
        case STTableViewCellStyleTextField: {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.accessoryView = self.textFieldView;
            self.textFieldView.text = cellItem.textFieldContent;
            self.textFieldView.enabled = cellItem.textFieldEditable;
        } break;
        default: {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.accessoryView = nil;
        } break;
    }
    self.accessoryView.tag = cellItem.tag;
    cellItem.cell = self;
    _cellItem = cellItem;
}

@end


@implementation UIScrollView (ScrollToBottom)

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGPoint contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
    if (contentOffset.y > 0) {
        [self setContentOffset:contentOffset animated:animated];
    }
}

@end


@implementation STDebugTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor greenColor];
        if ([self respondsToSelector:@selector(layoutManager)]) {
            self.layoutManager.allowsNonContiguousLayout = NO;
        }
        self.font = [UIFont systemFontOfSize:14];
        self.editable = NO;
    }
    return self;
}

- (void)appendText:(NSString *)text
{
    if (!text.length) {
        return;
    }
    if (!self.text.length) {
        self.text = text;
    } else {
        self.text = [NSString stringWithFormat:@"%@\n%@", self.text, text];
        [self scrollToBottomAnimated:YES];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    [self scrollRangeToVisible:NSMakeRange(self.text.length, 0)];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSString *selectorName = NSStringFromSelector(action);
    return [selectorName hasPrefix:@"copy"] || [selectorName hasPrefix:@"select"];
}

@end
