//
//  BIMFriendListController.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMFriendListController.h"
#import "BIMFriendListDataSource.h"
#import "BIMFriendListHeaderCell.h"
#import "VEIMDemoFriendApplyListController.h"
#import "BIMFriendListUserCell.h"
#import "VEIMDemoFriendBlackListController.h"
#import "VEIMDemoChatViewController.h"
#import "VEIMDemoDefine.h"

//#import <im-uikit-tob/BIMUserCell.h>
#import <im-uikit-tob/BIMUser.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMClient+conversation.h>
#import <imsdk-tob/BIMClient+Friend.h>
#import <im-uikit-tob/BIMToastView.h>


@interface BIMFriendListController () <UITableViewDelegate, UITableViewDataSource, BIMFriendListUserCellDelegate, BIMFriendListDataSourceDelegate>

@property (nonatomic, strong) BIMFriendListDataSource *dataSource;
@property (nonatomic, copy) NSArray<BIMFriendInfo *> *allFriends;
@property (nonatomic, copy) NSArray<NSArray *> *sectionData;
@property (nonatomic, copy) NSArray *sectionTitles;
@property (nonatomic, strong) dispatch_queue_t updateQueue;
//@property (nonatomic, strong) NSMutableArray *mutArr;
//@property (nonatomic, strong) UIView *emptyView;

@end

@implementation BIMFriendListController

- (instancetype)init
{
    if (self = [super init]) {
        _updateQueue = dispatch_queue_create("friendList.ui.update.queue", DISPATCH_QUEUE_SERIAL);
        _allFriends = [NSArray array];
        _dataSource = [[BIMFriendListDataSource alloc] init];
        _dataSource.delegate = self;
    }
    return self;
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    [self.tableview registerClass:[BIMFriendListUserCell class] forCellReuseIdentifier:@"BIMFriendListUserCell"];
    [self.tableview registerClass:[BIMFriendListHeaderCell class] forCellReuseIdentifier:@"BIMFriendListHeaderCell"];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // 去除section之间的空白间隙
    self.tableview.sectionHeaderTopPadding = YES;
}

- (void)registerNotification
{
    [super registerNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:kVEIMDemoUserDidLogoutNotification object:nil];
}

- (void)didReceiveNoti:(NSNotification *)noti
{
    if ([noti.name isEqualToString:kVEIMDemoUserDidLoginNotification]) {
        [self userDidLogin];
    }else if ([noti.name isEqualToString:kVEIMDemoUserDidLogoutNotification]){
        [self userDidLogout];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    获取好友列表接口
    [self.dataSource loadFriendListWithCompletion:nil];
    // 获取好友申请未读数
    [self.dataSource getFriendApplyUnreadCount];
}

- (void)userDidLogin
{
    self.dataSource = [[BIMFriendListDataSource alloc] init];
    self.dataSource.delegate = self;
    [self.dataSource loadFriendListWithCompletion:nil];
    [self.dataSource getFriendApplyUnreadCount];
}

- (void)userDidLogout
{
    self.dataSource = nil;
    [self prepareAndDisplayFriendListDataWithAllFriends:nil];
}

// TODO: 后续可优化，增删改。增只对该分组进行排序，删定点删除不重新分组排序，改同增
- (void)prepareAndDisplayFriendListDataWithAllFriends:(NSArray<BIMFriendInfo *> *)allFriends
{
    if (!self.allFriends) {
        self.allFriends = allFriends;
    }
    
    @weakify(self);
    dispatch_async(self.updateQueue, ^{
        @strongify(self);
        NSMutableArray<NSString *> *sectionTitles = [@[] mutableCopy];
        NSMutableArray<NSArray *> *sectionData = [@[] mutableCopy];
        
        // 好友申请 && 黑名单 Cell
        [sectionTitles addObject:@""];
        [sectionData addObject:@[@(BIMFriendListHeaderApply),
                                 @(BIMFriendListHeaderBlackList)]];
        
        // 按首字母分组
        // 初始化
        NSMutableArray<NSString *> *localizedSectionsTitles = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] mutableCopy];
        [localizedSectionsTitles addObject:@"#"];
        NSMutableArray<NSMutableArray *> *indexedData = [NSMutableArray arrayWithCapacity:localizedSectionsTitles.count];
        [localizedSectionsTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexedData addObject:[NSMutableArray array]];
        }];
        
        // 分组
        [allFriends enumerateObjectsUsingBlock:^(BIMFriendInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *firstLetter = [self getFirstPinyinLetterWithString:[NSString stringWithFormat:@"用户%@",@(obj.uid).stringValue]];  // TODO: 一期暂时没有昵称，先用uid
            if ([localizedSectionsTitles containsObject:firstLetter]) {
                [indexedData[[localizedSectionsTitles indexOfObject:firstLetter]] addObject:obj];
            } else {
                [indexedData[[localizedSectionsTitles indexOfObject:@"#"]] addObject:obj];
            }
        }];
        
        // 组内排序
        NSMutableArray<NSArray *> *indexedAndSortedData = [NSMutableArray arrayWithCapacity:indexedData.count];
        for (NSInteger i = 0; i < indexedData.count; i++) {
            indexedAndSortedData[i] = [indexedData[i] sortedArrayUsingComparator:^NSComparisonResult(BIMFriendInfo *  _Nonnull obj1, BIMFriendInfo *  _Nonnull obj2) {
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
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinyin = [str capitalizedString];
    return [pinyin substringToIndex:1];
}

#pragma mark - TableViewDelegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BIMFriendListHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"BIMFriendListHeaderCell"];
        BIMFriendListHeaderCellType cellType = [self.sectionData[indexPath.section][indexPath.row] integerValue];
        [headerCell configWithType:cellType];
        if (cellType == BIMFriendListHeaderApply) {
            [headerCell showBadgeWithNum:@(self.dataSource.unreadCount)];  // qfmark 展示好友申请未读数
        }
        return headerCell;
    }
    
    BIMFriendListUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMFriendListUserCell"];
    cell.friendInfo = self.sectionData[indexPath.section][indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        BIMFriendListHeaderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.type == BIMFriendListHeaderApply) {
            // TODO: 点击进去，清空好友申请未读
            
            VEIMDemoFriendApplyListController *vc = [[VEIMDemoFriendApplyListController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        } else if (cell.type == BIMFriendListHeaderBlackList) {
            VEIMDemoFriendBlackListController *vc = [[VEIMDemoFriendBlackListController alloc] init];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    } else {
        // 点击跳转对应单聊会话
        BIMFriendListUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        long long uid = cell.friendInfo.uid;
        [[BIMClient sharedInstance] createSingleConversation:@(uid) completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"进入会话失败"]];
            } else {
                VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
                [self.navigationController pushViewController:chatVC animated:YES];
            }
        }];
    }
}

#pragma mark - BIMFriendListUserCellDelegate
- (void)cellDidLongPress:(BIMFriendListUserCell *)cell
{
    UIAlertController *alertVC = [[UIAlertController alloc] init];
    
    /// 点击删除好友
    /// 再次弹出提醒，二次确定
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self confirmAgainDeleteFriend:cell];
        }];
        
    }];
    
    UIAlertAction *modifyRemark = [UIAlertAction actionWithTitle:@"修改好友备注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self modifyFriendRemark];
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:delete];
    [alertVC addAction:modifyRemark];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/// 二次删除好友确定
/// 点击“取消”，关闭弹窗，无事发生
/// 点击“确定”，toast：操作成功。 关闭弹窗。 双方通讯录列表移除对方
- (void)confirmAgainDeleteFriend:(BIMFriendListUserCell *)cell
{
    UIAlertController *alertAgainVC = [UIAlertController alertControllerWithTitle:nil message:@"删除好友意味着你与对方互相解除好友关系" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @weakify(self);
        [[BIMClient sharedInstance] deleteFriend:cell.friendInfo.uid completion:^(BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"删除失败: %@",error.localizedDescription]];
            } else {
                // 删除对应好友会话，对端保留
                [[BIMClient sharedInstance] deleteConversationWithToUid:@(cell.friendInfo.uid) completion:nil];
                [BIMToastView toast:@"操作成功"];
//                [self.tableview reloadData];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertAgainVC addAction:confirm];
    [alertAgainVC addAction:cancel];
    
    [self presentViewController:alertAgainVC animated:YES completion:nil];
}

- (void)modifyFriendRemark
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改好友备注" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // TODO: 输入框应该填充当前的备注名
        textField.placeholder = @"输入备注" ;
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // TODO: 备注长度如果超出限制。toast提示：不能超过X字符。弹窗不关闭
        // 此处要接风控
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - BIMFriendListDataSource

- (void)friendListDataSourceDidReloadFriendList:(BIMFriendListDataSource *)dataSource
{
    self.allFriends = [dataSource.friendList copy];
    [self prepareAndDisplayFriendListDataWithAllFriends:[self.allFriends copy]];
}

- (void)friendListDataSource:(BIMFriendListDataSource *)dataSource onApplyUnreadCountChanged:(NSInteger)unreadCount
{
    // TODO: 可优化
    [self.tableview reloadData];
}


@end