//
//  VEIMDemoConversationListController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/10/26.
//


#import "VEIMDemoConversationListController.h"
#import "BIMConversationListController.h"
#import "VEIMDemoCommonMenu.h"
#import "VEIMDemoDefine.h"
#import "VEIMDemoUserSelectionController.h"
#import "VEIMDemoUserManager.h"
#import "VEIMDemoChatViewController.h"
#import "VEIMDemoSelectUserViewController.h"
#import "BIMToastView.h"
#import "VEIMDemoConversationListSelectionCollectionView.h"
#import <imsdk-tob/BIMSDK.h>
#import <im-uikit-tob/BIMFriendConversationListController.h>
#import <Masonry/View+MASShorthandAdditions.h>
#import "VEIMDemoGlobalSearchResultController.h"
#import "VEIMDemoRobotListController.h"
#import "VEIMDemoIMManager.h"

@interface VEIMDemoConversationListController () <VEIMDemoUserSelectionControllerDelegate, BIMConversationListControllerDelegate, VEIMDemoConversationListSelectionDelegate>
@property (nonatomic, strong) VEIMDemoCommonMenu *menu;
@property (nonatomic, strong) UIButton *txtfSearchBtn;
@property (nonatomic, strong) VEIMDemoConversationListSelectionCollectionView *selectionView;
@property (nonatomic, strong) UIView *curConvListView;
@property (nonatomic, strong) BIMBaseConversationListController *curConvListController;
@property (nonatomic, strong) BIMConversationListController *allConvListController;
@property (nonatomic, strong) BIMFriendConversationListController *friendConListController;
@end

@implementation VEIMDemoConversationListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerNotification];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"IM Demo";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.txtfSearchBtn];
    [self.view addSubview:self.selectionView];
    [self setupConvListControllers];
    [self makeSubViewsConstraints];
}

- (void)setupConvListControllers
{
    BIMConversationListController *allConvListController = [[BIMConversationListController alloc] init];
    allConvListController.delegate = self;
    if ([VEIMDemoIMManager sharedManager].accountProvider.accountType != VEIMDemoAccountTypeOpenSource) {
        allConvListController.stickOnTopRobotUserID = @(999880);
    }
    
    self.allConvListController = allConvListController;
    /// 默认选择全部会话列表
    self.curConvListController = self.allConvListController;
    [self addChildViewController:self.curConvListController];
    self.curConvListView = self.curConvListController.view;
    [self.view addSubview:self.curConvListView];

    self.friendConListController = [[BIMFriendConversationListController alloc] init];
    self.friendConListController.delegate = self;
}

- (void)makeSubViewsConstraints
{
    UIStatusBarManager *manager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
    CGFloat statusBarHeight = manager.statusBarFrame.size.height;
    CGFloat topOffset = self.navigationController.navigationBar.frame.size.height + statusBarHeight;
    
    [self.txtfSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(topOffset + 10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(34);
    }];
    
    [self.selectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtfSearchBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.equalTo(@(34));
    }];

    [self.curConvListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectionView.mas_bottom).offset(10);
        make.left.right.equalTo(@(0));
        make.bottom.equalTo(@(-kDevice_iPhoneTabBarHei));
    }];

    [self.curConvListController.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectionView.mas_bottom).offset(10);
        make.left.right.equalTo(@(0));
        make.bottom.equalTo(self.curConvListView);
    }];
}

- (void)registerNotification
{
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

- (void)userDidLogin
{
    [[BIMClient sharedInstance] getTotalUnreadMessageCount:^(long long unreadCount, BIMError * _Nullable error) {
        if (error) {
            return;
        }
        [self updateTabUnreadCount:unreadCount];
    }];
    
    /// 首次登录后刷新一次所有机器人信息，防止低版本升级到高版本没有主动拉取机器人，导致会话展示错误
    [[VEIMDemoUserManager sharedManager] getAllRobotFullInfoWithSyncServer:YES completion:^(NSArray<BIMUserFullInfo *> * _Nullable infos, BIMError * _Nullable error) {}];
}

- (void)userDidLogout
{
    [self updateTabUnreadCount:0];
    [self.selectionView setTotalUnreadCount:0 withType:BIMConversationListTypeAllConversation];
    [self.selectionView setTotalUnreadCount:0 withType:BIMConversationListTypeFriendConversation];
}

- (void)rightBarItemClicked: (UIBarButtonItem *)item{
    if (!self.menu) {
        VEIMDemoCommonMenuItemModel *oneModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        oneModel.titleStr = @"发起单聊";
        oneModel.imgStr = @"icon_oneToOne";
        
        VEIMDemoCommonMenuItemModel *groupModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        groupModel.titleStr = @"发起群聊";
        groupModel.imgStr = @"icon_group";
        
        VEIMDemoCommonMenuItemModel *clearAllUnreacCountModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        clearAllUnreacCountModel.titleStr = @"清除未读";
        clearAllUnreacCountModel.imgStr = @"icon_group";
        
        VEIMDemoCommonMenuItemModel *oneRobotModel = [[VEIMDemoCommonMenuItemModel alloc] init];
        oneRobotModel.titleStr = @"发起机器人单聊";
        oneRobotModel.imgStr = @"icon_oneToOne";
        
        NSArray *ary = nil;
        if ([VEIMDemoIMManager sharedManager].accountProvider.accountType == VEIMDemoAccountTypeInternal) {
            VEIMDemoCommonMenuItemModel *createLocalConv = [[VEIMDemoCommonMenuItemModel alloc] init];
            createLocalConv.titleStr = @"创建本地临时会话";
            createLocalConv.imgStr = @"icon_oneToOne";
            ary = @[ oneModel, groupModel, clearAllUnreacCountModel, oneRobotModel , createLocalConv];
        } else {
            ary = @[ oneModel, groupModel, clearAllUnreacCountModel, oneRobotModel];
        }
        
        kWeakSelf(self);
        self.menu = [[VEIMDemoCommonMenu alloc] initWithListArray:ary selectBlock:^(NSInteger index) {
            [weakself clickMenu:index];
        }];
    }
    
    [self.menu show];
}

- (void)clickMenu: (NSInteger)index{
    VEIMDemoSelectUserViewController *vc = [[VEIMDemoSelectUserViewController alloc] init];
    vc.showType = VEIMDemoSelectUserShowTypeCreateChat;
    if (index == 0) {
        vc.conversationType = BIM_CONVERSATION_TYPE_ONE_CHAT;
        vc.title = @"发起单聊";
    } else if (index == 1) {
        vc.conversationType = BIM_CONVERSATION_TYPE_GROUP_CHAT;
        vc.title = @"发起群聊";
    } else if (index == 2) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"清除未读" message:@"确定要清除所有未读提醒？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[BIMClient sharedInstance] markAllConversationsRead:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"清除未读失败：%@", error.localizedDescription]];
                }
            }];
        }];
        [alertVC addAction:sure];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    } else if (index == 3) {
        VEIMDemoRobotListController *robotListVC = [[VEIMDemoRobotListController alloc] init];
        [self.navigationController pushViewController:robotListVC
                                             animated:YES];
        return;
    } else if (index == 4) {
        vc.conversationType = BIM_CONVERSATION_TYPE_ONE_CHAT;
        vc.showType = VEIMDemoSelectUserShowTypeCreateTempConv;
        vc.title = @"发起单聊并发消息";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BIMConversationListControllerDelegate

- (void)conversationListController:(BIMBaseConversationListController *)controller didSelectConversation:(BIMConversation *)conversation {
    VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)conversationListController:(BIMBaseConversationListController *)controller onTotalUnreadMessageCountChanged:(NSUInteger)totalUnreadCount
{
    BIMConversationListType type = controller.type;
    [self.selectionView setTotalUnreadCount:totalUnreadCount withType:type];
    /// 底 tab 只展示全部会话的未读数
    if (type == BIMConversationListTypeAllConversation) {
        [self updateTabUnreadCount:totalUnreadCount];
    }
}

- (void)updateTabUnreadCount:(NSUInteger)totalUnreadCount
{
    NSInteger total = totalUnreadCount;
    BOOL exceed = NO;
    if (total>99) {
        total = 99;
        exceed = YES;
    }
    
    self.tabBarItem.badgeValue = total>0?[NSString stringWithFormat:@"%zd%@",total,exceed?@"+":@""]:nil;
}

#pragma mark - VEIMDemoConversationListSelectionCollectionView

- (VEIMDemoConversationListSelectionCollectionView *)selectionView
{
    if (!_selectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowlayout.itemSize = CGSizeMake(80, 30);
        flowlayout.minimumInteritemSpacing = 12;
        flowlayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);

        _selectionView = [[VEIMDemoConversationListSelectionCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _selectionView.backgroundColor = [UIColor systemGray5Color];
        _selectionView.layer.cornerRadius = 15.f;
        _selectionView.scrollEnabled = NO;
        _selectionView.viewDelegate = self;
    }
    return _selectionView;
}

#pragma mark - VEIMDemoConversationListSelectionDelegate

- (void)didSelectType:(BIMConversationListType)type
{
    if (type == self.curConvListController.type) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        /// 切换会话列表
        [self.curConvListController removeFromParentViewController];
        [self.curConvListView removeFromSuperview];
        if (type == BIMConversationListTypeAllConversation) {
            self.curConvListController = self.allConvListController;
        } else if (type == BIMConversationListTypeFriendConversation) {
            self.curConvListController = self.friendConListController;
        } else {
            return;
        }
        [self addChildViewController:self.curConvListController];
        self.curConvListView = self.curConvListController.view;
        [self.view addSubview:self.curConvListView];
        [self makeSubViewsConstraints];
    });
}

#pragma mark - txtfSearchBtn

- (UIButton *)txtfSearchBtn
{
    if (!_txtfSearchBtn) {
        _txtfSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 100, 100, 50)];
        [_txtfSearchBtn setTitle:@" 搜索" forState:UIControlStateNormal];
        [_txtfSearchBtn setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
        [_txtfSearchBtn setImage:[UIImage imageNamed:@"icon_search2"] forState:UIControlStateNormal];
        _txtfSearchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_txtfSearchBtn addTarget:self action:@selector(txtfSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_txtfSearchBtn.layer setCornerRadius:15.f]; //设置矩圆角半径
        [_txtfSearchBtn.layer setBorderWidth:1.0];   //边框宽度
        [_txtfSearchBtn.layer setBorderColor:[UIColor systemGray2Color].CGColor];//边框颜色
    }
    return _txtfSearchBtn;
}

- (void)txtfSearchBtnClick:(UIButton *)txtfSearchBtn
{
    VEIMDemoGlobalSearchResultController *searchVC = [[VEIMDemoGlobalSearchResultController alloc] initWithKey:@""];
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end

