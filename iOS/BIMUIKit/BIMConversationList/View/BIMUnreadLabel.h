//
//UnreadLabel.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/15.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BIMConversation;
NS_ASSUME_NONNULL_BEGIN

@interface BIMUnreadLabel : UILabel

- (void)refreshWithConversation: (BIMConversation *)conv;

- (void)refreshWithCount: (NSInteger)count color: (UIColor *)color;

@end

NS_ASSUME_NONNULL_END
