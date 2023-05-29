//
//  PaddingLabel.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/5/18.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VEIMDemoPaddingLabel : UILabel

///  圆角 默认3.0
@property (nonatomic, assign) CGFloat cornerRadius;

/// 内边距 默认UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) CGFloat top_padding;
@property (nonatomic, assign) CGFloat left_padding;
@property (nonatomic, assign) CGFloat right_padding;
@property (nonatomic, assign) CGFloat bottom_padding;

@end
