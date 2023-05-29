//
//  VEIMDemoOnlineListViewController.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/4/26.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoUserListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoOnlineListViewController : VEIMDemoUserListViewController
@property (nonatomic, copy) void (^kickLiveGroupMemberListBlock)(NSArray<NSNumber *> *_Nullable uidList);

@end

NS_ASSUME_NONNULL_END
