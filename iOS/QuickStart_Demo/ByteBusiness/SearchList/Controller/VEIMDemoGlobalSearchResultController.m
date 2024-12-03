//
//  VEIMDemoGlobalSearchResultController.m
//  ByteBusiness
//
//  Created by hexi on 2024/11/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoGlobalSearchResultController.h"

#import <Masonry/Masonry.h>
#import <imsdk-tob/BIMSDK.h>
#import <MJRefresh/MJRefresh.h>
#import <OneKit/ByteDanceKit.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>

#import "VEIMDemoChatViewController.h"
#import "VEIMDemoGlobalSearchDefine.h"
#import "VEIMDemoGlobalSearchResultCell.h"
#import "VEIMDemoGlobalSearchMoreResultController.h"

static NSInteger VEIMDemoGlobalSearchCellMaxShowCount = 3;

@interface VEIMDemoGlobalSearchResultController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *txtfSearch;
@property (nonatomic, strong) UITableView *tblResult;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, assign) VEIMDemoGlobalSearchType searchType;

@property (nonatomic, copy) NSArray<BIMSearchGroupInfo *> *groupInfoList;
@property (nonatomic, copy) NSArray<BIMSearchMsgInConvInfo *> *msgInfoList;
@property (nonatomic, copy) NSArray<BIMSearchFriendInfo *> *friendInfoList;
@property (nonatomic, copy) NSArray<NSNumber *> *needShowSearchResultType;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) BOOL canSearchEmptyGroup;

@end

@implementation VEIMDemoGlobalSearchResultController

- (instancetype)initWithKey:(NSString *)key
{
    self = [super init];
    if (self) {
        _groupInfoList = @[];
        _friendInfoList = @[];
        _msgInfoList = @[];
        _key = key;
        _limit = VEIMDemoGlobalSearchCellMaxShowCount + 1;
        _canSearchEmptyGroup = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self updateConstraints];
}

- (void)setupViews
{
    [self.view addSubview:self.txtfSearch];
    [self.view addSubview:self.tblResult];
    [self.view addSubview:self.emptyLabel];
}

- (void)setupUIElements
{
    [super setupUIElements];
    
    self.title = @"全局搜索";
    
#if DEBUG
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(canSearchEmptyGroupChange)];
    [self setRightBarButtonItemTitle];
#endif
}

- (void)setRightBarButtonItemTitle
{
    self.navigationItem.rightBarButtonItem.title = self.canSearchEmptyGroup ? @"含空会话" : @"不含空会话";
}

- (void)updateConstraints
{
    UIStatusBarManager *manager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
    CGFloat statusBarHeight = manager.statusBarFrame.size.height;
    CGFloat topOffset = self.navigationController.navigationBar.frame.size.height + statusBarHeight;
    [self.txtfSearch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(topOffset + 10);
        make.height.mas_equalTo(40);
    }];

    [self.tblResult mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtfSearch.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.emptyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtfSearch.mas_bottom).offset(150);
        make.left.right.equalTo(self.view);
    }];
}

- (void)reloadTable
{
    btd_dispatch_sync_on_main_queue(^{
        [self.tblResult reloadData];
    });
}

- (void)refreshEmptyLabel
{
    btd_dispatch_sync_on_main_queue(^{
        NSArray<NSNumber *> *needShowSearchResultType = [self getNeedShowSearchResultType];
        self.emptyLabel.hidden = BTD_isEmptyString(self.txtfSearch.text) ||  !BTD_isEmptyArray(needShowSearchResultType);
    });
}

- (void)canSearchEmptyGroupChange
{
    self.canSearchEmptyGroup = !self.canSearchEmptyGroup;
    [self setRightBarButtonItemTitle];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([self.key isEqualToString:textField.text]) {
        [self refreshEmptyLabel];
        return;
    }
    
    [self didSearchTextChange:textField.text];
}

- (void)didSearchTextChange:(NSString *)word
{
    word = [self getRealSearchKey];
    self.key = word;
    self.groupInfoList = @[];
    self.friendInfoList = @[];
    self.msgInfoList = @[];
    self.needShowSearchResultType = @[];
    [self refreshEmptyLabel];
    if (BTD_isEmptyString(word)) {
        [self reloadTable];
        return;
    }
    
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalGlobalMessage:word cursor:0 limit:self.limit completion:^(BIMSearchMsgInConvListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:word]) {
            dispatch_group_leave(group);
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            self.msgInfoList = result.searchMsgConvInfoList;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[BIMClient sharedInstance] searchLocalGlobalFriend:word cursor:0 limit:self.limit completion:^(BIMSearchFriendListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:word]) {
            dispatch_group_leave(group);
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            self.friendInfoList = result.friendInfoList;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[BIMClient sharedInstance] searchLocalGlobalGroup:word cursor:0 limit:self.limit completion:^(BIMSearchGroupListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:word]) {
            dispatch_group_leave(group);
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            self.groupInfoList = result.groupInfoList;
        }
        if (self.canSearchEmptyGroup && result.groupInfoList.count < VEIMDemoGlobalSearchCellMaxShowCount) {
            /// 会话数量不够且允许拉空会话时，拉一空会话列表
            [[BIMClient sharedInstance] searchLocalGlobalEmptyGroup:self.key cursor:0 limit:self.limit completion:^(BIMSearchGroupListResult * _Nullable result, BIMError * _Nullable error) {
                @strongify(self);
                if (![[self getRealSearchKey] isEqualToString:word]) {
                    return;
                }
                
                if (error) {
                    [BIMToastView toast:error.localizedDescription];
                } else  {
                    NSMutableArray *groupInfoList = [self.groupInfoList ?: @[] mutableCopy];
                    [groupInfoList addObjectsFromArray:result.groupInfoList];
                    self.groupInfoList = [groupInfoList copy];
                }
                dispatch_group_leave(group);
            }];
        } else {
            dispatch_group_leave(group);
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        NSArray<NSNumber *> *needShowSearchResultType = [self getNeedShowSearchResultType];
        self.needShowSearchResultType = needShowSearchResultType;
        [self refreshEmptyLabel];
        [self reloadTable];
    });
}

- (NSString *)getRealSearchKey
{
    return [self.txtfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray<NSNumber *> *)getNeedShowSearchResultType
{
    NSMutableArray<NSNumber *> *needShowSearchResultType = [NSMutableArray array];
    if (!BTD_isEmptyArray(self.friendInfoList)) {
        [needShowSearchResultType btd_addObject:@(VEIMDemoGlobalSearchTypeFriend)];
    }
    if (!BTD_isEmptyArray(self.groupInfoList)) {
        [needShowSearchResultType btd_addObject:@(VEIMDemoGlobalSearchTypeGroup)];
    }
    if (!BTD_isEmptyArray(self.msgInfoList)) {
        [needShowSearchResultType btd_addObject:@(VEIMDemoGlobalSearchTypeMessage)];
    }
    return [needShowSearchResultType copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.needShowSearchResultType.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    VEIMDemoGlobalSearchType searchType = [self.needShowSearchResultType btd_objectAtIndex:section].integerValue;
    if (searchType == VEIMDemoGlobalSearchTypeFriend) {
        return @"联系人";
    } else if (searchType == VEIMDemoGlobalSearchTypeGroup) {
        return @"群聊";
    } else if (searchType == VEIMDemoGlobalSearchTypeMessage) {
        return @"聊天记录";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VEIMDemoGlobalSearchType searchType = [self.needShowSearchResultType btd_objectAtIndex:section].integerValue;
    NSArray *dataArray;
    if (searchType == VEIMDemoGlobalSearchTypeFriend) {
        dataArray = self.friendInfoList;
    } else if (searchType == VEIMDemoGlobalSearchTypeGroup) {
        dataArray = self.groupInfoList;
    } else if (searchType == VEIMDemoGlobalSearchTypeMessage) {
        dataArray = self.msgInfoList;
    }
    if (dataArray.count > VEIMDemoGlobalSearchCellMaxShowCount + 1) {
        return VEIMDemoGlobalSearchCellMaxShowCount + 1;
    }
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == VEIMDemoGlobalSearchCellMaxShowCount ? 40 : 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoGlobalSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(VEIMDemoGlobalSearchResultCell.class)];
    if (!cell) {
        cell = [[VEIMDemoGlobalSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(BIMPortraitBaseCell.class)];
    }
    
    if (indexPath.row == VEIMDemoGlobalSearchCellMaxShowCount) {
        cell.nameLabel.text = @"查看更多";
        cell.onlyShowNameLabel = YES;
        [cell setupConstraints];
        return cell;
    }
    
    VEIMDemoGlobalSearchType searchType = [self.needShowSearchResultType btd_objectAtIndex:indexPath.section].integerValue;
    NSArray *dataArray;
    if (searchType == VEIMDemoGlobalSearchTypeFriend) {
        dataArray = self.friendInfoList;
        BIMSearchFriendInfo *friendInfo = [dataArray btd_objectAtIndex:indexPath.row];
        [cell reloadWithFriendInfo:friendInfo];
    } else if (searchType == VEIMDemoGlobalSearchTypeGroup) {
        dataArray = self.groupInfoList;
        BIMSearchGroupInfo *groupInfo = [dataArray btd_objectAtIndex:indexPath.row];
        [cell reloadWithGroupInfo:groupInfo];
    } else if (searchType == VEIMDemoGlobalSearchTypeMessage) {
        dataArray = self.msgInfoList;
        BIMSearchMsgInConvInfo *msgInConvInfo = [dataArray btd_objectAtIndex:indexPath.row];
        [cell reloadWithMsgInConvInfo:msgInConvInfo];
    }
    
    [cell setupConstraints];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoGlobalSearchType searchType = [self.needShowSearchResultType btd_objectAtIndex:indexPath.section].integerValue;
    
    if (indexPath.row == VEIMDemoGlobalSearchCellMaxShowCount) {
        /// 点击的查看更多
        VEIMDemoGlobalSearchMoreResultController *vc = [[VEIMDemoGlobalSearchMoreResultController alloc] initWithSearchType:searchType key:self.key limit:20];
        if (searchType == VEIMDemoGlobalSearchTypeGroup) {
            vc.canSearchEmptyGroup = self.canSearchEmptyGroup;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (searchType == VEIMDemoGlobalSearchTypeFriend) {
        BIMSearchFriendInfo *friendInfo = [self.friendInfoList btd_objectAtIndex:indexPath.row];
        @weakify(self);
        [[BIMClient sharedInstance] createSingleConversation:@(friendInfo.userInfo.uid)  completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
            @strongify(self);
            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
            btd_dispatch_async_on_main_queue(^{
                [self.navigationController pushViewController:chatVC animated:YES];
            });
        }];
        return;
    }
    
    if (searchType == VEIMDemoGlobalSearchTypeGroup) {
        BIMSearchGroupInfo *groupInfo = [self.groupInfoList btd_objectAtIndex:indexPath.row];
        VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:groupInfo.conversation];
        [self.navigationController pushViewController:chatVC animated:YES];
        return;
    }
    
    if (searchType == VEIMDemoGlobalSearchTypeMessage) {
        BIMSearchMsgInConvInfo *msgConvInfo = [self.msgInfoList btd_objectAtIndex:indexPath.row];
        if (msgConvInfo.count == 1) {
            /// 只搜到一条消息，直接跳转对应会话
            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:msgConvInfo.conversation];
            chatVC.anchorMessage = msgConvInfo.messageInfo.message;
            [self.navigationController pushViewController:chatVC animated:YES];
            return;
        }
        
        /// 会话搜到多条消息，跳转指定会话搜索页面
        VEIMDemoGlobalSearchMoreResultController *vc = [[VEIMDemoGlobalSearchMoreResultController alloc] initWithSearchType:searchType key:self.key limit:20];
        vc.conversation = msgConvInfo.conversation;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getter & Setter

- (UITextField *)txtfSearch
{
    if (!_txtfSearch) {
        UITextField *txtf = [[UITextField alloc] init];
        txtf.delegate = self;
        txtf.placeholder = @"搜索";
        txtf.clearButtonMode = UITextFieldViewModeAlways;

        txtf.leftViewMode = UITextFieldViewModeAlways;
        txtf.leftView = ({
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 34)];
            UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 14, 14)];
            leftImgView.image = [UIImage imageNamed:@"icon_search2"];
            [leftView addSubview:leftImgView];
            leftView;
        });

        _txtfSearch = txtf;
        [_txtfSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _txtfSearch;
}

- (UITableView *)tblResult
{
    if (!_tblResult) {
        UITableView *tbl = [[UITableView alloc] init];
        tbl.backgroundColor = kIM_View_Background_Color;
        tbl.dataSource = self;
        tbl.delegate = self;
        tbl.estimatedRowHeight = 100;
        tbl.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbl.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

        _tblResult = tbl;
    }
    return _tblResult;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        UILabel *label = [UILabel new];
        label.text = @"无结果";
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        _emptyLabel = label;
    }
    return _emptyLabel;
}

@end
