//
//  UIImage+IMUtils.m
//  ByteBusiness
//
//  Created by chenzhendong.ok@bytedance.com on 2021/6/14.
//  Copyright © 2021 loulan. All rights reserved.
//

#import "UIImage+IMUtils.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <OneKit/UIColor+BTDAdditions.h>


@implementation UIImage (IMUtils)

+ (UIImage *)im_avatarWithUserId:(NSString *)identifier
{
    while (identifier.length < 2)
        identifier = [identifier stringByAppendingString:identifier];
    return [self im_avatarWithName:[identifier substringToIndex:2] identifier:identifier];
}

+ (UIImage *)im_avatarWithName:(NSString *)string identifier:(NSString *)identifier
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{
        NSForegroundColorAttributeName : UIColor.whiteColor,
        NSFontAttributeName : [UIFont boldSystemFontOfSize:(512 / (MAX(string.length, 2)))]
    }];
    if (!identifier.length) {
        identifier = @"000000";
    }
    while (identifier.length > 0 && identifier.length < 6)
        identifier = [identifier stringByAppendingString:identifier];
    identifier = [identifier substringToIndex:6];
    UIColor *color = [UIColor btd_colorWithHexString:[NSString stringWithFormat:@"#%@", identifier]];
    CGFloat hue, saturation, brightness, alpha;
    BOOL ok = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (ok) {
        color = [UIColor colorWithHue:hue saturation:saturation brightness:0.8 alpha:alpha];
    }
    return [self im_creatImageWithString:attributedString imageSize:CGSizeMake(512, 512) imageColor:color];
}

+ (UIImage *)im_creatImageWithString:(NSAttributedString *)string
                           imageSize:(CGSize)imageSize
                          imageColor:(UIColor *)imageColor
{
    //通过自己创建一个context来绘制，通常用于对图片的处理
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充颜色
    CGContextSetFillColorWithColor(context, imageColor.CGColor);
    //直接按rect的范围覆盖
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    CGContextFillPath(context);

    CGSize stringSize = [string size];
    CGFloat x = (imageSize.width - stringSize.width) / 2.0;
    CGFloat y = (imageSize.height - stringSize.height) / 2.0;

    [string drawInRect:CGRectMake(x, y, stringSize.width, stringSize.height)];

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (CGSize)im_imageSizeWithURL:(id)imageURL{
    NSURL *URL = nil;

    if ([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    }

    if ([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }

    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];

    return CGSizeMake(image.size.width, image.size.height);
}

/**
 根据url获取第一帧图片,获取任一帧图片
 
 @param videoURL 图片url
 @param time 第几帧
 @return 图片
 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];

    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);

    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;

    return thumbnailImage;
}

@end
