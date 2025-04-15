//
//ConversationListController.m
//
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMConversationListController.h"

#import "BIMConversationCell.h"
#import "BIMConversationListDataSource.h"
#import "BIMBaseConversationListController+Private.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BTDMacros.h>

@interface BIMConversationListController () <BIMConversationListListener>

/// 置顶的机器人会话是否被删除
@property (nonatomic, assign) BOOL hasDeleteStickOnTopRobotCoverastion;
@property (nonatomic, strong) BIMConversation *stickOnTopRobotCoverastion;

@end

@implementation BIMConversationListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = BIMConversationListTypeAllConversation;
        [[BIMClient sharedInstance] addConversationListener:self];
    }
    return self;
}

- (void)dealloc
{
    [[BIMClient sharedInstance] removeConversationListener:self];
}

- (void)setupDataSource
{
    BIMConversationListDataSource *conversationDataSource = [[BIMConversationListDataSource alloc] init];
    conversationDataSource.filterBlock = ^BOOL(BIMConversation *conversation) {
        if ([self isStickOnTopRobotCoverastionId:conversation.conversationID]) {
            return NO;
        }
        return YES;
    };
    self.conversationDataSource = conversationDataSource;
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.conversationDataSource.conversationList.count;
    if (self.stickOnTopRobotCoverastion && !self.hasDeleteStickOnTopRobotCoverastion) {
        /// 置顶机器人会话未删除时，会话列表最上方还需要放置机器人会话
        count++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMConversationCell"];
    BIMConversation *conv = [self conversationAtIndexPath:indexPath];
    [self prepareCell:cell forConverastion:conv];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BIMConversation *conv = [self conversationAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(conversationListController:didSelectConversation:)]) {
        [self.delegate conversationListController:self didSelectConversation:conv];
    }
}

#pragma mark - Private

- (void)userDidLogin
{
    [super userDidLogin];
    
    if (self.stickOnTopRobotUserID) {
        @weakify(self);
        [[BIMClient sharedInstance] createSingleConversation:self.stickOnTopRobotUserID completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
            @strongify(self);
            if (!conversation || error) {
                return;
            }
            
            self.stickOnTopRobotCoverastion = conversation;
            [self reloadData];
            /// 马上判断会话是否有消息可能因为缓存层问题，导致取到的 lastMessage 为 nil
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                @weakify(self);
                [[BIMClient sharedInstance] getConversation:conversation.conversationID completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
                    @strongify(self);
                    self.stickOnTopRobotCoverastion = conversation;
                    [self reloadData];
                    if (!conversation.lastMessage) {
                        [[BIMClient sharedInstance] markNewChat:conversation.conversationID needNotice:YES completion:^(BIMError * _Nullable error) {}];
                    }
                }];
            });
        }];
        
    }
}

- (BIMConversation *)conversationAtIndexPath:(NSIndexPath *)indexPath
{
    BIMConversation *conv;
    if (!self.stickOnTopRobotCoverastion || self.hasDeleteStickOnTopRobotCoverastion) {
        conv = self.conversationDataSource.conversationList[indexPath.row];
    } else {
        if (indexPath.row == 0) {
            conv = self.stickOnTopRobotCoverastion;
        } else if (self.conversationDataSource.conversationList.count) {
            conv = self.conversationDataSource.conversationList[indexPath.row - 1];
        }
    }
    return conv;
}

- (BOOL)isStickOnTopRobotCoverastionId:(NSString *)coverastionId
{
    if (self.stickOnTopRobotUserID) {
        return [coverastionId containsString:self.stickOnTopRobotUserID.stringValue];
    }
    return NO;
}

#pragma mark - BIMConversationListListener

- (void)onNewConversation:(NSArray<BIMConversation *> *)conversationList
{
    [conversationList enumerateObjectsUsingBlock:^(BIMConversation * _Nonnull conversation, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isStickOnTopRobotCoverastionId:conversation.conversationID]) {
            self.hasDeleteStickOnTopRobotCoverastion = NO;
            [self reloadData];
            *stop = YES;
        }
    }];
}

- (void)onConversationDeleted:(NSArray<NSString *> *)conversationIdList
{
    [conversationIdList enumerateObjectsUsingBlock:^(NSString * _Nonnull conversationId, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isStickOnTopRobotCoverastionId:conversationId]) {
            self.hasDeleteStickOnTopRobotCoverastion = YES;
            [self reloadData];
            *stop = YES;
        }
    }];
}

- (void)onConversationChanged:(NSArray<BIMConversation *> *)conversationList
{
    [conversationList enumerateObjectsUsingBlock:^(BIMConversation * _Nonnull conversation, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isStickOnTopRobotCoverastionId:conversation.conversationID]) {
            self.stickOnTopRobotCoverastion = conversation;
            self.hasDeleteStickOnTopRobotCoverastion = NO;
            [self reloadData];
            *stop = YES;
        }
    }];
}

@end
