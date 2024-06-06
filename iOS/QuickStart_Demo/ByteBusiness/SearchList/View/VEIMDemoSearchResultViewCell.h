//
//  VEIMDemoSearchResultViewCell.h
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/27.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <im-uikit-tob/BIMPortraitBaseCell.h>
#import <imsdk-tob/BIMMessage.h>
@interface VEIMDemoSearchResultViewCell : BIMPortraitBaseCell

@property (nonatomic, assign) BIMMessageType msgType;
@property (nonatomic, strong) UILabel *dateLabel;

@end
