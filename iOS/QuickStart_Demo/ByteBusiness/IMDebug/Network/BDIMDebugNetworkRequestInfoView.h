//
//  BDIMDebugNetworkRequestInfoView.h
//  ByteBusiness
//
//  Created by Weibai on 2022/10/21.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDIMDebugNetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugNetworkRequestInfoView : UIView


- (void)showRequest: (BDIMDebugNetworkRequest *)request;

@end

NS_ASSUME_NONNULL_END
