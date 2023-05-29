//
//  BIMUser.h
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMUser : NSObject
@property (nonatomic, strong) UIImage *headImg;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) long long userID;
@end

NS_ASSUME_NONNULL_END
