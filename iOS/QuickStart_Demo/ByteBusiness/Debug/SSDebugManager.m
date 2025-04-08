//
//  SSDebugManager.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2025/2/14.
//  Copyright © 2025 loulan. All rights reserved.
//

#import "SSDebugManager.h"

NSString *const kUIDLogin = @"kUIDLogin";

@implementation SSDebugManager
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (void)setUidLogin:(BOOL)uidLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:uidLogin forKey:kUIDLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)uidLogin
{
    BOOL uidLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUIDLogin];
    return uidLogin;
}
@end
