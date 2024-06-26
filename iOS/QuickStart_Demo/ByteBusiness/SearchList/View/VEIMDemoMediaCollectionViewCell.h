//
//  VEIMDemoMediaCollectionViewCell.h
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/22.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMMessage;

@interface VEIMDemoMediaCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *playBtn;

@property (nonatomic, strong) UIImageView *imageContent;

@property (nonatomic, strong) BIMMessage *message;

@end

NS_ASSUME_NONNULL_END
