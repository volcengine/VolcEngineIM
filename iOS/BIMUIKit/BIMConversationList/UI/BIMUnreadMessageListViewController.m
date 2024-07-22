//
//  BIMUnreadMessageListViewController.m
//  im-uikit-tob
//
//  Created by jacky on 2024/7/9.
//

#import "BIMUnreadMessageListViewController.h"
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient.h>
#import <Masonry/Masonry.h>
#import <OneKit/UIButton+BTDAdditions.h>
#import <OneKit/BTDMacros.h>
#import <im-uikit-tob/BIMToastView.h>
#import <MJRefresh/MJRefreshAutoNormalFooter.h>
#import <MJRefresh/UIScrollView+MJRefresh.h>



@interface BIMUnreadMessageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *infoContainerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *msgIdTextField;
@property (nonatomic, strong) UITextField *conversationIdTextField;
@property (nonatomic, strong) UILabel *msgIdLabel;
@property (nonatomic, strong) UILabel *conversationIdLabel;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, copy) NSArray<BIMMessage *> *dataSource;
@property (nonatomic, strong) BIMMessage *anchorMessage;
@property (nonatomic, strong) MJRefreshFooter *footer;

@end

@implementation BIMUnreadMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"未读消息列表";
    
    [self setupSubviews];
}

- (void)loadUnreadMessagesWithMessage:(BIMMessage *)message conversationId:(NSString *)conversationID completion:(void (^)(BOOL hasMore, BIMError * error))completion
{
    //查询未读消息
    BIMGetMessageOption *options = [[BIMGetMessageOption alloc] init];
    options.limit = 5;
    options.anchorMessage = message;
    [[BIMClient sharedInstance] getConversationUnReadMessageList:conversationID option:options completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {

        NSMutableArray *newDataSource = [self.dataSource mutableCopy] ?: [NSMutableArray array];
        if (messages) {
            [newDataSource addObjectsFromArray:messages];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource = [newDataSource copy];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
            if (!hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (error) {
                [BIMToastView toast:[NSString stringWithFormat:@"errorCode:%@ error:%@", @(error.code), [error localizedDescription]]];
            }
            completion(hasMore, error);
        });
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    BIMMessage *message = self.dataSource[indexPath.row];
    NSString *desc;
    if ([message.element isKindOfClass:[BIMTextElement class]]) {
        BIMTextElement *element = message.element;
        desc = [NSString stringWithFormat:@"未读消息：text:%@ orderIndex:%@", [element text], @(message.orderIndex)];
    } else {
        desc = [NSString stringWithFormat:@"未读消息：orderIndex:%@", @(message.orderIndex)];
    }
    cell.textLabel.text = desc;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMMessage *message = self.dataSource[indexPath.row];
    self.msgIdTextField.text = [message.serverMessageID stringValue];
    self.anchorMessage = message;
}

#pragma mark - setup
- (void)setupSubviews
{
    _infoContainerView = [UIView new];
    [self.view addSubview:_infoContainerView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    @weakify(self);
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.dataSource.count == 0) {
            return;
        }
        
        BIMMessage *message = [self.dataSource lastObject];
        NSString *conversationId = self.conversationIdTextField.text;
        [self loadUnreadMessagesWithMessage:message conversationId:conversationId completion:^(BOOL hasMore, BIMError * error) {
            
        }];
    }];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    
    _msgIdLabel = [[UILabel alloc] init];
    _msgIdLabel.text = @"消息id";
    _conversationIdLabel = [[UILabel alloc] init];
    _conversationIdLabel.text = @"会话id";
    
    _msgIdTextField = ({
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = @"请输入消息id";
        tf.adjustsFontSizeToFitWidth = YES;
        tf.layer.borderWidth =0.5f;
        tf;
    });
    
    _conversationIdTextField = ({
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = @"请输入会话id";
        tf.text = self.conversation.conversationID;
        tf.adjustsFontSizeToFitWidth = YES;
        tf.layer.borderWidth =0.5f;
        tf;
    });
    
    _queryButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn btd_addActionBlockForTouchUpInside:^(__kindof UIButton * _Nonnull sender) {
            NSString *conversationId = self.conversationIdTextField.text;
            self.dataSource = nil;
            [self.tableView reloadData];
            [self.tableView.mj_footer resetNoMoreData];
            self.tableView.mj_footer.hidden = YES;
            BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
            option.limit = 20;
            
            option.limit = 5;
            NSString *messageId = self.msgIdTextField.text;
            BIMMessage *anchorMessage = nil;
            if (!BTD_isEmptyString(messageId)) {//有messageID
                [[BIMClient sharedInstance] getConversation:conversationId completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
                    if (!conversation) {
                        [BIMToastView toast:@"无效会话，请检查输入参数"];
                        return;
                    }
                    if (error) {
                        [BIMToastView toast:[NSString stringWithFormat:@"%@", [error description]]];
                        return;
                    }
                    [[BIMClient sharedInstance] getMessageByServerID:[messageId longLongValue] inConversationShortID:[conversation.conversationShortID longLongValue] isServer:NO completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                        if (!message) {
                            [BIMToastView toast:@"无效消息id"];
                            return;
                        }
                        
                        if (error) {
                            [BIMToastView toast:[NSString stringWithFormat:@"%@", [error description]]];
                            return;
                        }
                        
                        [self loadUnreadMessagesWithMessage:message conversationId:conversationId completion:^(BOOL hasMore, BIMError * error) {
                            
                        }];
                    }];
                }];
            } else {
                [self loadUnreadMessagesWithMessage:nil conversationId:conversationId completion:^(BOOL hasMore, BIMError * error) {
                    
                }];
            }
        }];
        [btn setTitle:@"查询" forState:UIControlStateNormal];
        btn;
    });
    NSArray *array = @[@1, @2];
    _clearButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        @weakify(self);
        [btn btd_addActionBlockForTouchUpInside:^(__kindof UIButton * _Nonnull sender) {
            @strongify(self);
            NSString *conversationId = self.conversationIdTextField.text;
            if (BTD_isEmptyString(conversationId)) {
                [BIMToastView toast:@"无效会话id"];
                return;
            }
            NSString *messageId = self.msgIdTextField.text;
            [[BIMClient sharedInstance] getConversation:conversationId completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
                if (!conversation) {
                    [BIMToastView toast:@"无效会话，请检查输入参数"];
                    return;
                }
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"%@", [error description]]];
                    return;
                }
                [[BIMClient sharedInstance] getMessageByServerID:[messageId longLongValue] inConversationShortID:[conversation.conversationShortID longLongValue] isServer:NO completion:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
                    if (!message) {
                        [BIMToastView toast:@"无效消息，请检查输入参数"];
                        return;
                    }
                    

                    if (error) {
                        [BIMToastView toast:[NSString stringWithFormat:@"%@", [error description]]];
                        return;
                    }

                    [[BIMClient sharedInstance] markConversationRead:conversationId beforeMessage:message completion:^(BIMError * _Nullable error) {
                        if (error) {
                            [BIMToastView toast:[NSString stringWithFormat:@"%@", [error description]]];
                        }
                    }];
                }];
            }];
        }];
        [btn setTitle:@"清除未读数" forState:UIControlStateNormal];
        btn;
    });
    
    [_infoContainerView addSubview:_msgIdTextField];
    [_infoContainerView addSubview:_conversationIdTextField];
    [_infoContainerView addSubview:_msgIdLabel];
    [_infoContainerView addSubview:_conversationIdLabel];
    [_infoContainerView addSubview:_queryButton];
    [_infoContainerView addSubview:_clearButton];
    
    
    
    [_infoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.height.mas_equalTo(180);
    }];
    
    [_msgIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoContainerView.mas_left).offset(10);
        make.top.equalTo(_infoContainerView.mas_top).offset(10);
        make.bottom.equalTo(_conversationIdLabel.mas_top).offset(-10);
        make.height.equalTo(_conversationIdLabel);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [_msgIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_infoContainerView.mas_right).offset(-10);
        make.top.equalTo(_msgIdLabel);
        make.left.equalTo(_msgIdLabel.mas_right).offset(10);
        make.height.equalTo(_msgIdLabel);
    }];
    
    [_conversationIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_msgIdLabel);
        make.bottom.equalTo(_clearButton.mas_top).offset(-10);
    }];
    
    [_conversationIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_msgIdTextField);
        make.top.equalTo(_conversationIdLabel);
        make.height.equalTo(_conversationIdLabel);
    }];
    
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.equalTo(_infoContainerView.mas_right).offset(-20);
        make.bottom.equalTo(_infoContainerView.mas_bottom).offset(-10);
    }];
    
    [_queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.equalTo(_clearButton.mas_left).offset(-30);
        make.top.equalTo(_clearButton);
        make.bottom.equalTo(_infoContainerView.mas_bottom).offset(-10);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_infoContainerView.mas_bottom);
    }];
}

@end
