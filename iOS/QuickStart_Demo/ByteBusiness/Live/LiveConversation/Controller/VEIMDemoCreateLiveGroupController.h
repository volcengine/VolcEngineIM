//
//  VEIMDemoCreateLiveGroupControllerViewController.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class BIMGroupInfo;
@protocol VEIDemoCreateLiveGroupControllerDelegate <NSObject>

- (void)createLiveGroupWithInfo:(BIMGroupInfo *)groupInfo;

@end

@interface VEIMDemoCreateLiveGroupController : BIMBaseTableViewController

@property(nonatomic, weak) id<VEIDemoCreateLiveGroupControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
