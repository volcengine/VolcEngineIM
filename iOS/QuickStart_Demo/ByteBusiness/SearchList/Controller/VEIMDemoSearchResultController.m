//
//  VEIMDemoSearchResultController.m
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/20.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoSearchResultController.h"
#import <Masonry/Masonry.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMSDK.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>
#import "VEIMDemoUserManager.h"
#import <im-uikit-tob/NSDate+IMUtils.h>
#import "VEIMDemoChatViewController.h"
#import "NSArray+BTDAdditions.h"
#import "VEIMDemoSearchResultViewCell.h"
#import "VEIMDemoSearchMessageListResultModel.h"
#import "UIImageView+WebCache.h"
#import <im-uikit-tob/BIMUIClient.h>
#import <im-uikit-tob/BIMUICommonUtility.h>

typedef NS_ENUM(NSInteger, VEIMDemoSearchDataSourceMode) {
    VEIM_DEMO_FTS_MODE = 0,
    VEIM_DEMO_DEFAULT_MODE = 1
};

@interface VEIMDemoSearchResultController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *txtfSearch;
@property (nonatomic, strong) UITableView *tblResult;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, assign) VEIMDemoSearchDataSourceMode currentDataSourceMode;

// 默认展示消息数据源
@property (nonatomic, copy) NSArray<BIMSearchMsgInfo *> *arrDefaultMessageResult;
// FTS搜索结果消息数据源
@property (nonatomic, copy) NSArray<BIMSearchMsgInfo *> *arrFTSMessageResult;
// 当前展示消息数据源
@property (nonatomic, strong) NSArray<BIMSearchMsgInfo *> *currentArrMessageResult;

// 通用拉取方向
@property (nonatomic, assign) BIMPullDirection direction;

// 记录FTS搜索结果的分页锚点信息
@property (nonatomic, strong) VEIMDemoSearchMessageListResultModel *FTSAnchorMessage;
// 记录默认展示消息列表的分页锚点信息
@property (nonatomic, strong) VEIMDemoSearchMessageListResultModel *defaultAnchorMessage;

// 默认展示消息列表页面已加载完毕
@property (nonatomic, assign) BOOL defaultPageLoadComplete;

// 当前FTS搜索key
@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSInteger limit;

@end

@implementation VEIMDemoSearchResultController

- (instancetype)initWithConversationID:(NSString *)conversationID msgType:(BIMMessageType)msgType direction:(BIMPullDirection)direction
{
    self = [super init];
    if (self) {
        _conversationID = conversationID;
        _msgType = msgType;
        // 文本默认只有FTS模式
        _currentDataSourceMode = msgType == BIM_MESSAGE_TYPE_TEXT ? VEIM_DEMO_FTS_MODE : VEIM_DEMO_DEFAULT_MODE;
        _limit = 20;
        _direction = direction;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupMsgs];
    [self updateConstraints];
}

- (void)becomeFirstResponder{
    [self.txtfSearch becomeFirstResponder];
}

- (void)setupViews
{
    [self.view addSubview:self.txtfSearch];
    [self.view addSubview:self.tblResult];
    [self.view addSubview:self.emptyLabel];
}

- (void)setupUIElements
{
    self.tblResult.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerPulled)];
    if(self.msgType == BIM_MESSAGE_TYPE_TEXT) {
        self.tblResult.mj_footer.hidden = YES;
        [self.tblResult.mj_footer setState:MJRefreshStateNoMoreData];
    }
}

- (void)setupMsgs
{
    if (self.msgType == BIM_MESSAGE_TYPE_FILE) {
        BIMGetMessageByTypeOption *option = [self createOptionWithAnchorMessage:nil limit:self.limit messageTypeList:@[@(self.msgType)] direction:self.direction];
        @weakify(self);
        [[BIMClient sharedInstance] getLocalMessageListByType:self.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [BIMToastView toast:error.localizedDescription];
                return;
            }
            
            BIMSearchMsgInfo *anchorInfo = [BIMSearchMsgInfo new];
            anchorInfo.message = anchorMessage;
            
            NSMutableArray<BIMSearchMsgInfo *> *searchInfoList = [NSMutableArray new];
            for (BIMMessage *msg in messages) {
                BIMSearchMsgInfo *msgInfo = [BIMSearchMsgInfo new];
                msgInfo.message = msg;
                [searchInfoList btd_addObject:msgInfo];
            }
            
            self.defaultAnchorMessage = [[VEIMDemoSearchMessageListResultModel alloc] initWithAnchorMessage:anchorInfo hasMore:hasMore searchInfoList:searchInfoList.copy];
            self.arrDefaultMessageResult = searchInfoList.copy;
            
            self.currentDataSourceMode = VEIM_DEMO_DEFAULT_MODE;
            self.currentArrMessageResult = self.arrDefaultMessageResult;
            
            self.emptyLabel.hidden = searchInfoList.count;
            self.tblResult.mj_footer.hidden = !self.currentArrMessageResult.count;
            
            [self reloadTable];
        }];
    }
}

//- (void)viewSafeAreaInsetsDidChange{
//    [super viewSafeAreaInsetsDidChange];
//    [self updateConstraints];
//}

- (void)updateConstraints
{
    [self.txtfSearch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view);
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

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblResult reloadData];
    });
}

- (void)didSearchTextChange:(NSString *)word
{
    self.key = word;
    if (BTD_isEmptyString(word)) {
        self.arrFTSMessageResult = @[];
        self.FTSAnchorMessage = nil;
        // 切换数据源
        self.currentArrMessageResult = self.arrDefaultMessageResult;
        if (self.msgType == BIM_MESSAGE_TYPE_FILE) {
            self.currentDataSourceMode = VEIM_DEMO_DEFAULT_MODE;
            
            // 切换为默认列表，有可能FTS加载完毕，但是默认列表加载完，所以需要更新footer状态
            if (!self.defaultPageLoadComplete) {
                [self.tblResult.mj_footer resetNoMoreData];
            } else {
                [self.tblResult.mj_footer setState:MJRefreshStateNoMoreData];
            }
        } else {
            [self.tblResult.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
        self.tblResult.mj_footer.hidden = !self.currentArrMessageResult.count;
        self.emptyLabel.hidden = YES;
        [self reloadTable];
        return;
    }

    [self.tblResult.mj_footer resetNoMoreData];
    self.currentDataSourceMode = VEIM_DEMO_FTS_MODE;
    @weakify(self);
    BIMGetMessageByTypeOption *option = [self createOptionWithAnchorMessage:nil limit:self.limit messageTypeList:@[@(self.msgType)] direction:self.direction];
    [[BIMClient sharedInstance] searchLocalMessage:self.conversationID key:word option:option completion:^(NSArray<BIMSearchMsgInfo *> * _Nullable infos, BOOL hasMore, BIMSearchMsgInfo * _Nullable anchorMessage, BIMError * _Nullable error) {
        @strongify(self);
        if (![self.txtfSearch.text isEqualToString:word]) {
            return;
        }
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            self.arrFTSMessageResult = infos.copy;
        }
        
        self.FTSAnchorMessage = [[VEIMDemoSearchMessageListResultModel alloc] initWithAnchorMessage:anchorMessage hasMore:hasMore searchInfoList:infos];
        // 切换数据源
        self.currentArrMessageResult = self.arrFTSMessageResult;
        
        self.emptyLabel.hidden = infos.count;
        self.tblResult.mj_footer.hidden = !self.currentArrMessageResult.count;
        [self reloadTable];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.currentArrMessageResult.count && self.msgType == BIM_MESSAGE_TYPE_TEXT) {
        return @"消息记录";
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArrMessageResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoSearchResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(VEIMDemoSearchResultViewCell.class)];
    if (!cell) {
        cell = [[VEIMDemoSearchResultViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(VEIMDemoSearchResultViewCell.class)];
    }
    cell.msgType = self.msgType;
    BIMSearchMsgInfo *msg = [self.currentArrMessageResult btd_objectAtIndex:indexPath.row];
    
    BIMUser *user = [BIMUIClient sharedInstance].userProvider(msg.message.senderUID);
    NSString *userName = [BIMUICommonUtility getShowNameWithUser:user];;
    if (self.msgType == BIM_MESSAGE_TYPE_TEXT) {
        cell.nameLabel.text = userName;
        cell.subTitleLabel.attributedText = ({
            NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
            [astrm appendAttributedString:[self attributedStringWithString:msg.searchDetail.searchContent arrRange:msg.searchDetail.keyPositions]];
            astrm.copy;
        });
        cell.detailLabel.text = msg.message.createdTime.im_stringDate;
        [cell.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:user.placeholderImage];
    } else {
        BIMFileElement *element = BTD_DYNAMIC_CAST(BIMFileElement, msg.message.element);
        // FILE VC在不同消息源的情况下，展示cell的UI不同
        if (self.currentDataSourceMode == VEIM_DEMO_FTS_MODE) {
            cell.nameLabel.attributedText = ({
                NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
                [astrm appendAttributedString:[self attributedStringWithString:msg.searchDetail.searchContent arrRange:msg.searchDetail.keyPositions]];
                astrm.copy;
            });
        } else {
            cell.nameLabel.text = element.fileName;
        }
        
        cell.subTitleLabel.text = ({
            NSString *fileSize = [self formattedFileSize:element.fileSize];
            NSString *senderName = userName;
            
            NSString *astrm = [NSString stringWithFormat:@"%@ %@", fileSize, senderName];
            astrm.copy;
        });
        
        cell.dateLabel.text = msg.message.createdTime.im_stringDate;
        [cell.portrait setImage:[kIMAGE_IN_BUNDLE_NAMED(@"icon_msg_file") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    
    [cell setupConstraints];
    return cell;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)string arrRange:(NSArray<NSValue *> *)arrRange
{
    if (!string) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:string];
    [arrRange enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [astrm addAttributes:@{NSForegroundColorAttributeName : [UIColor systemBlueColor]} range:[obj rangeValue]];
    }];
    return astrm.copy;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BIMSearchMsgInfo *msg = [self.currentArrMessageResult btd_objectAtIndex:indexPath.row];
    if (self.msgType == BIM_MESSAGE_TYPE_TEXT) {
        @weakify(self);
        [[BIMClient sharedInstance] getConversation:msg.message.conversationID completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
            @strongify(self);
            VEIMDemoChatViewController *nVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
            nVC.anchorMessage = msg.message;
            [self.navigationController pushViewController:nVC animated:YES];
        }];
    } else {
        BIMFileElement *element = BTD_DYNAMIC_CAST(BIMFileElement, msg.message.element);
        if (![[NSFileManager defaultManager] fileExistsAtPath:element.downloadPath]) {
            [BIMToastView toast:@"下载中"];
            [[BIMClient sharedInstance] downloadFile:msg.message remoteURL:element.url progressBlock:nil completion:^(BIMError * _Nullable error) {
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
            NSString *fileSize = [self formattedFileSize:element.fileSize];
            NSRange range = [element.fileName rangeOfString:@"." options:NSBackwardsSearch];
            NSString *fileType = range.length == 0 ? @"" : [element.fileName substringFromIndex:range.location + 1];
            NSString *fileInfo = [NSString stringWithFormat:@"文件大小：%@\n文件格式：%@", fileSize, fileType];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"暂不支持文件预览" message:fileInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:sure];
            [weakself presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

# pragma mark - footer refresh
- (void)footerPulled
{
    [self loadMoreMessages];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField
{
    [self didSearchTextChange:textField.text];
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

- (NSArray<BIMSearchMsgInfo *> *)currentArrMessageResult
{
    if (!_currentArrMessageResult && self.msgType == BIM_MESSAGE_TYPE_FILE && self.currentDataSourceMode == VEIM_DEMO_DEFAULT_MODE) {
        return _arrDefaultMessageResult;
    }
    
    return _currentArrMessageResult;
}

#pragma mark - 拉消息
- (void)loadMoreMessages
{
    if (self.currentDataSourceMode == VEIM_DEMO_FTS_MODE) {
        if (!self.FTSAnchorMessage || !self.FTSAnchorMessage.hasMore) {
            [self.tblResult.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        @weakify(self);
        BIMGetMessageByTypeOption *option = [self createOptionWithAnchorMessage:self.FTSAnchorMessage.anchorMessage.message limit:self.limit messageTypeList:@[@(self.msgType)] direction:self.direction];
        
        NSString *word = self.key;
        [[BIMClient sharedInstance] searchLocalMessage:self.conversationID key:word option:option completion:^(NSArray<BIMSearchMsgInfo *> * _Nullable infos, BOOL hasMore, BIMSearchMsgInfo * _Nullable anchorMessage, BIMError * _Nullable error) {
            @strongify(self);
            if (![self.key isEqualToString:word]) {
                return;
            }
            if (error) {
                [BIMToastView toast:error.localizedDescription];
            } else {
                self.arrFTSMessageResult = [self.arrFTSMessageResult btd_arrayByAddingObjectsFromArray:infos.copy];
            }
            
            self.FTSAnchorMessage = [[VEIMDemoSearchMessageListResultModel alloc] initWithAnchorMessage:anchorMessage hasMore:hasMore searchInfoList:infos];
            
            // 切换数据源
            self.currentArrMessageResult = self.arrFTSMessageResult;
            self.emptyLabel.hidden = infos.count;
            [self reloadTable];
        }];
        [self.tblResult.mj_footer endRefreshing];
    } else {
        if (self.msgType == BIM_MESSAGE_TYPE_FILE) {
            if (!self.defaultAnchorMessage.hasMore) {
                [self.tblResult.mj_footer endRefreshingWithNoMoreData];
                self.defaultPageLoadComplete = YES;
                return;
            }
            
            BIMGetMessageByTypeOption *option = [self createOptionWithAnchorMessage:self.defaultAnchorMessage.anchorMessage.message limit:self.limit messageTypeList:@[@(self.msgType)] direction:self.direction];
            @weakify(self);
            [[BIMClient sharedInstance] getLocalMessageListByType:self.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
                @strongify(self);
                if (error) {
                    [BIMToastView toast:error.localizedDescription];
                    return;
                }
                
                BIMSearchMsgInfo *anchorInfo = [BIMSearchMsgInfo new];
                anchorInfo.message = anchorMessage;
                
                NSMutableArray<BIMSearchMsgInfo *> *searchInfoList = [NSMutableArray new];
                for (BIMMessage *msg in messages) {
                    BIMSearchMsgInfo *msgInfo = [BIMSearchMsgInfo new];
                    msgInfo.message = msg;
                    [searchInfoList btd_addObject:msgInfo];
                }
                
                self.defaultAnchorMessage = [[VEIMDemoSearchMessageListResultModel alloc] initWithAnchorMessage:anchorInfo hasMore:hasMore searchInfoList:searchInfoList.copy];
                self.arrDefaultMessageResult = [self.arrDefaultMessageResult btd_arrayByAddingObjectsFromArray:searchInfoList.copy];
                
                self.currentDataSourceMode = VEIM_DEMO_DEFAULT_MODE;
                self.currentArrMessageResult = self.arrDefaultMessageResult;
                [self reloadTable];
            }];
            [self.tblResult.mj_footer endRefreshing];
        }
    }
}

#pragma - 文件方法

- (NSString *)formattedFileSize:(unsigned long long)byteSize {
    CGFloat mbSize = byteSize/1000.0/1000.0;
    CGFloat kbSize = byteSize/1000.0;
    
    NSString *formattedFileSize;
    if (mbSize > 1){
        formattedFileSize = [NSString stringWithFormat:@"%.2f MB",mbSize];
    } else if (kbSize > 1) {
        formattedFileSize = [NSString stringWithFormat:@"%.2f KB",kbSize];
    } else {
        formattedFileSize = [NSString stringWithFormat:@"%llu B", byteSize];
    }
    
    return formattedFileSize;
}

#pragma mark - 创建锚点消息信息

- (BIMGetMessageByTypeOption *)createOptionWithAnchorMessage:(BIMMessage *)message limit:(NSInteger)limit messageTypeList:(NSArray<NSNumber *> *)messageTypeList direction:(BIMPullDirection)direction
{
    BIMGetMessageByTypeOption *option = [[BIMGetMessageByTypeOption alloc] init];
    option.anchorMessage = message;
    option.limit = limit;
    option.messageTypeList = messageTypeList;
    option.direction = direction;
    
    return option;
}
@end


