//
//  SSDebugViewControllerBase.m
//  Article
//
//  Created by liufeng on 2017/8/14.
//
//


#import "SSDebugViewControllerBase.h"
#import <OneKit/ByteDanceKit.h>


@interface SSDebugViewControllerBase ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForResignFirstResponder;
@property (nonatomic, assign) CGFloat viewNeedOffsetY;
@end


@implementation UIView (TTDebugCore)


- (UIResponder *)ttd_findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView ttd_findFirstResponder];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

@end


@implementation SSDebugViewControllerBase

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setupTableView];

    self.tapGestureForResignFirstResponder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResignFirstResponder)];
    _tapGestureForResignFirstResponder.numberOfTapsRequired = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)_setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.userInteractionEnabled = YES;
    CGFloat top = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.tableView.frame = CGRectMake(0, 64, self.view.btd_width, self.view.btd_height - top);
    [self.view addSubview:self.tableView];

    self.extendedLayoutIncludesOpaqueBars = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 13.0, *)) {
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }

    [self.tableView registerClass:[STTableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

#pragma mark - textFieldResignFirstResponder
- (void)textFieldResignFirstResponder
{
    //    UIResponder *responder = [self.view ttd_findFirstResponder];
    //    if ([responder isKindOfClass:[SSThemedTextField class]]) {
    //        [responder resignFirstResponder];
    //    }
}

#pragma mark - keyboard show or hide
- (void)keyboardWillShow:(NSNotification *)notification
{
    //    if (self.disableKeyboardNotificationHandling) {
    //        return;
    //    }
    //    [self.tableView addGestureRecognizer:_tapGestureForResignFirstResponder];
    //    NSDictionary *userInfo = [notification userInfo];
    //    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    UIResponder *responder = [self.view ttd_findFirstResponder];
    //    SSThemedTextField *firstResponder = (SSThemedTextField *)responder;
    //    CGRect firstResponderRect = [self.view convertRect:firstResponder.frame fromView:firstResponder.superview];
    //    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    //    self.viewNeedOffsetY = firstResponderRect.size.height + firstResponderRect.origin.y - keyboardRect.origin.y;
    //    CGSize  newTableViewContentSize = self.tableView.contentSize;
    //    newTableViewContentSize.height += keyboardRect.size.height;
    //    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSTimeInterval animationDuration;
    //    [animationDurationValue getValue:&animationDuration];
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:animationDuration];
    //    if (self.viewNeedOffsetY > 0) {
    //        [self.tableView setContentSize:newTableViewContentSize];
    //        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + keyboardRect.size.height)];
    //    }
    //    [UIView commitAnimations];
}


#define kClearCacheHeightNotification @"kClearCacheHeightNotification"
#define kSettingFontSizeChangedAheadNotification @"kSettingFontSizeChangedAheadNotification"
#define kSettingFontSizeChangedNotification @"kSettingFontSizeChangedNotification"

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.disableKeyboardNotificationHandling) {
        return;
    }
    [self.tableView removeGestureRecognizer:_tapGestureForResignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kClearCacheHeightNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingFontSizeChangedAheadNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingFontSizeChangedNotification object:self];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    CGFloat keyboardHeight = keyboardRect.size.height;
    CGSize oldTableViewContentSize = self.tableView.contentSize;
    oldTableViewContentSize.height -= keyboardHeight;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    if (self.viewNeedOffsetY > 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - keyboardRect.size.height)];
        [self.tableView setContentSize:oldTableViewContentSize];
    }
    [UIView commitAnimations];
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STTableViewSectionItem class]]) {
        return sectionItem.headerTitle;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    return sectionItem.headerHeight > 0 ? sectionItem.headerHeight : ([sectionItem.headerTitle length] ? 38.0 : 0);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STTableViewSectionItem class]]) {
        return sectionItem.footerTitle;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STTableViewSectionItem class]]) {
        return sectionItem.items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STTableViewCell *tableViewCell = (STTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:indexPath.section];
    STTableViewCellItem *item = sectionItem.items[indexPath.row];
    if ([item isKindOfClass:[STTableViewCellItem class]]) {
        tableViewCell.tableView = tableView;
        tableViewCell.cellIndex = indexPath;
        tableViewCell.cellItem = item;
    } else {
        tableViewCell.textLabel.text = @"配置出现问题";
    }
    return tableViewCell;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return;
    }
    UILabel *textLabel = ((UITableViewHeaderFooterView *)view).textLabel;
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STTableViewSectionItem class]]) {
        textLabel.text = sectionItem.headerTitle;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return;
    }
    UILabel *textLabel = ((UITableViewHeaderFooterView *)view).textLabel;
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STTableViewSectionItem class]]) {
        textLabel.text = sectionItem.footerTitle;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    STTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:indexPath.section];
    STTableViewCellItem *item = sectionItem.items[indexPath.row];
    if ([item isKindOfClass:[STTableViewCellItem class]]) {
        if (item.actionBlock) {
            item.actionBlock(item);
        }
        [self.tableView reloadData];
    }
}

@end
