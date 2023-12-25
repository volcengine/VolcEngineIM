//
//  VEIMDemoSelectAvatarViewController.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/16.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoSelectAvatarViewController : BIMBaseViewController
@property(nonatomic, copy) void (^selectCallBack)(NSString *url);
@end

NS_ASSUME_NONNULL_END
