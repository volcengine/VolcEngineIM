//
//  VEIMDemoMemberModel.h
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/9/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <imsdk-tob/BIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoMemberModel : NSObject <BIMMember>
@property (nonatomic, assign) long long userID;
@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, assign) long long sortOrder;
@property (nonatomic, assign) BIMMemberRole role;
@property (nonatomic, copy, nullable) NSString *alias;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSDictionary *ext;
@end

NS_ASSUME_NONNULL_END
