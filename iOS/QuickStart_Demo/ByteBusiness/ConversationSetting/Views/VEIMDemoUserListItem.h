//
//  VEIMDemoUserListItem.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoBaseView.h"
#import "VEIMDemoUserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoUserListItem : VEIMDemoBaseView

@property (nonatomic, strong) UIImageView *userPortrait;
@property (nonatomic, strong) UILabel *userName;

- (void)refreshWithParticipant: (long long)uid;

@end

NS_ASSUME_NONNULL_END
