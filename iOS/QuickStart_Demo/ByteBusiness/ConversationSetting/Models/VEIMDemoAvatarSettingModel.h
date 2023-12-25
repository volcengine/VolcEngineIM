//
//  VEIMDemoAvatarSettingModel.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/11/20.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoAvatarSettingModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) void(^clickHandler)(void);
@end

NS_ASSUME_NONNULL_END
