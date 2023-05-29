//
//  UIImage+IMUtils.h
//  ByteBusiness
//
//  Created by chenzhendong.ok@bytedance.com on 2021/6/14.
//  Copyright © 2021 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIImage (IMUtils)

+ (UIImage *)im_avatarWithUserId:(NSString *)identifier;

+ (UIImage *)im_avatarWithName:(NSString *)string identifier:(NSString *)identifier;

+ (UIImage *)im_creatImageWithString:(NSAttributedString *)string
                           imageSize:(CGSize)imageSize
                          imageColor:(UIColor *)imageColor;


+ (CGSize)im_imageSizeWithURL:(id)imageURL;


+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
