//
//  BIMLiveGroupListController.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/19.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewController.h"

typedef NS_ENUM(NSUInteger, VEIMDemoLiveGroupListType);

@class BIMLiveGroupListController, BIMConversation;
@protocol BIMLiveGroupListControllerDelegate <NSObject>

- (void)liveGroupListController:(BIMLiveGroupListController *_Nullable)controller didSelectLiveGroup:(BIMConversation *)liveGroup;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BIMLiveGroupListController : BIMBaseTableViewController

@property(nonatomic, assign) VEIMDemoLiveGroupListType listType;

@property(nonatomic, weak) id<BIMLiveGroupListControllerDelegate> delegate;

- (instancetype)initWithType:(VEIMDemoLiveGroupListType)type;

@end

NS_ASSUME_NONNULL_END
