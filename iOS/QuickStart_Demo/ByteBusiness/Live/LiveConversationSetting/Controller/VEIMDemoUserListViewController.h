//
//  VEIMUserListViewController.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/25.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewController.h"
#import "VEIMDemoUserSelectionController.h"
#import <imsdk-tob/BIMSDK.h>

typedef void (^VEIMDemoUserListCompletion)(NSArray<VEIMDemoUser *> *users, BOOL hasMore, BIMError *error);

//@protocol VEIMDemoUserListViewControllerDataSource <NSObject>
//
//- (NSArray<VEIMDemoUser *> *_Nullable)users;
//
//- (void)loadMoreCompletion:(VEIMDemoUserListCompletion _Nullable )completion;
//
//- (void)loadFirstPageCompletion:(VEIMDemoUserListCompletion _Nullable )completion;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoUserListViewController : VEIMDemoUserSelectionController
@property (nonatomic, strong, readonly) BIMConversation *conversation;

- (instancetype)initWithConversation:(BIMConversation *)conversation;

//@property (nonatomic, weak) id<VEIMDemoUserListViewControllerDataSource> dataSource;
// @override
- (void)loadMoreCompletion:(VEIMDemoUserListCompletion _Nullable )completion;

- (void)loadFirstPageCompletion:(VEIMDemoUserListCompletion _Nullable )completion;

@end

NS_ASSUME_NONNULL_END
