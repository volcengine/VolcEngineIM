//
//  VEIMDemoConversationExtController.m
//  ByteBusiness
//
//  Created by hexi on 2024/3/24.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoConversationExtController.h"

#import "VEIMDemoSettingModel.h"
#import "VEIMDemoInputController.h"
#import "VEIMDemoConversationSettingCell.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>
#import <im-uikit-tob/BIMToastView.h>

@interface VEIMDemoConversationExtController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settings;
@property (nonatomic, strong) BIMConversation *conversation;

@end

@implementation VEIMDemoConversationExtController

- (instancetype)initWithConversation:(BIMConversation *)conversation
{
    self = [super init];
    if (self) {
        self.title = @"自定义会话额外信息";
        self.conversation = conversation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self createSettingModels];
}

- (void)createSettingModels
{
    self.settings = [NSMutableArray array];
    [self.settings addObject:[self createLocalExtModel]];
    [self.settings addObject:[self createCoreExtModel]];
    [self.settings addObject:[self createMyExtModel]];
    [self.tableView reloadData];
}

#pragma mark - Models

- (VEIMDemoSettingModel *)createLocalExtModel
{
    NSString *detail = nil;
    if (self.conversation.localExt) {
        detail = [self.conversation.localExt btd_jsonStringEncoded];
    }
    VEIMDemoSettingModel *model = [VEIMDemoSettingModel settingWithTitle:@"本地字段" detail:detail isNeedSwitch:NO switchOn:NO];
    @weakify(self);
    model.clickHandler = ^{
        @strongify(self);
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"本地字段" text:detail maxWordCount:1000 editable:YES handler:^(NSString * _Nonnull text) {
            NSDictionary *ext = [text btd_jsonDictionary];
            if (!ext) {
                return;
            }
            [[BIMClient sharedInstance] setConversationLocalExt:self.conversation.conversationID value:ext completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                    return;
                }
                [self createSettingModels];
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return model;
}

- (VEIMDemoSettingModel *)createCoreExtModel
{
    NSString *detail = nil;
    if (self.conversation.coreExt) {
        detail = [self.conversation.coreExt btd_jsonStringEncoded];
    }
    VEIMDemoSettingModel *model = [VEIMDemoSettingModel settingWithTitle:@"公共字段" detail:detail isNeedSwitch:NO switchOn:NO];
    @weakify(self);
    model.clickHandler = ^{
        @strongify(self);
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"公共字段" text:detail maxWordCount:1000 editable:YES handler:^(NSString * _Nonnull text) {
            NSDictionary *ext = [text btd_jsonDictionary];
            if (!ext) {
                return;
            }
            [[BIMClient sharedInstance] setConversationCoreExt:self.conversation.conversationID value:ext completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                    return;
                }
                [self createSettingModels];
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return model;
}

- (VEIMDemoSettingModel *)createMyExtModel
{
    NSString *detail = nil;
    if (self.conversation.myExt) {
        detail = [self.conversation.myExt btd_jsonStringEncoded];
    }
    VEIMDemoSettingModel *model = [VEIMDemoSettingModel settingWithTitle:@"私有字段" detail:detail isNeedSwitch:NO switchOn:NO];
    @weakify(self);
    model.clickHandler = ^{
        @strongify(self);
        VEIMDemoInputController *vc = [[VEIMDemoInputController alloc] initWithTitle:@"私有字段" text:detail maxWordCount:1000 editable:YES handler:^(NSString * _Nonnull text) {
            NSDictionary *ext = [text btd_jsonDictionary];
            if (!ext) {
                return;
            }
            [[BIMClient sharedInstance] setConversationMyExt:self.conversation.conversationID value:ext completion:^(BIMError * _Nullable error) {
                if (error) {
                    [BIMToastView toast:[NSString stringWithFormat:@"失败: %@",error.localizedDescription]];
                    return;
                }
                [self createSettingModels];
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return model;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoSettingModel *setting = self.settings[indexPath.row];
    VEIMDemoConversationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VEIMDemoConversationSettingCell class])];
    cell.model = setting;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoSettingModel *model = self.settings[indexPath.row];
    if (model.clickHandler) {
        model.clickHandler();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[VEIMDemoConversationSettingCell class] forCellReuseIdentifier:NSStringFromClass([VEIMDemoConversationSettingCell class])];
    }
    return _tableView;
}

@end
