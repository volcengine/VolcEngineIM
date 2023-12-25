//
//ConversationListController.m
//
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMConversationListController.h"
#import "BIMConversationListDataSource.h"
#import "BIMBaseConversationListController+Private.h"

@implementation BIMConversationListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = BIMConversationListTypeAllConversation;
    }
    return self;
}

- (void)setupDataSource
{
    super.conversationDataSource = [[BIMConversationListDataSource alloc] init];
}

@end
