//
//  VEIMDemoSelectAvatarViewController.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/16.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VEIMDemoSelectAvatarType) {
    VEIMDemoSelectAvatarTypeUndefine = 0,
    VEIMDemoSelectAvatarTypeUserProfile = 1,
    VEIMDemoSelectAvatarTypeGroup = 2,
};

@interface VEIMDemoSelectAvatarViewController : BIMBaseViewController
@property(nonatomic, copy) void (^selectCallBack)(NSString *url);

- (instancetype _Nonnull)initWithType:(VEIMDemoSelectAvatarType)type;

@end

NS_ASSUME_NONNULL_END
