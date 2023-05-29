//
//  VEIMDemoSettingModel.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoSettingModel.h"

@implementation VEIMDemoSettingModel

+ (instancetype)settingWithTitle:(NSString *)title detail:(NSString *)detail isNeedSwitch:(BOOL)isNeedSwitch switchOn:(BOOL)on{
    VEIMDemoSettingModel *model = [VEIMDemoSettingModel new];
    model.title = title;
    model.detail = detail;
    model.isNeedSwitch = isNeedSwitch;
    model.switchOn = on;
    return model;
}

@end
