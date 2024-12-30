//
//  BIMConversationListManager.m
//  im-uikit-tob
//
//  Created by hexi on 2023/11/19.
//

#import "BIMConversationListManager.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/BytedanceKit.h>

@interface BIMConversationListManager ()

@property (nonatomic, copy, readwrite) NSMutableArray<BIMConversation *> *chatList;

@property (nonatomic, strong) NSMutableDictionary *chatDict;

@end

@implementation BIMConversationListManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chatDict = [NSMutableDictionary dictionary];
        _chatList = [NSMutableArray array];
    }
    return self;
}

- (void)binaryInsertChatList:(NSArray<BIMConversation *> *)conversationList
{
    if (BTD_isEmptyArray(conversationList)) {
        return;
    }
    //TODO:可以将增删改区分出来，更方便的做增量刷新
    for (BIMConversation *con in conversationList) {
        [self binaryInsertChat:con];
    }

    if ([self.delegate respondsToSelector:@selector(chatListDidProcessed:)]) {
        [self.delegate chatListDidProcessed:[self.chatList copy]];
    }
}

- (void)removeChatWithIdentifiers:(NSArray<NSString *> *)conversationIdList
{
    if (BTD_isEmptyArray(conversationIdList)) {
        return;
    }
    for (NSString *conversationId in conversationIdList) {
        BIMConversation *con = self.chatDict[conversationId];
        [self.chatDict removeObjectForKey:conversationId];
        [self.chatList removeObject:con];
    }

    if ([self.delegate respondsToSelector:@selector(chatListDidProcessed:)]) {
        [self.delegate chatListDidProcessed:[self.chatList copy]];
    }
}

#pragma mark - Private

- (void)binaryInsertChat:(BIMConversation *)chat
{
    if (!chat || chat.conversationID == 0) {
        return;
    }

    BIMConversation *oldChat = self.chatDict[chat.conversationID];
    [self.chatDict setValue:chat forKey:chat.conversationID];
    [self.chatList removeObject:oldChat];
    NSInteger index = [self locationOfChatAtChatArray:chat];
    [self.chatList insertObject:chat atIndex:index];
}

- (NSInteger)locationOfChatAtChatArray:(BIMConversation *)chat {
    NSInteger left = 0;
    NSInteger right = self.chatList.count - 1;
    while (left <= right) {
        NSInteger mid = (left + right) / 2;
        BIMConversation *c = [self.chatList objectAtIndex:mid];
        if ([self chatA:chat greaterThanOrEqualToChatB:c]) {
            right = mid - 1;
        } else {
            left = mid +1;
        }
    }
    return left;
}

- (BOOL)chatA:(BIMConversation *)chatA greaterThanOrEqualToChatB:(BIMConversation *)chatB
{
    if (chatA.sortOrder == chatB.sortOrder) {
        return chatA.conversationShortID.longLongValue >= chatB.conversationShortID.longLongValue;
    }
    return chatA.sortOrder >= chatB.sortOrder;
}

@end
