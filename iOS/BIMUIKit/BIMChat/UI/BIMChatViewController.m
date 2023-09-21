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

#import <Masonry/Masonry.h>
#import <AVFoundation/AVPlayer.h>
#import <AVKit/AVPlayerViewController.h>
#import <SDWebImage/SDWebImageError.h>
#import <OneKit/BTDMacros.h>

#import <imsdk-tob/BIMSDK.h>


@interface BIMChatViewController () <BIMInputToolViewDelegate, BIMBaseChatCellDelegate, BIMCustomChatCellDelegate, BIMChatViewDataSourceDelegate, BIMUserSelectionControllerDelegate, BIMConversationListListener, BIMMessageListener>


//UI related
@property (nonatomic, strong) BIMInputToolView *inputTool;
@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) BIMChatMenuViewNew *menu;

//Player
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSIndexPath *currentPlayingIndex;

//TIM related

@property (nonatomic, strong) BIMConversation *conversation;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
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
    [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:nil];
    
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
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [[BIMClient sharedInstance] addConversationListener:self];
    
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 100;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kIM_View_Background_Color;

    
    self.inputTool = [[BIMInputToolView alloc] initWithConvType:self.conversation.conversationType];
    self.inputTool.backgroundColor = kWhiteColor;
    self.inputTool.delegate = self;
    [self.view addSubview:self.inputTool];
    
    self.holderView = [[UIView alloc] init];
    self.holderView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.holderView];
    
    self.tableview.allowsSelection = NO;
    self.tableview.backgroundColor = kIM_View_Background_Color;
    [self.tableview registerClass:[BIMTextChatCell class] forCellReuseIdentifier:@"BIMDemoTextChatCell"];
    [self.tableview registerClass:[BIMImageVideoChatCell class] forCellReuseIdentifier:@"BIMDemoImageVideoChatCell"];
    [self.tableview registerClass:[BIMSystemMsgChatCell class] forCellReuseIdentifier:@"BIMDemoSystemMsgChatCell"];
    [self.tableview registerClass:[BIMFileChatCell class] forCellReuseIdentifier:@"BIMDemoFileChatCell"];
    [self.tableview registerClass:[BIMAudioChatCell class] forCellReuseIdentifier:@"BIMDemoAudioChatCell"];
    [self.tableview registerClass:[BIMCustomChatCell class] forCellReuseIdentifier:@"BIMDemoCustomChatCell"];
    
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

- (void)playWithElement:(BIMVideoElement *)element
{
    AVPlayerItem *playItem = [self playItemWithFile:element];
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
    
    BIMVideoElement *element = message.element;
    if (element.isExpired) {
        @weakify(self);
        [[BIMClient sharedInstance] refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [BIMToastView toast:@"播放链接错误，无法播放"];
            } else {
                [self playWithElement:element];
            }
        }];
    } else {
        [self playWithElement:element];
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
- (void)sendMessageToastWithError:(BIMError *)error
{
    NSString *toast = [NSString stringWithFormat:@"消息发送失败:%@", error.localizedDescription];
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
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
- (void)inputToolViewSendMessage:(BIMMessage *)sendMessage{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        long long currentUID = [BIMClient sharedInstance].getCurrentUserID.longLongValue;
    
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(currentUID);
        NSString *nickName = user.nickName;
        if (nickName) {
            NSMutableDictionary *ext = [NSMutableDictionary dictionary];
            [ext addEntriesFromDictionary:sendMessage.ext];
            [ext setObject:nickName forKey:@"a:live_group_nick_name"];
            sendMessage.ext = ext.copy;
        }
        
        @weakify(self);
        [[BIMClient sharedInstance] sendLiveGroupMessage:sendMessage                       conversation:self.conversation.conversationID priority:self.inputTool.priority completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [self sendMessageToastWithError:error];
            }
        }];
        return;
    } else {
        // 普通群聊 单聊
        // 发送消息前判断用户是否在会话中
        if (!self.conversation.isMember) {
            [BIMToastView toast:[NSString stringWithFormat:@"不在会话中"]];
            return;
        }
        
        [[BIMClient sharedInstance] sendMessage:sendMessage conversationId:self.conversation.conversationID saved:nil progress:^(int progress) {
            
        } completion:^(BIMMessage * _Nonnull message, BIMError * _Nullable error) {
            if (error) {
                [self sendMessageToastWithError:error];
            }
        }];
    }
}

- (void)inputToolViewDidChange:(CGRect)frame keyboardFrame:(CGRect)keyboardFrame
{
//    self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height - (KScreenHeight - self.inputTool.frame.origin.y));
//    [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height - self.tableview.bounds.size.height) animated:YES];
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

- (void)inputToolDidTriggerMention{
    NSMutableArray *users = [NSMutableArray array];
    NSArray *participants = [[BIMClient sharedInstance] getConversationMemberList:self.conversation.conversationID];
    for (int i = 0; i<participants.count; i++) {
        id <BIMMember> participant = [participants objectAtIndex:i];
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(participant.userID);
        user.userID = participant.userID;
        [users addObject:user];
    }
    BIMUserSelectionController *selectionVC = [[BIMUserSelectionController alloc] initWithUsers:users];
    selectionVC.isNeedLeftBack = NO;
    selectionVC.isNeedCloseBtn = YES;
    selectionVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectionVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - BIMChatViewDataSourceDelegate

- (void)chatViewDataSourceDidReloadAllMessage:(BIMChatViewDataSource *)dataSource scrollToBottom:(BOOL)scrollToBottom
{
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:nil];
    }
    
    [self.tableview reloadData];

    // 新消息到来时滚动至底部
    if (scrollToBottom) {
        [self scrollViewToBottom:YES];
    }
}

#pragma mark - BIMParticipantsInConversationDataSource Delegate

- (void)participantsDataSourceDidUpdate:(nonnull BIMParticipantsInConversationDataSource *)dataSource {
    [[BIMClient sharedInstance] markConversationRead:self.conversation.conversationID completion:nil];

    [self conversationStatusUpdateProcess];
    
    if (self.conversation.conversationType != BIM_CONVERSATION_TYPE_ONE_CHAT) {
        NSString *participantCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.conversation.memberCount];
        self.title = [NSString stringWithFormat:@"%@(%@)", self.conversation.name.length ? self.conversation.name : self.conversation.conversationID, participantCount];
    }else{
        long long conversationParticipant = self.conversation.oppositeUserID;
        if (conversationParticipant>0) {
            self.title = [BIMUIClient sharedInstance].userProvider(conversationParticipant).nickName;
        }else{
            self.title = @"私聊";
        }
    }
}

#pragma mark - TableView Delegate & Datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    BIMMessage *msg = [self.msgDataSource itemAtIndex:indexPath.row];
    BIMMessage *msg = [self.messageDataSource itemAtIndex:indexPath.row];
    
    id<BIMMember> sender;
    for (id<BIMMember> participant in self.participantsDataSource.participants) {
        if (msg.senderUID == participant.userID) {
            sender = participant;
            break;
        }
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

- (BIMBaseChatCell *)dequestCellForMessage: (BIMMessage *)msg tableView: (UITableView *)tableView{
    BIMBaseChatCell *cell;
    if (msg.isRecalled) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoSystemMsgChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_CUSTOM){
        BIMCustomElement *element = (BIMCustomElement *)msg.element;
        NSInteger type = [element.dataDict[@"type"] integerValue];
        if (type == kBIMMessageTypeSystem || msg.isRecalled) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoSystemMsgChatCell"];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoCustomChatCell"];
        }
    } else if (msg.msgType == BIM_MESSAGE_TYPE_TEXT){
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoTextChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_IMAGE || msg.msgType ==     BIM_MESSAGE_TYPE_VIDEO){
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoImageVideoChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_FILE){
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoFileChatCell"];
    } else if (msg.msgType == BIM_MESSAGE_TYPE_AUDIO) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoAudioChatCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BIMDemoTextChatCell"];
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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageDataSource.numberOfItems;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputTool revertToTheOriginalType];
}

#pragma mark - BIMConversationListListener
- (void)onConversationChanged:(NSArray<BIMConversation *> *)conversationList{
    for (BIMConversation *con in conversationList) {
        if ([self.conversation.conversationID isEqualToString:con.conversationID]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self conversationStatusUpdateProcess];
            });
            break;
        }
    }
}

#pragma mark - User Selection
- (void)userSelectVC:(BIMUserSelectionController *)vc didChooseUser:(BIMUser *)user{
    [self.inputTool addMentionUser:@(user.userID)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTool becomeFirstResponder];
    });
    
}
- (void)userSelectVCDidClickClose:(BIMUserSelectionController *)vc{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTool becomeFirstResponder];
        [self.inputTool inputText:@"@"];
    });
}

#pragma mark - Cell delegate
- (void)chatCell:(BIMBaseChatCell *)cell didClickRetryBtnWithMessage:(BIMMessage *)sendMessage{
    if (self.conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        long long currentUID = [BIMClient sharedInstance].getCurrentUserID.longLongValue;
    
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(currentUID);
        NSString *nickName = user.nickName;
        if (nickName) {
            NSMutableDictionary *ext = [NSMutableDictionary dictionary];
            [ext addEntriesFromDictionary:sendMessage.ext];
            [ext setObject:nickName forKey:@"a:live_group_nick_name"];
            sendMessage.ext = ext.copy;
        }
        
        @weakify(self);
        [[BIMClient sharedInstance] sendLiveGroupMessage:sendMessage                       conversation:self.conversation.conversationID priority:self.inputTool.priority completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [self sendMessageToastWithError:error];
            }
        }];
        return;
    } else {
        @weakify(self);
        [[BIMClient sharedInstance] sendMessage:sendMessage conversationId:self.conversation.conversationID saved:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"消息储存失败:%@",error.localizedDescription]];
                }
            } progress:nil completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [self sendMessageToastWithError:error];
                }
            }];
    }
    
}

- (void)cell:(BIMFileChatCell *)cell didClickImageContent:(BIMMessage *)message{
    self.currentPlayingIndex = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (message.msgType == BIM_MESSAGE_TYPE_VIDEO) {
            [self playVideoWithMessage:message];
        } else if (message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
            BIMImageElement *file = (BIMImageElement *)message.element;
            BOOL hasLocalImage = [[NSFileManager defaultManager] fileExistsAtPath:file.localPath];
            if (hasLocalImage && cell.imageContent.image) {
                [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:cell.imageContent.image];
            } else {
                [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:file.originImg.url secretKey:nil completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error) {
                        [[BIMClient sharedInstance] refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
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
        }
    });
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
        [[BIMClient sharedInstance] refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
            if (error) {
                [BIMToastView toast:error.localizedDescription];
            }
        }];
    } else if (error.code == SDWebImageErrorCancelled) {
        
    } else {
        [BIMToastView toast:error.localizedDescription];
    }
}

#pragma mark - 表情回复
- (void)menuView:(BIMChatMenuViewNew *)menu didClickEmoji:(BIMEmoji *)emoji message:(BIMMessage *)message{
    // 注释，暂时关闭该功能
//    NSInteger row = [self.messageDataSource indexOfItem:message];
//    NSString *currentUserIDStr = [NSString stringWithFormat:@"%lld",[BIMClient sharedInstance].getCurrentUserID.longLongValue];
//    BOOL found = NO;
//    NSArray<BIMMessagePropertyItem *> *arr = message.properties[emoji.emojiDes];
//    for (BIMMessagePropertyItem *prob in arr) {
//        if ([prob.idempotentID isEqualToString:currentUserIDStr]) {
//            found = YES;
//            break;
//        }
//    }
//
//    BIMMessageNewPropertyModify *modify = [[BIMMessageNewPropertyModify alloc] init];
//    modify.key = emoji.emojiDes;
//    modify.idempotentID = currentUserIDStr;
//    modify.value = emoji.imageName;
//    modify.type = found ? BIMMessageNewPropertyModifyTypeRemove : BIMMessageNewPropertyModifyTypeAdd;
//
//        kWeakSelf(self);
//    [[BIMClient sharedInstance] modifyMessage:message propertyItems:@[modify] completion:^(NSError * _Nullable error) {
//        if (error) {
//            [BIMToastView toast:[NSString stringWithFormat:@"表情回复出错：%@",error.localizedDescription]];
//        }
//
//        if (row>=0) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                BIMMessage *msg = [weakself.messageDataSource itemAtIndex:row];
//                [menu refreshMessage:msg];
//            });
//        }
//    }];
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


@end
