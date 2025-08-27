//
//  BIMUser.h
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import <Foundation/Foundation.h>
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMUser : NSObject
@property (nonatomic, assign) long long userID;
@property (nonatomic, copy) NSString *userIDString;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *portraitUrl;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) BOOL isRobot;     /// 是否为机器人身份。
@end

NS_ASSUME_NONNULL_END
