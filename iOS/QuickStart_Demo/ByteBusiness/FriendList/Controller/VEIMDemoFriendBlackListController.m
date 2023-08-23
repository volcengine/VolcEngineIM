//
//  VEIMDemoFriendBlackListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendBlackListController.h"
#import "BIMFriendListUserCell.h"

#import <im-uikit-tob/BIMUser.h>
#import <OneKit/BTDMacros.h>
#import <im-uikit-tob/BIMToastView.h>

@interface VEIMDemoFriendBlackListController () <BIMFriendListUserCellDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSArray *blacklist;
@property (nonatomic, copy) NSArray<NSArray *> *sectionData;
@property (nonatomic, copy) NSArray *sectionTitles;

@end

@implementation VEIMDemoFriendBlackListController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    self.tableview.sectionHeaderTopPadding = YES;
    [self.tableview registerClass:[BIMFriendListUserCell class] forCellReuseIdentifier:@"VEIMDemoFriendBlacklistUserCell"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"黑名单";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"拉黑" style:UIBarButtonItemStylePlain target:self action:@selector(addToBlacklist:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
}

- (void)prepareBlacklistDataWithBlacklist:(NSArray<BIMUser *> *)blacklist
{
    if (!self.blacklist) {
        self.blacklist = blacklist;
    }
    
    @weakify(self);
    dispatch_async(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        @strongify(self);
        NSMutableArray<NSString *> *sectionTitles = [@[] mutableCopy];
        NSMutableArray<NSArray *> *sectionData = [@[] mutableCopy];
        
        // 按首字母分组
        // 初始化
        NSMutableArray<NSString *> *localizedSectionsTitles = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] mutableCopy];
        [localizedSectionsTitles addObject:@"#"];
        NSMutableArray<NSMutableArray *> *indexedData = [NSMutableArray arrayWithCapacity:localizedSectionsTitles.count];
        [localizedSectionsTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexedData addObject:[NSMutableArray array]];
        }];
        
        // 分组
        [blacklist enumerateObjectsUsingBlock:^(BIMUser *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *firstLetter = [self getFirstPinyinLetterWithString:obj.nickName];
            if ([localizedSectionsTitles containsObject:firstLetter]) {
                [indexedData[[localizedSectionsTitles indexOfObject:firstLetter]] addObject:obj];
            } else {
                [indexedData[[localizedSectionsTitles indexOfObject:@"#"]] addObject:obj];
            }
        }];
        
        // 组内排序
        NSMutableArray<NSArray *> *indexedAndSortedData = [NSMutableArray arrayWithCapacity:indexedData.count];
        for (NSInteger i = 0; i < indexedData.count; i++) {
            indexedAndSortedData[i] = [indexedData[i] sortedArrayUsingComparator:^NSComparisonResult(BIMUser *  _Nonnull obj1, BIMUser *  _Nonnull obj2) {
                return [obj1.nickName localizedStandardCompare:obj2.nickName];
            }];
        }
        
        // 去掉空的section
        for (NSInteger i = indexedAndSortedData.count - 1; i >= 0; i--) {
            if (!indexedAndSortedData[i].count) {
                [indexedAndSortedData removeObjectAtIndex:i];
                [localizedSectionsTitles removeObjectAtIndex:i];
            }
        }
        
        [sectionTitles addObjectsFromArray:localizedSectionsTitles];
        [sectionData addObjectsFromArray:indexedAndSortedData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (!self) { return; }
            self.sectionData = sectionData;
            self.sectionTitles = sectionTitles;
            [self.tableview reloadData];
        });
    });
}

- (NSString *)getFirstPinyinLetterWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    // 转为带声调的拼音
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    // 转为不带声调的拼音
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    // 转为大写拼音
    NSString *pinyin = [str capitalizedString];
    // 返回首字母
    return [pinyin substringToIndex:1];
}

#pragma mark - TableViewDelegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMFriendListUserCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"VEIMDemoFriendBlacklistUserCell"];
    cell.friendInfo = self.sectionData[indexPath.section][indexPath.row];
    cell.delegate = self;
    return self;;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionData[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - BIMFriendListUserCellDelegate

- (void)cellDidLongPress:(BIMFriendListUserCell *)cell
{
    UIAlertController *alertVC = [[UIAlertController alloc] init];
    
    UIAlertAction *unmask = [UIAlertAction actionWithTitle:@"解除拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 解除拉黑operation
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:unmask];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)addToBlacklist:(id)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"添加黑名单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setPlaceholder:@"请输入uid"];
        textField.delegate = self;
        [textField addTarget:self action:@selector(addFriendTextFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // ⚠️输入框为空，toast提示：请输入uid（输入框不关闭）
        // ⚠️好友数量超过限制，toast提示：已超出好友数量上限。（输入框不关闭）
        // ⚠️uid不存在。toast提示：uid不存在，请重新输入。（输入框不关闭）
        // ⚠️该uid已经是该用户好友，toast提示：TA已经是你的好友，请重新输入（输入框不关闭）
        if (!vc.textFields[0].text || vc.textFields[0].text.length == 0) {
            [BIMToastView toast:@"请输入uid"];
            return;
        }
        
        // 请求成功关闭Toast
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:confirmAction];
    [vc addAction:cancelAction];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 拉黑textField限制输入数字
// 验证码输入框实时更新
- (void)addFriendTextFieldTextChanged:(UITextField *)textField
{
    // 获取当前光标位置
    NSUInteger currentCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    // 限制只能输入数字
    NSString *digitNumWithoutSpaces = [self removeNonDigitsWithInput:textField.text preserveCursorPosition:&currentCursorPosition];
    [textField setText:digitNumWithoutSpaces];
}

// 去除非数字字符
- (NSString *)removeNonDigitsWithInput:(NSString *)input preserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originPosition = *cursorPosition;
    NSMutableString *digitsString = [NSMutableString string];
    for (NSUInteger i = 0; i < input.length; i++) {
        unichar character = [input characterAtIndex:i];
        if (isdigit(character)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&character length:1];
            [digitsString appendString:stringToAdd];
        } else {
            if (i < originPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsString;
}

@end
