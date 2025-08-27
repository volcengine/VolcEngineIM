//
//  VEIMDemoUser.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import <Foundation/Foundation.h>
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoUser : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy, nullable) NSArray<NSString *> *markTypes;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, assign) long long userIDNumber; // 全量字符串接口后，移除该字段
@property (nonatomic, copy) NSString *userIDString;
@property (nonatomic, copy) NSString *userToken;

@property (nonatomic, assign) BOOL isNeedSelection;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *onlineString;

@property (nonatomic, strong) id<BIMMember> member;
@end

NS_ASSUME_NONNULL_END
