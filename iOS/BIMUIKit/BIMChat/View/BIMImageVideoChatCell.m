//
//ChatImageCell.m
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMImageVideoChatCell.h"
#import "BIMToastView.h"
#import "BIMUIDefine.h"

//#import <BDWebImage/UIImageView+BDWebImage.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BIMImageVideoChatCell ()
@property (nonatomic, assign) BOOL isShowingLocalImage;

@property (nonatomic, strong) UIImageView *playBtn;
@end

@implementation BIMImageVideoChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.playBtn = [UIImageView new];
    [self.contentView addSubview:self.playBtn];
    [self.playBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_play")];
    self.playBtn.hidden = YES;
    
}

- (UIView *)bgLeft{
    return self.imageContent;
}

- (UIView *)bgRight{
    return self.imageContent;
}

- (UIView*)bgTop{
    return self.imageContent;
}

- (UIView*)bgBottom{
    return self.imageContent;
}

- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    self.imageContent.image = nil;
    self.playBtn.hidden = YES;
    
    if (message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
        BIMImageElement *file = (BIMImageElement *)message.element;
        if (self.message.msgStatus != BIM_MESSAGE_STATUS_SUCCESS && file.localPath.length > 0) {
            NSString *localStr = file.localPath;
            NSString *str = [localStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            NSString *str2 = [str stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            if ([[NSFileManager defaultManager] fileExistsAtPath:str2]) {
                UIImage *image = [UIImage imageWithContentsOfFile:str2];
                if (image) {
                    self.imageContent.image = image;
                }
            }
        }
        if (!self.imageContent.image) {
            NSString *imageURL;
            NSString *previewImageURL = file.largeImg.url;
            NSString *thumbImageURL = file.largeImg.url;
            if (thumbImageURL.length > 0 && ![thumbImageURL isEqualToString:@"(null)"]) {
                imageURL = previewImageURL;
            } else if (previewImageURL.length > 0 && ![previewImageURL isEqualToString:@"(null)"]) {
                imageURL = previewImageURL;
            } else if (file.originImg.url.length > 0 && ![file.originImg.url isEqualToString:@"(null)"]) {
                imageURL = file.originImg.url;
            }
//            [self.imageContent bd_setImageWithURL:[NSURL URLWithString:imageURL] placeholder:nil options:0 completion:^(BDWebImageRequest *request, UIImage *image, NSData *data, NSError *error, BDWebImageResultFrom from) {
//                if (error) {
//                    [[BIMClient sharedInstance] refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
//                        if (error) {
//                            [BIMToastView toast:[NSString stringWithFormat:@"加载图片失败：%@",error.localizedDescription]];
//                        }
//                    }];
//                }
//            }];
            [self.imageContent sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    [[BIMClient sharedInstance] refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
                        if (error) {
                            [BIMToastView toast:[NSString stringWithFormat:@"加载图片失败：%@",error.localizedDescription]];
                        }
                    }];
                }
            }];
        }
    }else if(message.msgType == BIM_MESSAGE_TYPE_VIDEO){
        BIMVideoElement *file = (BIMVideoElement *)message.element;
        self.playBtn.hidden = NO;
        
        if (self.localFilePath.length) {
            UIImage *img = [self thumbnailImageForVideo:[NSURL fileURLWithPath:self.localFilePath] atTime:1];
            self.imageContent.image = img;
        } else {
//            [self.imageContent bd_setImageWithURL:[NSURL URLWithString:file.coverImg.url] placeholder:nil options:0 completion:^(BDWebImageRequest *request, UIImage *image, NSData *data, NSError *error, BDWebImageResultFrom from) {
//                if (error) {
//                    [BIMToastView toast:error.localizedDescription];
//                }
//            }];
            
            [self.imageContent sd_setImageWithURL:[NSURL URLWithString:file.coverImg.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    [BIMToastView toast:error.localizedDescription];
                }
            }];
        }
    }
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
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


//- (CGFloat)heightForMessage:(TIMOMessage *)message inConversation:(TIMOConversation *)conversation sender:(id<TIMOConversationParticipant>)sender{
//    [self refreshWithMessage:message inConversation:conversation sender:sender];
//    
//    return CGRectGetMaxY(self.imageContent.frame) + 16;
//}

- (void)setupConstraints{
    [super setupConstraints];
    
    if (self.message.msgType == BIM_MESSAGE_TYPE_IMAGE || self.message.msgType == BIM_MESSAGE_TYPE_VIDEO) {
        CGFloat width = 0;
        CGFloat height = 0;
        
        if (self.message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
            BIMImageElement *file = (BIMImageElement *)self.message.element;
            width = file.thumbImg.width;
            height = file.thumbImg.height;
            if (width > 0 && height > 0) {
                
            } else if (file.largeImg.width > 0 && file.largeImg.height > 0) {
                width = file.largeImg.width;
                height = file.largeImg.height;
            }
        } else {
            BIMVideoElement *file = (BIMVideoElement *)self.message.element;
            width = file.coverImg.width;
            height = file.coverImg.height;
            if (!width || !height) {
                width = self.imageContent.image.size.width;
                height = self.imageContent.image.size.height;
            }
        }
        CGFloat maxWidth = 120;
        if (width > maxWidth) {
            height = height/width * maxWidth;
            width = maxWidth;
        }else if (width == 0 || height == 0){
            width = maxWidth;
            height = maxWidth;
        }
        CGFloat margin = [self margin];
        CGFloat playWH = 40;
        if (self.isSelfMsg) {
            [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.portrait.mas_left).offset(-margin*2);
                if (self.referMessageLabel.text.length) {
                    make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
                }else{
                    make.top.equalTo(self.portrait).offset(margin);
                }
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
        }else{
            [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.portrait.mas_right).offset(margin*2);
                if (self.referMessageLabel.text.length) {
                    make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
                }else{
                    make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
                }
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
        }

        [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageContent);
            make.width.height.mas_equalTo(playWH);
        }];
//        [self.imageBg mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.imageContent).offset(-margin);
//            make.top.equalTo(self.imageContent).offset(-margin);
//            make.right.equalTo(self.imageContent).offset(margin);
//            make.bottom.equalTo(self.imageContent).offset(margin);
//            make.bottom.mas_equalTo(-16);
//        }];
    }
    
}


@end