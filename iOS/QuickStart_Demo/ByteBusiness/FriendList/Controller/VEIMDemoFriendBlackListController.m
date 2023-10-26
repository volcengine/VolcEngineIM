//
//  VEIMDemoFriendBlackListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFriendBlackListController.h"
#import "VEIMDemoBlackListUserCell.h"
#import "VEIMDemoFriendBlackListDataSource.h"
#import "UIAlertController+Dismiss.h"
#import "VEIMDemoIMManager.h"

#import <im-uikit-tob/BIMUser.h>
#import <OneKit/BTDMacros.h>
#import <im-uikit-tob/BIMToastView.h>
#import <imsdk-tob/BIMClient+Friend.h>

@interface VEIMDemoFriendBlackListController () <UITextFieldDelegate, VEIMDemoBlackListDataSourceDelegate, VEIMDemoBlackListUserCellDelegate>

@property (nonatomic, copy) NSArray<BIMBlackListFriendInfo *>*blacklist;
@property (nonatomic, copy) NSArray<NSArray *> *sectionData;
@property (nonatomic, copy) NSArray *sectionTitles;

@property (nonatomic, strong) VEIMDemoFriendBlackListDataSource *dataSource;
@property (nonatomic, strong) dispatch_queue_t blackListUpdateQueue;

@end

@implementation VEIMDemoFriendBlackListController

- (instancetype)init
{
    if (self = [super init]) {
        _blacklist = [NSArray array];
        _blackListUpdateQueue = dispatch_queue_create("blackList.ui.update.queue", DISPATCH_QUEUE_SERIAL);
        _dataSource = [[VEIMDemoFriendBlackListDataSource alloc] init];
        _dataSource.delegate = self;
    }
    return self;
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    self.tableview.sectionHeaderTopPadding = YES;
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[VEIMDemoBlackListUserCell class] forCellReuseIdentifier:@"VEIMDemoFriendBlackListUserCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"黑名单";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"拉黑" style:UIBarButtonItemStylePlain target:self action:@selector(addToBlackList:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    // 数据库获取加载全量黑名单列表
    [self.dataSource loadBlackListWithCompletion:nil];
    
}

- (void)prepareBlackListDataWithBlackList:(NSArray<BIMBlackListFriendInfo *> *)blacklist
{
    if (!self.blacklist) {
        self.blacklist = blacklist;
    }
    
    @weakify(self);
    dispatch_async(self.blackListUpdateQueue, ^{
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
        [blacklist enumerateObjectsUsingBlock:^(BIMBlackListFriendInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *displayName = (obj.alias && obj.alias.length) ? obj.alias : [NSString stringWithFormat:@"用户%@", @(obj.uid)];
            NSString *firstLetter = [self getFirstPinyinLetterWithString:displayName];
            if ([localizedSectionsTitles containsObject:firstLetter]) {
                [indexedData[[localizedSectionsTitles indexOfObject:firstLetter]] addObject:obj];
            } else {
                [indexedData[[localizedSectionsTitles indexOfObject:@"#"]] addObject:obj];
            }
        }];
        
        // 组内排序
        NSMutableArray<NSArray *> *indexedAndSortedData = [NSMutableArray arrayWithCapacity:indexedData.count];
        for (NSInteger i = 0; i < indexedData.count; i++) {
            indexedAndSortedData[i] = [indexedData[i] sortedArrayUsingComparator:^NSComparisonResult(BIMBlackListFriendInfo *  _Nonnull obj1, BIMBlackListFriendInfo *  _Nonnull obj2) {
                return [@(obj1.uid).stringValue localizedStandardCompare:@(obj2.uid).stringValue];
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
            self.sectionData = [sectionData copy];
            self.sectionTitles = [sectionTitles copy];
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
    VEIMDemoBlackListUserCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"VEIMDemoFriendBlackListUserCell"];
    cell.blackInfo = self.sectionData[indexPath.section][indexPath.row];
    cell.delegate = self;
    
    return cell;
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

#pragma mark - VEIMDemoBlackListUserCellDelegate

- (void)cellDidLongPress:(VEIMDemoBlackListUserCell *)cell
{
    UIAlertController *alertVC = [[UIAlertController alloc] init];
    
    UIAlertAction *unmask = [UIAlertAction actionWithTitle:@"解除拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 解除拉黑operation
        [[BIMClient sharedInstance] deleteFromBlackList:cell.blackInfo.uid completion:^(BIMError * _Nullable error) {
            if (error) {
                NSString *toastStr = error.localizedDescription;
                if (error.code == BIM_SERVER_ALREADY_BEEN_REMOVED) {
                    toastStr = @"用户已被移出黑名单";
                }
                [BIMToastView toast:toastStr];
            } else {
                [BIMToastView toast:@"操作成功"];
            }
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:unmask];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)addToBlackList:(id)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"添加黑名单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setPlaceholder:@"请输入uid"];
        textField.delegate = self;
        [textField addTarget:self action:@selector(addFriendTextFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    vc.wontDismiss = YES;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // ⚠️输入框为空，toast提示：请输入uid（输入框不关闭）
        NSString *input = vc.textFields[0].text;
        if (!input || input.length == 0) {
            [BIMToastView toast:@"请输入uid"];
            return;
        }
        // ⚠️黑名单数量超过限制，toast提示：已超出黑名单数量上限。（输入框不关闭）
        // ⚠️uid不存在。toast提示：uid不存在，请重新输入。（输入框不关闭）
        // ⚠️该uid已在黑名单，toast提示：TA已经被你拉黑，请重新输入（输入框不关闭）
        [self checkUserExist:input.longLongValue completion:^(BOOL exist) {
            if (!exist) {
                [BIMToastView toast:@"uid不存在，请重新输入"];
            } else {
                // 存在就发送拉黑请求
                BIMBlackListFriendInfo *blackInfo = [[BIMBlackListFriendInfo alloc] init];
                blackInfo.uid = input.longLongValue;
                [[BIMClient sharedInstance] addToBlackList:blackInfo completion:^(BIMError * _Nullable error) {
                    if (error) {
                        NSString *toastStr = error.localizedDescription;
                        if (error.code == BIM_SERVER_ALREADY_IN_BLACK) {
                            toastStr = @"TA已经被你拉黑，请重新输入";
                        } else if (error.code == BIM_SERVER_BLACK_MORE_THAN_LIMIT) {
                            toastStr = @"已超出黑名单数量上限";
                        } else if (error.code == BIM_SERVER_ADD_SELF_BLACK_NOT_ALLOW) {
                            toastStr = @"自己不能拉黑自己";
                        }
                        [BIMToastView toast:[NSString stringWithFormat:@"%@", toastStr]];
                    } else {
                        // 请求成功关闭alert
                        [BIMToastView toast:@"操作成功"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:confirmAction];
    [vc addAction:cancelAction];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Check

- (void)checkUserExist:(long long)uid completion:(void (^)(BOOL exist))completion
{
    if (!completion) {
        return;
    }
    
    [[VEIMDemoIMManager sharedManager].accountProvider checkUserExist:uid completion:^(BOOL exist, NSError * _Nonnull error) {
        if (error) {
            [BIMToastView toast:error.localizedDescription];
            completion(NO);
            return;
        }
        if (!exist) {
            [BIMToastView toast:@"该用户不存在"];
            completion(NO);
            return;
        }
        
        completion(YES);
    }];
    
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

#pragma mark - VEIMDemoFriendBlackListDataSource

- (void)blackListDataSourceDidReloadBlackList:(VEIMDemoFriendBlackListDataSource *)dataSource
{
    self.blacklist = [dataSource.blackList copy];
    [self prepareBlackListDataWithBlackList:[self.blacklist copy]];
}

@end
