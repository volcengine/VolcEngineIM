//
//  BDIMDebugManager.h
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugManager : NSObject

+ (instancetype)sharedManager;

- (void)showDebugEntrance: (UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
