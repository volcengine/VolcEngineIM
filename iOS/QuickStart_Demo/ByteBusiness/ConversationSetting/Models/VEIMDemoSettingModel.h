//
//  VEIMDemoSettingModel.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoSettingModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) void(^clickHandler)(void);

@property (nonatomic, assign) BOOL isNeedSwitch;
@property (nonatomic, assign) BOOL switchOn;
@property (nonatomic, strong) void(^switchHandler)(UISwitch *swt);

+ (instancetype)settingWithTitle: (NSString *)title detail: (NSString *)detail isNeedSwitch: (BOOL)isNeedSwitch switchOn: (BOOL)on;

@end

NS_ASSUME_NONNULL_END
