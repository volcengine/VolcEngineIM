//
//  SSDebugManager.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2025/2/14.
//  Copyright © 2025 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSDebugManager : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL uidLogin;

@end

NS_ASSUME_NONNULL_END
