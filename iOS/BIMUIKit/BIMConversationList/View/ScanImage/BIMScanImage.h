//
//  IM_ScanImage.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/14.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>


@interface BIMScanImage : NSObject

/// 浏览大图
/// @param currentImageview 当前的imageView
/// @param originImage 1.UIImage类型、2.图片的url字符串
+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview originImage:(id)originImage;

+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview originImage:(id)originImage secretKey:(NSString *)secretKey completion:(SDExternalCompletionBlock)completion;


/// 刷新URL
/// @param imageUrl 请求的URL
/// @param completion 回调
+ (void)scanBigImageRefreshWithImageUrl:(NSString *)imageUrl completion:(SDExternalCompletionBlock)completion;

@end
