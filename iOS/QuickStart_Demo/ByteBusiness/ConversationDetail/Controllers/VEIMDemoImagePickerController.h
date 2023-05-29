//
//  VEIMDemoImagePickerController.h
//  ByteBusiness
//
//  Created by zhanjiang on 2022/9/16.
//  Copyright © 2022 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VEIMDemoImagePickerController;

@protocol VEIMDemoImagePickerControllerDelegate <NSObject>

@optional

- (void)coverPickerController:(VEIMDemoImagePickerController *)picker didFinishPickingVideoUrl:(NSURL *)videoUrl cover:(UIImage *)image;
- (void)coverPickerControllerDidCancel:(VEIMDemoImagePickerController *)picker;

@end

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoImagePickerController : UIViewController
@property (nonatomic, assign) id<VEIMDemoImagePickerControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
