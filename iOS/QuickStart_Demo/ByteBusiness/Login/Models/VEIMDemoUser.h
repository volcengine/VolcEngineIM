//
//  VEIMDemoUser.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoUser : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, assign) long long userID;
@property (nonatomic, copy) NSString *userToken;

@property (nonatomic, assign) BOOL isNeedSelection;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
