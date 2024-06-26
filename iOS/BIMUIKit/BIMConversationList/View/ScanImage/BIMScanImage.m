//
//  IM_ScanImage.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/14.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMScanImage.h"
#import "BIMUIDefine.h"
#import <imsdk-tob/BIMSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define kTag 2020


@implementation BIMScanImage

//原始尺寸
static CGRect oldframe;

+ (void)scanBigImageWithImage:(UIImage *)image imageUrl:(NSURL *)imageUrl frame:(CGRect)pOldframe secretKey:(NSString *)secretKey completion:(SDExternalCompletionBlock)completion
{
    oldframe = pOldframe;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (imageUrl) {
//        if (secretKey) {
//            [imageView bd_setImageWithURL:imageUrl
//                          alternativeURLs:nil
//                              placeholder:nil
//                                  options:BDImageRequestDefaultOptions
//                          timeoutInterval:0
//                                cacheName:nil
//                              transformer:nil
//                             decryptBlock:nil
//                                 progress:nil
//                               completion:nil];
//        } else {
//            [imageView bd_setImageWithURL:imageUrl placeholder:nil options:0 completion:completion];
//        }
        [imageView sd_setImageWithURL:imageUrl placeholderImage:nil options:0 completed:completion];
    } else {
        [imageView setImage:image];
    }
    [imageView setTag:kTag];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [kAppWindow addSubview:backgroundView];

    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];

    //动画放大所展示的ImageView
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = [UIScreen mainScreen].bounds;
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
//        if (imageUrl) {
//            [BIMToastView toast:imageUrl.absoluteString withDuration:3];
//        }
    }];
}

+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview message:(BIMMessage *)message image:(BIMImage *)image completion:(void (^)(BIMError *))completion
{
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:kAppWindow];;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (image.url) {
        BIMImageElement *element = (BIMImageElement *)message.element;
        NSString *fileType;
        if (image == element.thumbImg) {
            fileType = @"thumb";
        } else if (image == element.largeImg) {
            fileType = @"large";
        } else {
            fileType = @"origin";
        }
        
        [[BIMClient sharedInstance] downloadFile:message remoteURL:image.url progressBlock:nil completion:^(BIMError * _Nullable error) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
                
                if (error) {
                    return;
                }
            }
            
            BIMImageElement *newElement = (BIMImageElement *)message.element;
            UIImage *localImage;
            if ([fileType isEqualToString:@"thumb"]) {
                localImage = [UIImage imageWithContentsOfFile:newElement.thumbImg.downloadPath];
            } else if ([fileType isEqualToString:@"large"]) {
                localImage = [UIImage imageWithContentsOfFile:newElement.largeImg.downloadPath];
            } else if ([fileType isEqualToString:@"origin"]) {
                localImage = [UIImage imageWithContentsOfFile:newElement.originImg.downloadPath];
            }
            [imageView setImage:localImage];
        }];
    }
    [imageView setTag:kTag];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [kAppWindow addSubview:backgroundView];

    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];

    //动画放大所展示的ImageView
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = [UIScreen mainScreen].bounds;
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
//        if (imageUrl) {
//            [BIMToastView toast:imageUrl.absoluteString withDuration:3];
//        }
    }];
}

+ (void)scanBigImageRefreshWithImageUrl:(NSString *)imageUrl completion:(SDExternalCompletionBlock)completion
{
    if (imageUrl.length == 0) {
        completion(nil, nil, 0, nil);
        return;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scanBigImageRefreshWithImageUrl:imageUrl completion:completion];
        });
        return;
    }
    UIImageView *imageView = [kAppWindow viewWithTag:kTag];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 completed:completion];
}

+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview originImage:(id)originImage
{
    [self scanBigImageWithImageView:currentImageview originImage:originImage secretKey:nil completion:nil];
}

+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview originImage:(id)originImage secretKey:(NSString *)secretKey completion:(SDExternalCompletionBlock)completion
{
    CGRect frame = [currentImageview convertRect:currentImageview.bounds toView:kAppWindow];
    if ([originImage isKindOfClass:[UIImage class]]) {
        [self scanBigImageWithImage:originImage imageUrl:nil frame:frame secretKey:nil completion:completion];
    } else {
        [self scanBigImageWithImage:nil imageUrl:[NSURL URLWithString:originImage] frame:frame secretKey:secretKey completion:completion];
    }
}

/// 恢复imageView原始尺寸
+ (void)hideImageView:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:kTag];
    //恢复
    [UIView animateWithDuration:0.3 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

@end
