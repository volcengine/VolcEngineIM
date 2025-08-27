//
//  BIMChatViewController.m
//
//
//  Created by Weibai on 2022/11/4.
//

#import "BIMChatViewController.h"
#import "BIMUIDefine.h"
#import "BIMInputToolView.h"
#import "BIMToastView.h"
#import "NSString+IMUtils.h"
#import "BIMChatMenuViewNew.h"
#import "BIMTextChatCell.h"
#import "BIMImageVideoChatCell.h"
#import "BIMFileChatCell.h"
#import "BIMSystemMsgChatCell.h"
#import "BIMAudioChatCell.h"
#import "BIMCustomChatCell.h"
#import "BIMChatViewDataSource.h"
#import "BIMUserSelectionController.h"
#import "BIMParticipantsInConversationDataSource.h"
#import "BIMScanImage.h"
#import "BIMUIClient.h"
#import "BIMMessageDetailDebugViewController.h"
#import "BIMCouponChatCell.h"
#import "BIMMessageProgressManager.h"
#import "BIMUICommonUtility.h"

#import <Masonry/Masonry.h>
#import <AVFoundation/AVPlayer.h>
#import <AVKit/AVPlayerViewController.h>
#import <SDWebImage/SDWebImageError.h>
#import <OneKit/BTDMacros.h>
#import <OneKit/BTDResponder.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>

// 兼容直播群
@interface BIMMember : NSObject<BIMMember>

@property (nonatomic, assign) long long userID;

@property (nonatomic, copy) NSString *userIDString;

@property (nonatomic, copy) NSString *conversationID;

@property (nonatomic, assign) long long sortOrder;

@property (nonatomic, assign) BIMMemberRole role;

@property (nonatomic, copy, nullable) NSString *alias;

@property (nonatomic, assign) BOOL isOnline;

@property (nonatomic, copy) NSString *avatarURL;

@property (nonatomic, copy) NSDictionary *ext;
@end

@implementation BIMMember

@end


@interface BIMChatViewController () <BIMInputToolViewDelegate, BIMBaseChatCellDelegate, BIMCustomChatCellDelegate, BIMChatViewDataSourceDelegate, BIMUserSelectionControllerDelegate, BIMConversationListListener, BIMMessageListener, BIMLiveGroupMemberEventListener, BIMFriendListener, BIMCouponChatCellDelegate, BIMParticipantsInConversationDataSourceDelegate>


//UI related
@property (nonatomic, strong) BIMInputToolView *inputTool;
@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) BIMChatMenuViewNew *menu;

//Player
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSIndexPath *currentPlayingIndex;

//TIM related

@property (nonatomic, strong) BIMConversation *conversation;
@property (nonatomic, strong) NSString *toUserID;

//@property (nonatomic, strong) TIMOMessagesInConversationDataSource *msgDataSource;
@property (nonatomic, strong) BIMChatViewDataSource *messageDataSource;

@property (nonatomic, strong) BIMParticipantsInConversationDataSource *participantsDataSource;

@property (nonatomic, assign) long long joinMessageCursor;

@end

@implementation BIMChatViewController

#pragma mark - life

+ (instancetype)chatVCWithConversation:(BIMConversation *)conversation{
    BIMChatViewController *chatVC = [[BIMChatViewController alloc] init];
    chatVC.conversation = conversation;
    return chatVC;
}

+ (instancetype)chatVCWithToUserID:(NSString *)toUserID
{
    BIMChatViewController *chatVC = [[BIMChatViewController alloc] init];
    chatVC.toUserID = toUserID;
    return chatVC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfileUpdateNotify:) name:kBIMUserProfileUpdateNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:nil];
    }
}

- (BOOL)headerRefreshEnable {
    return YES;
}

- (void)headerRefreshed {
    NSInteger oldCount = self.messageDataSource.numberOfItems;
    
    @weakify(self);
    if (!self.messageDataSource.hasOlderMessages) {
        [self.tableview.mj_header endRefreshing];
        [BIMToastView toast:@"没有更多历史消息了"];
        return;
    }
    [self.messageDataSource loadOlderMessagesWithCompletionBlock:^(BIMError *_Nullable error) {
        @strongify(self);
        [self.tableview.mj_header endRefreshing];
        
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self.tableview reloadData];
            
            NSInteger newCount = self.messageDataSource.numberOfItems;
            if (newCount - oldCount < newCount) {
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(newCount - oldCount) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }];
}

- (void)footerPulled {
    @weakify(self);
    [self.messageDataSource loadNewerMessagesWithCompletionBlock:^(BIMError * _Nullable error) {
        @strongify(self);
        [self.tableview.mj_footer endRefreshing];
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self.tableview reloadData];
            if (!self.messageDataSource.hasNewerMessages) {
                self.tableview.mj_footer.hidden = YES;
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMsgs];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    if (self.conversation.draftText.length) {
        [self.inputTool setDraft:self.conversation.draftText];
    }
    
    [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:^(BIMError * _Nullable error) {}];
    
//    [self.tableview reloadData];
//    [self authorizeIfNeed];
}

//- (void)authorizeIfNeed{
//    AVAuthorizationStatus audioAuth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    if (audioAuth == AVAuthorizationStatusNotDetermined) {
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:nil];
//    }
//    AVAuthorizationStatus videoAuth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (videoAuth == AVAuthorizationStatusNotDetermined) {
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *draft = self.inputTool.currentText;
//    [self.conversation setDraft:draft];
    if (self.conversation.isMember && !self.conversation.isDissolved) {
        [[BIMClient sharedInstance] setConversationDraft:self.conversation.conversationID draft:draft.length ? draft : nil];
    }
    //取消语音播放
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - private

- (void)setupMsgs{
    if (!self.conversation) {
        return;
    }
    
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        [[BIMClient sharedInstance] markConversationMessagesRead:self.conversation.conversationID completion:^(BIMError * _Nullable error) {}];
    }

    self.messageDataSource = [[BIMChatViewDataSource alloc] initWithConversation:self.conversation joinMessageCursor:self.joinMessageCursor anchorMessage:self.anchorMessage];
    self.messageDataSource.delegate = self;
    
    @weakify(self);
    if (self.anchorMessage) {
        [self.messageDataSource loadMessagesWithSearchMsg:self.anchorMessage completionBlock:^(NSIndexPath * _Nonnull searchIndexPath, BIMError * _Nullable error) {
            @strongify(self);
            [CATransaction begin];
            [self.tableview reloadData];
            if (self.messageDataSource.numberOfItems > 1) {
                [self.tableview scrollToRowAtIndexPath:searchIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            [CATransaction commit];
            
            if (self.messageDataSource.hasNewerMessages) {
                self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerPulled)];
            }
        }];
    } else {
        [self.messageDataSource loadOlderMessagesWithCompletionBlock:^(BIMError * _Nullable error) {
            @strongify(self);
            [CATransaction begin];
            [self.tableview reloadData];
            if (self.messageDataSource.numberOfItems > 1) {
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageDataSource.numberOfItems - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            [CATransaction commit];
        }];
    }
    
    [self conversationStatusUpdateProcess];
    
    self.participantsDataSource = [[BIMParticipantsInConversationDataSource alloc] initWithConversationID:self.conversation.conversationID];
    self.participantsDataSource.delegate = self;
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [[BIMClient sharedInstance] addConversationListener:self];
    [[BIMClient sharedInstance] addLiveGroupMemberListener:self];
    [[BIMClient sharedInstance] addFriendListener:self];
    
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 100;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kIM_View_Background_Color;

    
    self.inputTool = [[BIMInputToolView alloc] initWithConvType:self.conversation.conversationType conversationID:self.conversation.conversationID];
    self.inputTool.backgroundColor = kWhiteColor;
    self.inputTool.delegate = self;
    self.inputTool.maxWordLimit = 500;
    if (!self.inputToolMenuTypeArray) {
#if defined(UI_INTERNAL_TEST) // 内测
        self.inputTool.menuTypeArray = @[@(BIMInputToolMenuTypePhoto), @(BIMInputToolMenuTypeVideoV2), @(BIMInputToolMenuTypeCamera), @(BIMInputToolMenuTypeFile), @(BIMInputToolMenuTypeCustomMessage), @(BIMInputToolMenuTypeCoupon)];
#elif defined(UI_INTERNAL) // Appstore
        self.inputTool.menuTypeArray = @[@(BIMInputToolMenuTypePhoto), @(BIMInputToolMenuTypeCamera), @(BIMInputToolMenuTypeFile), @(BIMInputToolMenuTypeCustomMessage), @(BIMInputToolMenuTypeCoupon)];
#else // 开源
        self.inputTool.menuTypeArray = @[@(BIMInputToolMenuTypePhoto), @(BIMInputToolMenuTypeCamera), @(BIMInputToolMenuTypeFile)];
#endif
    } else {
        self.inputTool.menuTypeArray = self.inputToolMenuTypeArray;
    }
    if ([BIMUICommonUtility isRobotConversation:self.conversation]) {
        [self.inputTool hideAddInput];
        [self.inputTool hideAudioInput];
    }
    [self.view addSubview:self.inputTool];
    
    self.holderView = [[UIView alloc] init];
    self.holderView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.holderView];
    
    self.tableview.allowsSelection = NO;
    self.tableview.backgroundColor = kIM_View_Background_Color;
    [self.tableview registerClass:[BIMTextChatCell class] forCellReuseIdentifier:@"BIMTextChatCell"];
    [self.tableview registerClass:[BIMImageVideoChatCell class] forCellReuseIdentifier:@"BIMImageVideoChatCell"];
    [self.tableview registerClass:[BIMSystemMsgChatCell class] forCellReuseIdentifier:@"BIMSystemMsgChatCell"];
    [self.tableview registerClass:[BIMFileChatCell class] forCellReuseIdentifier:@"BIMFileChatCell"];
    [self.tableview registerClass:[BIMAudioChatCell class] forCellReuseIdentifier:@"BIMAudioChatCell"];
    [self.tableview registerClass:[BIMCustomChatCell class] forCellReuseIdentifier:@"BIMCustomChatCell"];
    [self.tableview registerClass:[BIMCouponChatCell class] forCellReuseIdentifier:@"BIMCouponChatCell"];
    
    self.menu = [[BIMChatMenuViewNew alloc] init];
    self.menu.delegate = self;
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.inputTool.mas_top);
    }];
    
    [self.inputTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableview.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.holderView.mas_top);
    }];
    
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTool.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kDevice_TabbarSafeBottomMargin);
        make.bottom.mas_equalTo(0);
    }];
}

- (AVPlayerItem *)playItemWithFile:(BIMVideoElement *)file{
    NSURL *playURL = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:file.localPath]) {
        playURL = [NSURL fileURLWithPath:file.localPath];
    } else {
        playURL = [NSURL URLWithString:file.url];
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:playURL];
    
    return playerItem;
}

- (AVPlayerItem *)playItemWithMessage:(BIMMessage *)message{
    NSURL *playURL = nil;
    
    BIMVideoElement *element = BTD_DYNAMIC_CAST(BIMVideoElement, message.element);
    if ([[NSFileManager defaultManager] fileExistsAtPath:element.localPath]) {
        playURL = [NSURL fileURLWithPath:element.localPath];
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:element.downloadPath]) {
        playURL = [NSURL fileURLWithPath:element.downloadPath];
    } else {
        playURL = [NSURL URLWithString:element.url];
        [[BIMClient sharedInstance] downloadFile:message remoteURL:element.url progressBlock:nil completion:^(BIMError * _Nullable error) {
            if (error) {
                if (error.code != BIM_DOWNLOAD_FILE_DUPLICATE) {
                    [BIMToastView toast:@"下载失败，请重试"];
                }
            } else {
                [BIMToastView toast:@"下载成功"];
            }
        }];
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:playURL];
    
    return playerItem;
}

- (void)playElementWithMessage:(BIMMessage *)message
{
    AVPlayerItem *playItem;
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        playItem = [self playItemWithFile:(BIMVideoElement *)message.element];
    } else {
        playItem = [self playItemWithMessage:message];
        [[BIMClient sharedInstance] sendMessageReadReceipts:@[message] completion:^(BIMError * _Nullable error) {}];
    }
    
    if (!playItem) {
        [BIMToastView toast:@"播放链接错误，无法播放"];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:playItem];
        [self.player play];
    }
}


- (void)playVideoWithMessage:(BIMMessage *)message
{
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = self.player;
    [self presentViewController:playerVC animated:YES completion:nil];
    
    BIMVideoElement *element = BTD_DYNAMIC_CAST(BIMVideoElement, message.element);
    if ([[NSFileManager defaultManager] fileExistsAtPath:element.downloadPath]) {
        [self playElementWithMessage:message];
    } else {
        if (element.isExpired) {
            @weakify(self);
            [self refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [BIMToastView toast:@"播放链接错误，无法播放"];
                } else {
                    [self playElementWithMessage:message];
                }
            }];
        } else {
            [self playElementWithMessage:message];
        }
    }
}

#pragma mark - lazy
- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (NSMutableArray *)generateMenuForMessage: (BIMMessage *)message{
    NSMutableArray *items = [NSMutableArray array];
    if (message.msgType == BIM_MESSAGE_TYPE_TEXT) {
        [items addObject:[BIMChatMenuItemModel modelWithTitle:@"复制" icon:@"icon_copy" type:BIMChatMenuTypeCopy]];
    }
    [items addObject:[BIMChatMenuItemModel modelWithTitle:@"删除" icon:@"icon_del" type:BIMChatMenuTypeDel]];
    
    if (message.msgStatus != BIM_MESSAGE_STATUS_FAILED) {
        if (message.senderUID == [BIMClient sharedInstance].getCurrentUserID.longLongValue) {
            [items addObject:[BIMChatMenuItemModel modelWithTitle:@"撤回" icon:@"icon_recall" type:BIMChatMenuTypeRecall]];
        }
        if (!self.conversation.isDissolved) {
            [items addObject:[BIMChatMenuItemModel modelWithTitle:@"引用" icon:@"icon_menu_read" type:BIMChatMenuTypeReferMessage]];
        }
    }
    if (message.msgType == BIM_MESSAGE_TYPE_TEXT && message.senderUID == [BIMClient sharedInstance].getCurrentUserID.longLongValue) {
        [items addObject:[BIMChatMenuItemModel modelWithTitle:@"编辑" icon:@"icon_menu_read" type:BIMChatMenuTypeModify]];
    }
    
#ifdef UI_INTERNAL_TEST
    if (message.serverMessageID) {
        [items addObject:[BIMChatMenuItemModel modelWithTitle:@"详情" icon:@"icon_menu_read" type:BIMChatMenuTypeDebugMessageDetail]];
    }
    
#endif
    
    return items;
}

- (NSMutableArray *)generateLiveGroupMenuForMessage: (BIMMessage *)message{
    NSMutableArray *items = [NSMutableArray array];
    if (message.msgType == BIM_MESSAGE_TYPE_TEXT) {
        [items addObject:[BIMChatMenuItemModel modelWithTitle:@"复制" icon:@"icon_copy" type:BIMChatMenuTypeCopy]];
    }
    NSString *priority = message.ext[@"s:message_priority"];
    
    NSString *priorityTitle = @"";
    if (!priority) {
        priorityTitle = @"未知";
    } else {
        switch (priority.integerValue) {
            case 0:
                priorityTitle = @"低";
                break;
            case 1:
                priorityTitle = @"普通";
                break;
            case 2:
                priorityTitle = @"高";
                break;

            default:
                break;
        }
    }
    
    [items addObject:[BIMChatMenuItemModel modelWithTitle:priorityTitle icon:@"icon_menu_read" type:999999]];
    
    [items addObject:[BIMChatMenuItemModel modelWithTitle:@"调试" icon:@"icon_menu_read" type:BIMChatMenuTypeDebug]];
    return items;
}


#pragma mark - Functional
- (void)conversationStatusUpdateProcess
{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        return;
    }
    
    NSString *reason = @"";
    
    if (!self.conversation.isMember) {
//        reason = @"已被移出该群";
    }
    
    if (self.conversation.isDissolved) {
//        reason = @"该群已被解散";
    }
    
    if ([reason length] != 0) {
        [self disableInputToolWithReason:reason];
    } else {
        [self.inputTool enableInput];
    }
}

- (void)scrollViewToBottom: (BOOL)animated{
    if ([self.messageDataSource numberOfItems] == 0) {
        return;
    }
    @weakify(self);
    NSTimeInterval delay = animated ? 0.25 : 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        if (self.tableview.contentSize.height > self.tableview.bounds.size.height) {
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageDataSource.numberOfItems - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    });
}


#pragma mark - InputTool
- (void)sendMessageToastWithError:(BIMError *)error message:(BIMMessage *)message
{
    NSString *toast = [NSString stringWithFormat:@"消息发送失败:%ld", (long)error.code];
    NSDictionary *localExt = message.localExt;
    if (localExt && !BTD_isEmptyString([message checkMessage])) {//优先展示checkMessage
        toast = [NSString stringWithFormat:@"checkCode:%@, checkMessage:%@", @([message checkCode]), [message checkMessage]];
    } else if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        if (error.code == BIM_UPLOAD_FILE_SIZE_OUT_LIMIT) {
            toast = [NSString stringWithFormat:@"消息发送失败: 文件大小超过限制"];
        } else if (error.code == BIM_SERVER_ERROR_SEND_MESSAGE_TOO_LARGE) {
            toast = [NSString stringWithFormat:@"消息发送失败: 消息内容超过限制"];
        }
    } else {
        if (error.code == BIM_UPLOAD_FILE_SIZE_OUT_LIMIT) {
            toast = [NSString stringWithFormat:@"消息发送失败: 文件大小超过限制"];
        } else if (error.code == BIM_SERVER_ERROR_SEND_MESSAGE_TOO_LARGE) {
            toast = [NSString stringWithFormat:@"消息发送失败: 消息内容超过限制"];
        } else if ([error.localizedDescription isEqualToString:@"该用户已注销，不存在"]) {
            toast = error.localizedDescription;
        } else if (error.code == BIM_SERVER_NOT_FRIEND) {
            toast = @"对方不是你的好友，无法发送消息";
        } else if (error.code == BIM_SERVER_ALREADY_IN_BLACK) {
            toast = @"对方已拒收你的消息";
        }
    }
    [BIMToastView toast:toast];
}

- (void)disableInputToolWithReason:(NSString *)reason
{
    // 目前仅限制了输入，仍然可以发送property表情和消息发送重试，但是会发送失败，仅自见
    [self.inputTool disableInputWithReason:reason];
}

- (void)inputToolViewSendMessage:(BIMMessage *)sendMessage
{
    NSString *msgID = sendMessage.uuid;
    BIMProgress progress = ^(int progress) {
        [[BIMMessageProgressManager sharedInstance] updateProgress:msgID progress:progress];
    };
    
    @weakify(self);
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [self setExtWithSendMessage:sendMessage];
        
        [[BIMClient sharedInstance] sendLiveGroupMessage:sendMessage conversation:self.conversation.conversationID priority:self.inputTool.priority progress:progress completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [self sendMessageToastWithError:error message:message];
            }
        }];
    } else {
        // 单聊，并且本地仅有假会话
        if (self.toUserID) {
            [[BIMClient sharedInstance] sendMessage:sendMessage toUserID:self.toUserID saved:nil progress:progress completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [self sendMessageToastWithError:error message:message];
                }
            }];
            
            return;
        }
        
        // 普通群聊 单聊
        // 发送消息前判断用户是否在会话中
        if (!self.conversation.isMember) {
            [BIMToastView toast:[NSString stringWithFormat:@"不在会话中"]];
            return;
        }
                
        [[BIMClient sharedInstance] sendMessage:sendMessage conversationId:self.conversation.conversationID saved:nil progress:progress completion:^(BIMMessage * _Nonnull message, BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [self sendMessageToastWithError:error message:message];
            }
        }];
    }
}

- (void)inputToolViewDidChange:(CGRect)frame keyboardFrame:(CGRect)keyboardFrame
{
    [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.inputTool.mas_top);
    }];
    [self scrollViewToBottom:YES];
    
    [self.inputTool mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableview.mas_bottom);
        make.left.right.mas_equalTo(0);
        if (keyboardFrame.origin.y == 0) {
            make.bottom.equalTo(self.holderView.mas_top);
        } else {
            make.bottom.mas_equalTo(-keyboardFrame.size.height);
        }
    }];
}

- (void)inputToolDidTriggerMention
{
    BIMUserSelectionController *selectionVC = [[BIMUserSelectionController alloc] initWithConversationID:self.conversation.conversationID];
    selectionVC.isNeedLeftBack = NO;
    selectionVC.isNeedCloseBtn = YES;
    selectionVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectionVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)inputToolViewModifyMessage:(BIMMessage *)message newContent:(NSString *)newContent mentionedUsers:(NSArray<NSNumber *> *)mentionedUsers
{
    BIMTextElement *element = (BIMTextElement *)message.element;
    element.text = newContent;
    [[BIMClient sharedInstance] modifyMessage:message completion:^(BIMError * _Nullable error) {
        
    }];
}

#pragma mark - BIMChatViewDataSourceDelegate

- (void)chatViewDataSourceDidReloadAllMessage:(BIMChatViewDataSource *)dataSource scrollToBottom:(BOOL)scrollToBottom
{
    [self.tableview reloadData];

    // 新消息到来时滚动至底部
    if (scrollToBottom) {
        UIViewController *topVC = [BTDResponder topViewController];
        if ([topVC.childViewControllers containsObject:self]) {
            [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:^(BIMError * _Nullable error) {}];
        }
        [self scrollViewToBottom:YES];
    }
}

#pragma mark - BIMParticipantsInConversationDataSource Delegate

- (void)participantsDataSourceDidUpdate:(nonnull BIMParticipantsInConversationDataSource *)dataSource {
    [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:nil];

    [self conversationStatusUpdateProcess];
    
    NSString *conversationShowName = [BIMUICommonUtility getShowNameWithConversation:self.conversation];
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_ONE_CHAT) {
        NSString *participantCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.conversation.memberCount];
        self.title = [NSString stringWithFormat:@"%@(%@)", conversationShowName , participantCount];
    } else {
        self.title = conversationShowName;
    }
    btd_dispatch_async_on_main_queue(^{
        [self.tableview reloadData];
    });
}

#pragma mark - TableView Delegate & Datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    BIMMessage *msg = [self.msgDataSource itemAtIndex:indexPath.row];
    BIMMessage *msg = [self.messageDataSource itemAtIndex:indexPath.row];
    /// 语音和视频消息需要点开才发送已读回执，可以根据需求调整。
    if (msg.msgType != BIM_MESSAGE_TYPE_VIDEO && msg.msgType != BIM_MESSAGE_TYPE_VIDEO_V2 && msg.msgType != BIM_MESSAGE_TYPE_AUDIO && self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] sendMessageReadReceipts:@[msg] completion:^(BIMError * _Nullable error) {}];
    }

    id<BIMMember> sender;
    for (id<BIMMember> participant in self.participantsDataSource.participants) {
        if (msg.senderUID == participant.userID) {
            sender = participant;
            break;
        }
    }
    
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP && !sender) {
        NSString *senderUID = msg.senderUIDString;
        NSDictionary *user = self.messageDataSource.userDict[senderUID];
        BIMMember *member = [[BIMMember alloc] init];
        member.conversationID = msg.conversationID;
        member.userID = msg.senderUID;
        member.userIDString = msg.senderUIDString;
        member.alias = user[kAliasName];
        member.avatarURL = user[kAvatarUrl];
        sender = member;
    }
    
    BIMBaseChatCell *cell = [self dequestCellForMessage:msg tableView:tableView];
    
    [cell refreshWithMessage:msg inConversation:self.conversation sender:sender];
    
    if (!cell) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = [NSString stringWithFormat:@"Type: %zd",msg.msgType];
        return cell;
    }
    return cell;
}

- (BIMBaseChatCell *)dequestCellForMessage:(BIMMessage *)msg tableView:(UITableView *)tableView
{
    BIMBaseChatCell *cell;
    if (msg.isRecalled) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMSystemMsgChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_CUSTOM) {
        BIMCustomElement *element = (BIMCustomElement *)msg.element;
        NSInteger type = [element.dataDict[@"type"] integerValue];
        if (type == kBIMMessageTypeSystem || msg.isRecalled) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BIMSystemMsgChatCell"];
        } else if (type == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BIMCouponChatCell"];
        } else if (type == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BIMCustomChatCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BIMTextChatCell"];
        }
    } else if (msg.msgType == BIM_MESSAGE_TYPE_TEXT) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMTextChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_IMAGE || msg.msgType == BIM_MESSAGE_TYPE_VIDEO || msg.msgType == BIM_MESSAGE_TYPE_VIDEO_V2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMImageVideoChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_FILE) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMFileChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_AUDIO) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMAudioChatCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMTextChatCell"];
    }
    
    @weakify(self);
    if (![cell isKindOfClass:[BIMSystemMsgChatCell class]]) {
        [cell setLongPressHandler:^(UILongPressGestureRecognizer * _Nonnull gesture) {
            @strongify(self);
            NSArray *items = nil;
            if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
                items = [self generateLiveGroupMenuForMessage:msg];
            } else {
                items = [self generateMenuForMessage:msg];
            }
            [self.menu showItems:items onView:gesture.view referView:self.inputTool message:msg];
        }];
    }
    cell.delegate = self;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageDataSource.numberOfItems;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inputTool revertToTheOriginalType];
}

#pragma mark - BIMConversationListListener
- (void)onNewConversation:(NSArray<BIMConversation *> *)conversationList
{
    if (!self.conversation) {
        [conversationList enumerateObjectsUsingBlock:^(BIMConversation * _Nonnull conv, NSUInteger idx, BOOL * _Nonnull stop) {
            if (conv.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
                NSArray<NSString *> *userIDs = [conv.conversationID componentsSeparatedByString:@":"];
                if ([userIDs containsObject:self.toUserID]) {
                    self.conversation = conv;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setupMsgs];
                    });
                    *stop = YES;
                }
            }
        }];
    }
}

- (void)onConversationChanged:(NSArray<BIMConversation *> *)conversationList
{
    for (BIMConversation *con in conversationList) {
        if ([self.conversation.conversationID isEqualToString:con.conversationID]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self conversationStatusUpdateProcess];
            });
            break;
        }
    }
}

- (void)onConversationRead:(NSString *)conversationId fromUid:(long long)uid
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

#pragma mark - User Selection
- (void)userSelectVC:(BIMUserSelectionController *)vc didChooseUser:(BIMUser *)user
{
    [self.inputTool addMentionUser:@(user.userID)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTool becomeFirstResponder];
    });
    
}

- (void)userSelectVCDidClickClose:(BIMUserSelectionController *)vc
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTool becomeFirstResponder];
        [self.inputTool inputText:@"@"];
    });
}

#pragma mark - Cell delegate
- (void)chatCell:(BIMBaseChatCell *)cell didClickRetryBtnWithMessage:(BIMMessage *)sendMessage
{
    NSString *msgID = sendMessage.uuid;
    BIMProgress progressBlock = ^(int progress) {
        [[BIMMessageProgressManager sharedInstance] updateProgress:msgID progress:progress];
    };
    
    @weakify(self);
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [self setExtWithSendMessage:sendMessage];

        [[BIMClient sharedInstance] sendLiveGroupMessage:sendMessage conversation:self.conversation.conversationID priority:self.inputTool.priority progress:progressBlock completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [self sendMessageToastWithError:error message:message];
            }
        }];
    } else {
        if (self.toUserID) {
            [[BIMClient sharedInstance] sendMessage:sendMessage toUserID:self.toUserID saved:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"消息储存失败:%@",error.localizedDescription]];
                }
            } progress:progressBlock completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [self sendMessageToastWithError:error message:message];
                }
            }];
            
            return;
        }
        
        [[BIMClient sharedInstance] sendMessage:sendMessage conversationId:self.conversation.conversationID saved:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"消息储存失败:%@",error.localizedDescription]];
                }
            } progress:progressBlock completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [self sendMessageToastWithError:error message:message];
                }
            }];
    }
    
    
}

- (void)cell:(BIMFileChatCell *)cell didClickLiveGroupImageContent:(BIMMessage *)message
{
    if (message.msgType == BIM_MESSAGE_TYPE_VIDEO) {
        [self playVideoWithMessage:message];
    } else if (message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
        BIMImageElement *file = (BIMImageElement *)message.element;
        if (![NSURL URLWithString:file.originImg.url]) {
            [BIMToastView toast:@"图片URL为空"];
        }
        
        BOOL hasLocalImage = [[NSFileManager defaultManager] fileExistsAtPath:file.localPath];
        if (hasLocalImage && cell.imageContent.image) {
            [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:cell.imageContent.image];
        } else {
            @weakify(self);
            [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:file.originImg.url secretKey:nil completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                @strongify(self);
                if (error) {
                    [self refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
                        if (error) {
                            [BIMToastView toast:[NSString stringWithFormat:@"加载图片失败：%@",error.localizedDescription]];
                        } else {
                            [BIMScanImage scanBigImageRefreshWithImageUrl:file.originImg.url completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                if (error) {
                                    [BIMToastView toast:[NSString stringWithFormat:@"加载图片失败：%@",error.localizedDescription]];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    } else if (message.msgType == BIM_MESSAGE_TYPE_FILE) {
        [BIMToastView toast:@"暂不支持文件预览"];
    }
    [self.inputTool revertToTheOriginalType];
}

- (void)cell:(BIMFileChatCell *)cell didClickNormalConvImageContent:(BIMMessage *)message
{
    if (message.msgType == BIM_MESSAGE_TYPE_VIDEO || message.msgType == BIM_MESSAGE_TYPE_VIDEO_V2) {
        [self playVideoWithMessage:message];
    } else if (message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
        BIMImageElement *element = BTD_DYNAMIC_CAST(BIMImageElement, message.element);
        if (![NSURL URLWithString:element.originImg.url]) {
            [BIMToastView toast:@"图片URL为空"];
        }
        
        BOOL hasLocalImage = [[NSFileManager defaultManager] fileExistsAtPath:element.localPath];
        if (hasLocalImage && cell.imageContent.image) {
            UIImage *image = [UIImage imageWithContentsOfFile:element.localPath];
            [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:image];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:element.originImg.downloadPath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:element.originImg.downloadPath];
            [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:image];
        } else {
            BIMImageElement *element = BTD_DYNAMIC_CAST(BIMImageElement, message.element);
            [BIMScanImage scanBigImageWithImageView:cell.imageContent message:message image:element.originImg completion:^(BIMError *error) {
                NSString *toastText = error ? @"下载失败，请重试" : @"下载成功";
                [BIMToastView toast:toastText];
            }];
        }
    } else if (message.msgType == BIM_MESSAGE_TYPE_FILE) {
        BIMFileElement *element = BTD_DYNAMIC_CAST(BIMFileElement, message.element);
        if (![[NSFileManager defaultManager] fileExistsAtPath:element.downloadPath]) {
            [BIMToastView toast:@"下载中"];
            [[BIMClient sharedInstance] downloadFile:message remoteURL:element.url progressBlock:nil completion:^(BIMError * _Nullable error) {
                if (error) {
                    if (error.code != BIM_DOWNLOAD_FILE_DUPLICATE) {
                        [BIMToastView toast:@"下载失败，请重试"];
                    }
                } else {
                    [BIMToastView toast:@"下载成功"];
                }
            }];
        } else {
            kWeakSelf(self);
            NSString *fileSize = cell.fileSize;
            NSRange range = [element.fileName rangeOfString:@"." options:NSBackwardsSearch];
            NSString *fileType = range.length == 0 ? @"" : [element.fileName substringFromIndex:range.location + 1];
            NSString *fileInfo = [NSString stringWithFormat:@"文件大小：%@\n文件格式：%@", fileSize, fileType];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"暂不支持文件预览" message:fileInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:sure];
            [weakself presentViewController:alertVC animated:YES completion:nil];
        }
    }
    [self.inputTool revertToTheOriginalType];
}

- (void)cell:(BIMFileChatCell *)cell didClickImageContent:(BIMMessage *)message
{
    self.currentPlayingIndex = nil;
    BIMConversationType convType = self.conversation.conversationType;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (convType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
            [self cell:cell didClickLiveGroupImageContent:message];
        } else {
            [self cell:cell didClickNormalConvImageContent:message];
        }
    });
}

- (void)chatCell:(BIMBaseChatCell *)cell didClickAvatarWithMessage:(BIMMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(chatViewController:didClickAvatar:)]) {
        [self.delegate chatViewController:self didClickAvatar:message];
    }
}

- (void)chatCell:(BIMBaseChatCell *)cell didClickReadDetailWithMessage:(BIMMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(chatViewController:didClickReadDetailWithMessage:)]) {
        [self.delegate chatViewController:self didClickReadDetailWithMessage:message];
    }
}

- (void)refreshMediaMessage:(BIMMessage *)message completion:(BIMCompletion)completion
{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] refreshLiveGroupMediaMessage:message completion:completion];
    } else {
        [[BIMClient sharedInstance] refreshMediaMessage:message completion:completion];
    }
}

- (void)cell:(BIMCustomChatCell *)cell didClickLink:(NSString *)link{
    NSURL *url = [NSURL URLWithString:link];
    if (url) {
        [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
    }
}

- (void)cell:(BIMFileChatCell *)cell fileLoadFinish:(BIMMessage *)message error:(NSError *)error
{
    if (!error || error.code == SDWebImageErrorCancelled) {
        return;
    }
    if (error.code == SDWebImageErrorInvalidDownloadStatusCode) {
        [self refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:error.localizedDescription];
            }
        }];
    } else if (error.code == SDWebImageErrorCancelled) {
        
    } else if (error.code == SDWebImageErrorInvalidURL) {
        // error延迟到点击时处理
    } else if (error.code == BIM_DOWNLOAD_FILE_DUPLICATE) {
        // 重复URL下载
    } else {
        [BIMToastView toast:error.localizedDescription];
    }
}

- (void)cellDidClickCouponLink:(BIMCouponChatCell *)cell
{
    // 修改message
    BIMMessage *message = cell.message;
    BIMCustomElement *element = (BIMCustomElement *)message.element;
    message.ext = @{@"a:coupon_status": @"1"};
    [[BIMClient sharedInstance] modifyMessage:message completion:^(BIMError * _Nullable error) {
        
    }];
}

- (void)cell:(BIMFileChatCell *)cell didClickCancelBtnWithMessage:(BIMMessage *)message
{
    [[BIMClient sharedInstance] cancelMediaFileMessageUpload:message completion:^(BIMError *error){
        if (error) {
            
        }
        
        [self.tableview reloadData];
    }];
}

#pragma mark - 表情回复
- (void)menuView:(BIMChatMenuViewNew *)menu didClickEmoji:(BIMEmoji *)emoji message:(BIMMessage *)message{
    NSInteger row = [self.messageDataSource indexOfItem:message];
    NSString *currentUserIDStr = [NSString stringWithFormat:@"%lld",[BIMClient sharedInstance].getCurrentUserID.longLongValue];
    BOOL found = NO;
    NSArray<BIMMessagePropertyItem *> *properties = message.properties[emoji.emojiDes];
    for (BIMMessagePropertyItem *propertie in properties) {
        if ([propertie.idempotentID isEqualToString:currentUserIDStr]) {
            found = YES;
            break;
        }
    }

    BIMMessageNewPropertyModify *modify = [[BIMMessageNewPropertyModify alloc] init];
    modify.key = emoji.emojiDes;
    modify.idempotentID = currentUserIDStr;
    modify.value = currentUserIDStr;
    modify.type = found ? BIMMessageNewPropertyModifyTypeRemove : BIMMessageNewPropertyModifyTypeAdd;

    kWeakSelf(self);
    [[BIMClient sharedInstance] modifyMessageProperty:message propertyItems:@[modify] completion:^(BIMError * _Nullable error) {
        kStrongSelf(self);
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"表情回复出错：%@",error.localizedDescription]];
        }

        if (row >= 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BIMMessage *msg = [self.messageDataSource itemAtIndex:row];
                [menu refreshMessage:msg];
            });
        }
    }];
}

- (void)menuView:(BIMChatMenuViewNew *)menu didClickType:(BIMChatMenuType)type message:(BIMMessage *)message{
    switch (type) {
        case BIMChatMenuTypeCopy:{
            BIMTextElement *element = (BIMTextElement *)message.element;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = element.text;
            [BIMToastView toast:@"已复制"];
            break;
        }
        case BIMChatMenuTypeDel:{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除消息" message:@"确定删除消息？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[BIMClient sharedInstance] deleteMessage:message completion:^(BIMError * _Nullable error) {
                    if (error) {
                        [BIMToastView toast:[NSString stringWithFormat:@"删除失败：%@",error.localizedDescription]];
                    }
                }];
            }];
            [alertVC addAction:sure];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancel];
            [self presentViewController:alertVC animated:YES completion:nil];
            break;
        }
        case BIMChatMenuTypeRecall:{
            [[BIMClient sharedInstance] recallMessage:message completion:^(BIMError * _Nullable error) {
                if (error) {
                    NSString *toastText;
                    switch (error.code) {
                        case BIM_SERVER_RECALL_TIMEOUT: {
                            toastText = @"超过2分钟的消息无法撤回";
                        }
                            break;
                        default:
                            toastText = @"撤回失败，请重试";
                            break;
                    }
                    [BIMToastView toast:toastText];
                }
            }];
            break;
        }
        case BIMChatMenuTypeReferMessage:{
            [self.inputTool setReferMessage:message];
            break;
        }
        case BIMChatMenuTypeDebug:{
            NSString *msg = [[message valueForKey:@"message"] description];
            [self showTextCopyAlertWithTitle:@"调试" message:msg];
            break;
        }
        case BIMChatMenuTypeDebugMessageDetail:{
            BIMMessageDetailDebugViewController *vc = [[BIMMessageDetailDebugViewController alloc] init];
            vc.message = message;
            vc.conversationShortID = self.conversation.conversationShortID.longLongValue;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case BIMChatMenuTypeModify:{
            self.inputTool.isModifyMessage = YES;
            self.inputTool.referMessage = message;
            break;
        }
        default:
            break;
    }
}

- (void)showTextCopyAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UIPasteboard.generalPasteboard.string = message;
        [BIMToastView toast:@"已复制"];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:copy];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - BIMLiveGroupMemberEventListener

- (void)onMemberInfoChanged:(BIMConversation *)conversation member:(id<BIMMember>)member
{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *userID = member.userIDString;
            [self.messageDataSource.userDict setObject:@{kAliasName: member.alias?:@"",kAvatarUrl: member.avatarURL ?:@""} forKey:userID];
            [self.tableview reloadData];
        });
    }
}

#pragma mark - BIMFriendListener

- (void)onFriendUpdate:(BIMUserFullInfo *)info
{
    [self.tableview reloadData];
}

- (void)onUserProfileUpdate:(BIMUserFullInfo *)info
{
    [self.tableview reloadData];
}

- (void)onBatchMemberInfoChanged:(BIMConversation *)conversation members:(NSArray<id<BIMMember>> *)members
{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [members enumerateObjectsUsingBlock:^(id<BIMMember>  _Nonnull member, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *userID = member.userIDString ;
                [self.messageDataSource.userDict setObject:@{kAliasName: member.alias ?: @"", kAvatarUrl : member.avatarURL ?: @""} forKey:userID];
            }];
            [self.tableview reloadData];
        });
    }
}

#pragma mark - Notification

- (void)userProfileUpdateNotify:(NSNotification *)notify
{
    [self.tableview reloadData];
}

#pragma mark -

- (void)setExtWithSendMessage:(BIMMessage *)sendMessage
{
    NSMutableDictionary *ext = [NSMutableDictionary dictionary];
    NSString *currentUID = nil;
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) { // 直播群开启了字符串UID能力
        currentUID = [BIMClient sharedInstance].getCurrentUserIDString;
    } else {
        currentUID = [BIMClient sharedInstance].getCurrentUserID;
    }
    NSString *alias = self.conversation.currentMember.alias;
    if (alias) {
        [ext setObject:alias forKey:kAliasName];
    }
    
    NSString *avatarUrl = self.conversation.currentMember.avatarURL;
    if (avatarUrl) {
        [ext setObject:avatarUrl forKey:kAvatarUrl];
    }
    
    [self.messageDataSource.userDict setObject:ext forKey:currentUID];
    [ext addEntriesFromDictionary:sendMessage.ext];
    sendMessage.ext = ext.copy;
    
}

@end
