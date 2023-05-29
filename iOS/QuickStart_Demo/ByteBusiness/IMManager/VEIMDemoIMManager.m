//
//  VEIMDemoIMManager.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/2.
//

#import "VEIMDemoIMManager.h"
#import "VEIMDemoDefine.h"
#import "BDIMDebugNetworkManager.h"
#import "VEIMDemoUserManager.h"

#import <OneKit/UIDevice+BTDAdditions.h>
#import <TTNetworkManager/TTNetworkManager.h>

@interface VEIMDemoIMManager ()

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *installID;

@end


@implementation VEIMDemoIMManager

+ (instancetype)sharedManager{
    static VEIMDemoIMManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[VEIMDemoIMManager alloc] init];
        }
    });
    return _sharedInstance;
}
@end
