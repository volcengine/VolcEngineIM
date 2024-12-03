//
//  VEIMDemoGlobalSearchMoreResultController.m
//  ByteBusiness
//
//  Created by hexi on 2024/11/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoGlobalSearchMoreResultController.h"

#import <Masonry/Masonry.h>
#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>
#import <MJRefresh/MJRefresh.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>

#import "VEIMDemoUserManager.h"
#import "VEIMDemoGlobalSearchDefine.h"
#import "VEIMDemoChatViewController.h"
#import "VEIMDemoGlobalSearchResultCell.h"
#import "VEIMDemoProfileEditViewController.h"

@interface VEIMDemoGlobalSearchMoreResultController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *txtfSearch;
@property (nonatomic, strong) UITableView *tblResult;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) VEIMDemoGlobalSearchType searchType;

@property (nonatomic, copy) NSArray *infoList;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) long long nextCursor;
@property (nonatomic, strong) BIMMessage *anchorMessage;

@property (nonatomic, assign) long long nextEmptyGroupCursor;

@end

@implementation VEIMDemoGlobalSearchMoreResultController

- (instancetype)initWithSearchType:(VEIMDemoGlobalSearchType)searchType key:(NSString *)key limit:(NSInteger)limit
{
    self = [super init];
    if (self) {
        _searchType = searchType;
        _key = key;
        _limit = limit;
        _infoList = @[];
        _hasMore = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self updateConstraints];
    self.txtfSearch.text = self.key;
    [self didSearchTextChange:self.key];
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
    
    if (self.searchType == VEIMDemoGlobalSearchTypeFriend) {
        self.title = @"联系人";
    } else if (self.searchType == VEIMDemoGlobalSearchTypeGroup) {
        self.title = @"群组";
    } else if (self.searchType == VEIMDemoGlobalSearchTypeMessage) {
        self.title = @"消息";
    } else if (self.searchType == VEIMDemoGlobalSearchTypeGroup) {
        self.title = @"群成员";
    }

    self.tblResult.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerPulled)];
    [self.tblResult.mj_footer setState:MJRefreshStateNoMoreData];
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
        self.emptyLabel.hidden = BTD_isEmptyString(self.txtfSearch.text) || !BTD_isEmptyArray(self.infoList);
    });
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
    self.hasMore = YES;
    self.nextCursor = 0;
    self.anchorMessage = nil;
    self.infoList = @[];
    self.tblResult.mj_footer.hidden = YES;
    self.nextEmptyGroupCursor = 0;
    [self.tblResult.mj_footer resetNoMoreData];
    [self refreshEmptyLabel];
    if (BTD_isEmptyString(word)) {
        [self reloadTable];
        return;
    }
    
    [self loadMoreData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    VEIMDemoGlobalSearchType searchType = self.searchType;
    if (searchType == VEIMDemoGlobalSearchTypeFriend) {
        return @"联系人";
    } else if (searchType == VEIMDemoGlobalSearchTypeGroup) {
        return @"群聊";
    } else if (searchType == VEIMDemoGlobalSearchTypeMessage) {
        return @"聊天记录";
    } else if (searchType == VEIMDemoGlobalSearchTypeMember) {
        return @"群成员";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoGlobalSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(VEIMDemoGlobalSearchResultCell.class)];
    if (!cell) {
        cell = [[VEIMDemoGlobalSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(BIMPortraitBaseCell.class)];
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeFriend) {
        BIMSearchFriendInfo *friendInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        [cell reloadWithFriendInfo:friendInfo];
    } else if (self.searchType == VEIMDemoGlobalSearchTypeGroup) {
        BIMSearchGroupInfo *groupInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        [cell reloadWithGroupInfo:groupInfo];
    } else if (self.searchType == VEIMDemoGlobalSearchTypeMessage) {
        if (self.conversation) {
            BIMSearchMsgInfo *msgInfo = [self.infoList btd_objectAtIndex:indexPath.row];
            [cell reloadWithMsgInfo:msgInfo conversation:self.conversation];
        } else {
            BIMSearchMsgInConvInfo *msgInConvInfo = [self.infoList btd_objectAtIndex:indexPath.row];
            [cell reloadWithMsgInConvInfo:msgInConvInfo];
        }
    } else if (self.searchType == VEIMDemoGlobalSearchTypeMember) {
        BIMSearchMemberInfo *memberInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        [cell reloadWithMemberInfo:memberInfo];
    }
    
    [cell setupConstraints];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchType == VEIMDemoGlobalSearchTypeFriend) {
        BIMSearchFriendInfo *friendInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        [self enterConversationWithOppositeUserID:friendInfo.userInfo.uid];
        return;
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeGroup) {
        BIMSearchGroupInfo *groupInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:groupInfo.conversation];
        [self.navigationController pushViewController:chatVC animated:YES];
        return;
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeMessage) {
        
        if (self.conversation) {
            BIMSearchMsgInfo *msgInfo = [self.infoList btd_objectAtIndex:indexPath.row];
            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:self.conversation];
            chatVC.anchorMessage = msgInfo.message;
            [self.navigationController pushViewController:chatVC animated:YES];
            return;
        }
        
        BIMSearchMsgInConvInfo *msgConvInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        if (msgConvInfo.count == 1) {
            /// 只搜到一条消息，直接跳转对应会话
            VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:msgConvInfo.conversation];
            chatVC.anchorMessage = msgConvInfo.messageInfo.message;
            [self.navigationController pushViewController:chatVC animated:YES];
            return;
        }
        
        VEIMDemoGlobalSearchMoreResultController *vc = [[VEIMDemoGlobalSearchMoreResultController alloc] initWithSearchType:self.searchType key:self.key limit:20];
        vc.conversation = msgConvInfo.conversation;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeMember) {
        BIMSearchMemberInfo *memberInfo = [self.infoList btd_objectAtIndex:indexPath.row];
        BIMUserProfile *profile = [[VEIMDemoUserManager sharedManager] fullInfoWithUserID:memberInfo.member.userID].userProfile;
        VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserProfile:profile];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

# pragma mark - footer refresh
- (void)footerPulled
{
    [self loadMoreData];
}

- (void)loadMoreData
{
    if (self.searchType == VEIMDemoGlobalSearchTypeMessage) {
        if (self.conversation) {
            [self loadMoreMessageInConversation];
        } else {
            [self loadMoreGlobalMessage];
        }
        return;
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeGroup) {
        [self loadMoreGlobalGroup];
        return;
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeFriend) {
        [self loadMoreGlobalFriend];
        return;
    }
    
    if (self.searchType == VEIMDemoGlobalSearchTypeMember) {
        if (self.conversation) {
            [self loadMoreMemberInConversation];
        }
        return;
    }
}

- (void)loadMoreMessageInConversation
{
    BIMGetMessageByTypeOption *option = [[BIMGetMessageByTypeOption alloc] init];
    option.anchorMessage = self.anchorMessage;
    option.limit = self.limit;
    option.direction = BIM_PULL_DIRECTION_DESC;
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalMessage:self.conversation.conversationID key:self.key option:option completion:^(NSArray<BIMSearchMsgInfo *> * _Nullable infos, BOOL hasMore, BIMSearchMsgInfo * _Nullable anchorMessage, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:self.key]) {
            return;
        }
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            NSMutableArray *infoList = [self.infoList mutableCopy];
            [infoList addObjectsFromArray:infos];
            self.infoList = [infoList copy];
        }
        
        self.anchorMessage = anchorMessage.message;
        self.hasMore = hasMore;
        [self refreshEmptyLabel];
        self.tblResult.mj_footer.hidden = !infos.count;
        if (self.hasMore) {
            [self.tblResult.mj_footer endRefreshing];
        } else {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadTable];
    }];
}

- (void)loadMoreGlobalMessage
{
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalGlobalMessage:self.key cursor:self.nextCursor limit:self.limit completion:^(BIMSearchMsgInConvListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:self.key]) {
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            NSMutableArray *infoList = [self.infoList mutableCopy];
            [infoList addObjectsFromArray:result.searchMsgConvInfoList];
            self.infoList = [infoList copy];
        }
        
        self.hasMore = result.hasMore;
        self.nextCursor = result.nextCursor;
        [self refreshEmptyLabel];
        self.tblResult.mj_footer.hidden = !self.infoList.count;
        if (self.hasMore) {
            [self.tblResult.mj_footer endRefreshing];
        } else {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadTable];
    }];
}

- (void)loadMoreGlobalGroup
{
    if (!self.hasMore && self.canSearchEmptyGroup) {
        [self loadMoreEmptyGroup];
        return;
    }
    
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalGlobalGroup:self.key cursor:self.nextCursor limit:self.limit completion:^(BIMSearchGroupListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:self.key]) {
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else  {
            NSMutableArray *infoList = [self.infoList mutableCopy];
            [infoList addObjectsFromArray:result.groupInfoList];
            self.infoList = [infoList copy];
        }
        
        self.hasMore = result.hasMore;
        self.nextCursor = result.nextCursor;
        [self refreshEmptyLabel];
        self.tblResult.mj_footer.hidden = !self.infoList.count;
        if (self.canSearchEmptyGroup && result.groupInfoList.count < self.limit) {
            [self loadMoreEmptyGroup];
        } else {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
            [self reloadTable];
        }
    }];
}

- (void)loadMoreEmptyGroup
{
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalGlobalEmptyGroup:self.key cursor:self.nextEmptyGroupCursor limit:self.limit completion:^(BIMSearchGroupListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:self.key]) {
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else  {
            NSMutableArray *infoList = [self.infoList mutableCopy];
            [infoList addObjectsFromArray:result.groupInfoList];
            self.infoList = [infoList copy];
        }
        
        self.hasMore = result.hasMore;
        self.nextEmptyGroupCursor = result.nextCursor;
        [self refreshEmptyLabel];
        self.tblResult.mj_footer.hidden = !self.infoList.count;
        if (self.hasMore) {
            [self.tblResult.mj_footer endRefreshing];
        } else {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadTable];
    }];
}

- (void)loadMoreGlobalFriend
{
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalGlobalFriend:self.key cursor:self.nextCursor limit:self.limit completion:^(BIMSearchFriendListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:self.key]) {
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else  {
            NSMutableArray *infoList = [self.infoList mutableCopy];
            [infoList addObjectsFromArray:result.friendInfoList];
            self.infoList = [infoList copy];
        }
        
        self.hasMore = result.hasMore;
        self.nextCursor = result.nextCursor;
        [self refreshEmptyLabel];
        self.tblResult.mj_footer.hidden = !self.infoList.count;
        if (self.hasMore) {
            [self.tblResult.mj_footer endRefreshing];
        } else {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadTable];
    }];
}

- (void)loadMoreMemberInConversation
{
    @weakify(self);
    [[BIMClient sharedInstance] searchLocalGroupMember:self.conversation.conversationID key:self.key cursor:self.nextCursor limit:self.limit completion:^(BIMSearchGroupMemberListResult * _Nullable result, BIMError * _Nullable error) {
        @strongify(self);
        if (![[self getRealSearchKey] isEqualToString:self.key]) {
            return;
        }
        
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            NSMutableArray *infoList = [self.infoList mutableCopy];
            [infoList addObjectsFromArray:result.memberInfoList];
            self.infoList = [infoList copy];
        }
        
        self.hasMore = result.hasMore;
        self.nextCursor = result.nextCursor;
        [self refreshEmptyLabel];
        self.tblResult.mj_footer.hidden = !self.infoList.count;
        if (self.hasMore) {
            [self.tblResult.mj_footer endRefreshing];
        } else {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
        }
        [self reloadTable];
    }];
}

#pragma mark - Private

- (NSString *)getRealSearchKey
{
    return [self.txtfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)enterConversationWithOppositeUserID:(long long)oppositeUserID
{
    @weakify(self);
    [[BIMClient sharedInstance] createSingleConversation:@(oppositeUserID)  completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
        @strongify(self);
        VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
        btd_dispatch_async_on_main_queue(^{
            [self.navigationController pushViewController:chatVC animated:YES];
        });
    }];
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
