//
//  TTDebugItem.h
//  TTDebugCore
//
//  Created by 李琢鹏 on 2020/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, STTableViewCellStyle) {
    STTableViewCellStyleNone,
    STTableViewCellStyleLabel,
    STTableViewCellStyleSwitch,
    STTableViewCellStyleTextField,
};


@interface STTableViewCellItem : NSObject

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(__nullable SEL)action;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
//// Cell 点击时的响应事件
@property (nonatomic, weak) id target;

@property (nonatomic, strong) id contextInfo;

@property (nonatomic, copy) void (^actionBlock)(STTableViewCellItem *item);

@property (nonatomic, assign) STTableViewCellStyle style;

// Label
@property (nonatomic, copy) NSString *labelText;

// Switch
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) void (^switchActionBlock)(STTableViewCellItem *item);

// TextField
@property (nonatomic, assign) BOOL textFieldEditable;
@property (nonatomic) SEL textFieldAction;
@property (nonatomic, copy) NSString *textFieldContent;
@property (nonatomic) SEL textFieldBeginEditAction;

@property (nonatomic, assign) BOOL pickerViewStyle;

@property (nonatomic, assign) NSInteger tag;


@end


@interface STTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic, strong) UITextField *textFieldView;

@property (nonatomic, strong) STTableViewCellItem *cellItem;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *cellIndex;

@end


@interface STTableViewSectionItem : NSObject

- (instancetype)initWithSectionTitle:(NSString *)title items:(NSArray *)items;
- (instancetype)initWithSectionHeaderTitle:(NSString *)title footerTitle:(nullable NSString *)footerTitle items:(NSArray *)items;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) CGFloat headerHeight;

- (void)addCellItem:(STTableViewCellItem *)cellItem;
- (void)insertCellItem:(STTableViewCellItem *)cellItem atIndex:(NSUInteger)index;

@end


@interface UIScrollView (ScrollToBottom)

- (void)scrollToBottomAnimated:(BOOL)animated;

@end


@interface STDebugTextView : UITextView

- (void)appendText:(NSString *)text;

@end


@interface NSMutableArray (TTDebugCore)

- (void)ttd_insertObject:(id)anObject atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
