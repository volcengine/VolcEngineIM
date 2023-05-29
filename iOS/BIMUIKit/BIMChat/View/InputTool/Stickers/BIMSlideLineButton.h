//
//  TIMSlideLineButton.h
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/16.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BIMSlideLineButtonPosition) {
    BIMSlideLineButtonPositionNone,
    BIMSlideLineButtonPositionLeft,
    BIMSlideLineButtonPositionRight,
    BIMSlideLineButtonPositionBoth,
};


@interface BIMSlideLineButton : UIButton

@property (nonatomic, assign) BIMSlideLineButtonPosition linePosition;

@property (nonatomic, strong) UIColor *lineColor;

@end
