//
//  VEIMBlockListViewController.m
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/25.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoUserListViewController.h"
#import "VEIMDemoInputController.h"
#import "BIMToastView.h"
#import "VEIMDemoDefine.h"

@interface VEIMDemoUserListViewController ()
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) BIMConversation *conversation;
@end

@implementation VEIMDemoUserListViewController

- (instancetype)initWithConversation:(BIMConversation *)conversation
{
    if (self = [super init]) {
        self.conversation = conversation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.isFirstLoad = YES;
    
    [self loadFirstPage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (!self.isFirstLoad) {
//        [self loadFirstPage];
//    }
//
//    self.isFirstLoad = NO;
}

- (void)loadFirstPage
{
    kWeakSelf(self);
    [self loadFirstPageCompletion:^(NSArray<VEIMDemoUser *> *users, BOOL hasMore, BIMError *error) {
        [weakself.users removeAllObjects];
        [weakself.users addObjectsFromArray:users];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableview reloadData];
            [weakself.tableview.mj_header endRefreshing];
        });
    }];
}

- (void)headerRefreshed
{
    [self loadFirstPage];
}

- (BOOL)headerRefreshEnable
{
    return YES;
}

- (BOOL)footerPullEnable
{
    return YES;
}

- (void)footerPulled
{
    kWeakSelf(self);
    [self loadMoreCompletion:^(NSArray<VEIMDemoUser *> *users, BOOL hasMore, BIMError *error) {
        [weakself.users addObjectsFromArray:users];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableview reloadData];
            if (hasMore) {
                [weakself.tableview.mj_footer endRefreshing];
            } else {
                [weakself.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }];
}

#pragma mark -

// @override
- (void)loadFirstPageCompletion:(VEIMDemoUserListCompletion)completion
{
    
}

- (void)loadMoreCompletion:(VEIMDemoUserListCompletion)completion
{
    
}

@end
