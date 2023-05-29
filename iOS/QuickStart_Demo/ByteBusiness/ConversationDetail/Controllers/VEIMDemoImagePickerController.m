//
//  VEIMDemoImageViewController.m
//  ByteBusiness
//
//  Created by zhanjiang on 2022/9/16.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoImagePickerController.h"

#import <OneKit/ByteDanceKit.h>

#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MobileCoreServices/MobileCoreServices.h>

static const CGFloat kHMargin = 60;
static const CGFloat kVMargin = 200;
static const CGFloat kCoverW = 100;
static const CGFloat kCoverH = 124;

@interface VEIMDemoImageButton : UIButton
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGRect titleRect;
@end

@implementation VEIMDemoImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat totalW = self.bounds.size.width;
    CGFloat totalH = self.bounds.size.height;
    
    CGFloat tilteW = totalW;
    CGFloat titleH = self.titleLabel.bounds.size.height;
    
    CGFloat imageH = totalH - titleH - 10;
    CGFloat imageW = totalW;
    
    self.imageView.frame = CGRectMake(0, 0, imageW, imageH);
    self.titleLabel.frame = CGRectMake(0, totalH - titleH, tilteW, titleH);
    self.imageView.hidden = NO;
}

@end

@interface VEIMDemoImagePickerController ()
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, copy) NSURL *videoURL;
@end

@implementation VEIMDemoImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.videoButton];
    [self.view addSubview:self.coverButton];
    [self.view addSubview:self.finishButton];
    [self.view addSubview:self.cancelButton];
}

#pragma mark - event

- (void)imageClick:(UIButton *)btn
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    picker.allowsEditing = NO;
    picker.edgesForExtendedLayout = UIRectEdgeNone;

    if (btn == self.videoButton) {
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    } else if (btn == self.coverButton) {
        picker.mediaTypes = @[(NSString *)kUTTypeImage];
    }

    [[BTDResponder topViewController] presentViewController:picker animated:YES completion:nil];
}

- (void)finishClick {
    if ([self.delegate respondsToSelector:@selector(coverPickerController:didFinishPickingVideoUrl:cover:)]) {
        [self.delegate coverPickerController:self didFinishPickingVideoUrl:self.videoURL cover:self.coverImage];
    }
}

- (void)cancelClick {
    if ([self.delegate respondsToSelector:@selector(coverPickerControllerDidCancel:)]) {
        [self.delegate coverPickerControllerDidCancel:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        self.videoURL = url;
        [self.videoButton setImage:[self getScreenShotImageFromVideoPath:url.absoluteString] forState:UIControlStateNormal];
        self.finishButton.enabled = YES;
    } else {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.coverImage = image;
        [self.coverButton setImage:image forState:UIControlStateNormal];
    }
}

- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{

    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];

    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    gen.appliesPreferredTrackTransform = YES;

    CMTime time = CMTimeMakeWithSeconds(0.0, 600);

    NSError *error = nil;

    CMTime actualTime;

    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];

    shotImage = [[UIImage alloc] initWithCGImage:image];

    CGImageRelease(image);

    return shotImage;

}

#pragma mark - getter

- (UIButton *)videoButton {
    if (!_videoButton) {
        _videoButton = [[VEIMDemoImageButton alloc] initWithFrame:CGRectMake(kHMargin, kVMargin, kCoverW, kCoverH)];
        [_videoButton setTitle:@"选择视频" forState:UIControlStateNormal];
        [_videoButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_videoButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoButton;
}

- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[VEIMDemoImageButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - kHMargin - kCoverW, kVMargin, kCoverW, kCoverH)];
        [_coverButton setTitle:@"选择封面" forState:UIControlStateNormal];
        [_coverButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_coverButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.enabled = NO;
        CGFloat width = 50;
        CGFloat y = CGRectGetMaxY(self.videoButton.frame) + 60;
        CGFloat x = (self.view.bounds.size.width - width) * 0.5;
        _finishButton.frame = CGRectMake(x, y, width, 40);
    }
    return _finishButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10, 10, 44, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
