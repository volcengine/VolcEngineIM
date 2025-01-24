//
//  VEIMDemoMessageReadDetailViewController.m
//  ByteBusiness
//
//  Created by hexi on 2024/4/1.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoMessageReadDetailViewController.h"

#import <Masonry/Masonry.h>
#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>
#import <im-uikit-tob/BIMUser.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>
#import <im-uikit-tob/BIMUIClient.h>
#import <im-uikit-tob/BIMUICommonUtility.h>

#import "VEIMDemoUser.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoTestUserCell.h"
#import "VEIMDemoProfileEditViewController.h"

typedef NS_ENUM(NSInteger, BIMMessageReadDetailType) {
    DetailTypeRead = 0,
    DetailTypeUnread = 1,
};

@interface VEIMDemoMessageReadDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *readBtn;
@property (nonatomic, strong) UIButton *unreadBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *floatLineView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BIMMessage *message;
@property (nonatomic, strong) NSMutableArray<VEIMDemoUser *> *readUsers;
@property (nonatomic, strong) NSMutableArray<VEIMDemoUser *> *unreadUsers;
@property (nonatomic, assign) BIMMessageReadDetailType detailType;

@end

@implementation VEIMDemoMessageReadDetailViewController

- (instancetype)initWithMessage:(BIMMessage *_Nonnull)message
{
    if (self = [super init]) {
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<id<BIMMember>> *members = [[BIMClient sharedInstance] getConversationMemberList:self.message.conversationID];
        NSMutableDictionary<NSNumber *, id<BIMMember>> *memberDict = [NSMutableDictionary dictionary];
        [members enumerateObjectsUsingBlock:^(id<BIMMember>  _Nonnull member, NSUInteger idx, BOOL * _Nonnull stop) {
            [memberDict btd_setObject:member forKey:@(member.userID)];
        }];
        [[BIMClient sharedInstance] getMessagesReadReceipt:@[self.message] completion:^(NSArray<BIMMessageReadReceipt *> * _Nullable receiptList, BIMError * _Nullable error) {
            if (error) {
                NSString *errorToastString;
                if (error.code == BIM_SERVER_CONVERSATION_NOT_EXIST) {
                    errorToastString = @"已解散的会话无法查看消息阅读详情";
                } else if (error.code == BIM_SERVER_MESSAGE_EXPIRE) {
                    errorToastString = @"该消息已过期，不支持查看已读未读成员列表";
                } else if (error.code == BIM_SERVER_MESSAGE_RECEIPT_DISABLE) {
                    errorToastString = @"已读回执功能未开通";
                } else if (error.code == BIM_SERVER_READ_RECEIPT_GROUP_MEMBER_MORE_THAN_LIMIT) {
                    errorToastString = @"群人数超过已读回执支持人数";
                } else {
                    errorToastString = error.localizedDescription;
                }
                [BIMToastView toast:errorToastString];
                [self dismiss];
                return;
            }
            BIMMessageReadReceipt *receipt = receiptList.firstObject;
            [receipt.readMemberUidList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull uid, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.readUsers btd_addObject:[self getUserFromUid:uid.longLongValue withMemberDict:memberDict]];
            }];
            [receipt.unreadMemberUidList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull uid, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.unreadUsers btd_addObject:[self getUserFromUid:uid.longLongValue withMemberDict:memberDict]];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.readBtn setTitle:[NSString stringWithFormat:@"已读(%lu)", [self.readUsers count]] forState:UIControlStateNormal];
                [self.unreadBtn setTitle:[NSString stringWithFormat:@"未读(%lu)", [self.unreadUsers count]] forState:UIControlStateNormal];
                [self.tableView reloadData];
            });
        }];
    });
}

- (VEIMDemoUser *)getUserFromUid:(long long)uid withMemberDict:(NSDictionary<NSNumber *, id<BIMMember>> *)memberDict
{
    VEIMDemoUser *user = [[VEIMDemoUser alloc] init];
    BIMUser *u = [BIMUIClient sharedInstance].userProvider(uid);
    user.isNeedSelection = YES;
    user.avatarUrl = u.portraitUrl;
    user.userID = uid;
    user.portrait = [[VEIMDemoUserManager sharedManager] portraitForTestUser:uid];
    id<BIMMember> member = [memberDict btd_objectForKey:@(uid) default:nil];
    user.name = [BIMUICommonUtility getShowNameInGroupWithUser:u member:member];
    user.avatarUrl = member.avatarURL.length ? member.avatarURL : user.avatarUrl;
    if (member.role == BIM_MEMBER_ROLE_ADMIN) {
        user.role = @"管理员";
    }else if (member.role == BIM_MEMBER_ROLE_OWNER){
        user.role = @"群主";
    }
    return user;
}

- (void)setupUIElements
{
    [super setupUIElements];

    self.title = @"消息阅读状态";
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.readBtn];
    [self.topView addSubview:self.unreadBtn];
    [self.topView addSubview:self.lineView];
    [self.topView addSubview:self.floatLineView];
    [self.view addSubview:self.tableView];
    [self makeSubViewsConstraints];
}

- (void)makeSubViewsConstraints
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(self.navigationController.navigationBar.frame));
        make.height.equalTo(@47);
        make.width.equalTo(@(KScreenWidth));
    }];

    [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.width.equalTo(@(KScreenWidth / 2));
        make.height.equalTo(@44);
        make.bottom.equalTo(@0);
    }];

    [self.unreadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.width.height.equalTo(self.readBtn);
        make.bottom.equalTo(@0);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];

    [self.floatLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@35);
        make.height.equalTo(@2);
        make.bottom.equalTo(@-2);
        make.centerX.equalTo(self.readBtn);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(@0);
    }];
}

#pragma mark - Action

- (void)tapReadBtn:(UIButton *)btn
{
    if (self.detailType == DetailTypeUnread) {
        self.detailType = DetailTypeRead;
        self.readBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        self.unreadBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];

        [UIView animateWithDuration:0.3 animations:^{
            [self.floatLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@35);
                make.height.equalTo(@2);
                make.bottom.equalTo(@-2);
                make.centerX.equalTo(self.readBtn);
            }];
        }];
        [self.tableView reloadData];
    }
}

- (void)tabUnreadBtn:(UIButton *)btn
{
    if (self.detailType == DetailTypeRead) {
        self.detailType = DetailTypeUnread;
        self.readBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        self.unreadBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];

        [UIView animateWithDuration:0.3 animations:^{
            [self.floatLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@35);
                make.height.equalTo(@2);
                make.bottom.equalTo(@-2);
                make.centerX.equalTo(self.unreadBtn);
            }];
        }];
        [self.tableView reloadData];
    }
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEIMDemoTestUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoTestUserCell"];
    [cell hideCheckMark:YES];
    [cell hideSilentMark:YES];
    VEIMDemoUser *user = [(self.detailType == DetailTypeRead ? self.readUsers : self.unreadUsers) objectAtIndex:indexPath.row];
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VEIMDemoUser *user = [(self.detailType == DetailTypeRead ? self.readUsers : self.unreadUsers) objectAtIndex:indexPath.row];

    long long uid = user.userID;
    BIMUserProfile *profile = [[VEIMDemoUserManager sharedManager] fullInfoWithUserID:uid].userProfile;;
    if (!profile) {
        profile = [[BIMUserProfile alloc] init];
        profile.uid = uid;
    }
    VEIMDemoProfileEditViewController *vc = [[VEIMDemoProfileEditViewController alloc] initWithUserProfile:profile];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.detailType == DetailTypeRead ? self.readUsers : self.unreadUsers).count;
}

#pragma mark - Getter

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = kWhiteColor;
    }

    return _topView;
}

- (UIButton *)readBtn
{
    if (!_readBtn) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBtn setTitle:[NSString stringWithFormat:@"已读(%lu)", [self.readUsers count]] forState:UIControlStateNormal];
        _readBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        [_readBtn setTitleColor:kIM_Main_Color forState:UIControlStateNormal];
        [_readBtn addTarget:self action:@selector(tapReadBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _readBtn;
}

- (UIButton *)unreadBtn
{
    if (!_unreadBtn) {
        _unreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unreadBtn setTitle:[NSString stringWithFormat:@"未读(%lu)", [self.unreadUsers count]] forState:UIControlStateNormal];
        _unreadBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        [_unreadBtn setTitleColor:kIM_Main_Color forState:UIControlStateNormal];
        [_unreadBtn addTarget:self action:@selector(tabUnreadBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _unreadBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kIM_Line_Color;
    }

    return _lineView;
}

- (UIView *)floatLineView
{
    if (!_floatLineView) {
        _floatLineView = [[UIView alloc] init];
        _floatLineView.backgroundColor = kIM_Blue_Color;
    }
    return _floatLineView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[VEIMDemoTestUserCell class] forCellReuseIdentifier:@"VEIMDemoTestUserCell"];
    }
    return _tableView;
}

- (NSMutableArray<VEIMDemoUser *> *)readUsers
{
    if (!_readUsers) {
        _readUsers = [NSMutableArray array];
    }
    return _readUsers;
}

- (NSMutableArray<VEIMDemoUser *> *)unreadUsers
{
    if (!_unreadUsers) {
        _unreadUsers = [NSMutableArray array];
    }
    return _unreadUsers;
}

@end
