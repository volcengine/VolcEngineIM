//
//  VEIMDemoProfileEditViewController.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/17.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>
NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoProfileEditViewController : BIMBaseViewController

- (instancetype)initWithUserProfile:(BIMUserProfile *)userProfile;

- (instancetype)initWithUserIdString:(NSString *)userIdString;

@property (nonatomic, assign) BOOL canSelfEdit;

@end

NS_ASSUME_NONNULL_END
