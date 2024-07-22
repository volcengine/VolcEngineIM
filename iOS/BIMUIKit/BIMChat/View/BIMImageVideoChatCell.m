//
//ChatImageCell.m
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMImageVideoChatCell.h"
#import "BIMToastView.h"
#import "BIMUIDefine.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageError.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <OneKit/BTDMacros.h>

#import "UIImage+IMUtils.h"

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
    
    if (conversation.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [self refreshWithLiveGroupMessage:message];
    } else {
        [self refreshWithNormalConvMessage:message];
    }
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
        } else if (width == 0 || height == 0){
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
            
            CGFloat progressViewWidth = width / 2.0f;
            CGFloat progressViewHeight = height / 4.0f;
            if (progressViewHeight < 40) {
                progressViewHeight = height < 40 ? height / 2.0f : height - 20;
            }
            CGFloat progressViewWidthHeight = MIN(progressViewHeight, progressViewWidth);
            
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(progressViewWidthHeight);
                make.centerX.mas_equalTo(self.imageContent);
                make.centerY.mas_equalTo(self.imageContent);
            }];
            
            [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.imageContent);
                make.width.height.equalTo(self.progressView);
            }];
            
        } else {
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

- (void)refreshWithNormalConvMessage:(BIMMessage *)message
{
    if (self.imageContent.image) {
        return;
    }
    
    if (message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
        BIMImageElement *element = BTD_DYNAMIC_CAST(BIMImageElement, message.element);
        if (element.localPath.length > 0) {
            NSString *localStr = element.localPath;
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
            NSString *downloadFilePath = element.thumbImg.downloadPath;
            if ([[NSFileManager defaultManager] fileExistsAtPath:downloadFilePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:downloadFilePath];
                if (image) {
                    self.imageContent.image = image;
                }
                if ([self.delegate respondsToSelector:@selector(cell:fileLoadFinish:error:)]) {
                    [self.delegate cell:self fileLoadFinish:message error:nil];
                }
            } else {
                [[BIMClient sharedInstance] downloadFile:message remoteURL:element.thumbImg.url progressBlock:nil completion:^(BIMError * _Nullable error) {
                    if (![self.message.uuid isEqualToString:message.uuid]) {
                        return;
                    }
                    
                    if (!error) {
                        BIMImageElement *newElement = BTD_DYNAMIC_CAST(BIMImageElement, message.element);
                        UIImage *image = [UIImage imageWithContentsOfFile:newElement.thumbImg.downloadPath];
                        self.imageContent.image = image;
                    }
                    
                    if ([self.delegate respondsToSelector:@selector(cell:fileLoadFinish:error:)]) {
                        [self.delegate cell:self fileLoadFinish:message error:error];
                    }
                }];
            };
        }
    } else if (message.msgType == BIM_MESSAGE_TYPE_VIDEO) {
        BIMVideoElement *element = BTD_DYNAMIC_CAST(BIMVideoElement, message.element);
        self.playBtn.hidden = message.msgStatus == BIM_MESSAGE_STATUS_SENDING_FILE_PARTS;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:element.coverImg.downloadPath]) {
            self.imageContent.image = [UIImage imageWithContentsOfFile:element.coverImg.downloadPath];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:element.downloadPath]) {
            self.imageContent.image = [UIImage thumbnailImageForVideo:[NSURL fileURLWithPath:element.downloadPath] atTime:1];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:element.localPath]) {
            self.imageContent.image = [UIImage thumbnailImageForVideo:[NSURL fileURLWithPath:element.localPath] atTime:1];
        } else if (element.coverImg.url) {
            [[BIMClient sharedInstance] downloadFile:message remoteURL:element.coverImg.url progressBlock:nil completion:^(BIMError * _Nullable error) {
                if (![self.message.uuid isEqualToString:message.uuid]) {
                    return;
                }
                
                if (!error) {
                    BIMVideoElement *newElement = BTD_DYNAMIC_CAST(BIMVideoElement, message.element);
                    self.imageContent.image = [UIImage imageWithContentsOfFile:newElement.coverImg.downloadPath];
                }
            }];
        }
    }
}

- (void)refreshWithLiveGroupMessage:(BIMMessage *)message
{
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
            
            [self.imageContent sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if ([self.delegate respondsToSelector:@selector(cell:fileLoadFinish:error:)]) {
                    [self.delegate cell:self fileLoadFinish:message error:error];
                }
            }];
        } else {
            [self.imageContent sd_cancelCurrentImageLoad];
        }
    } else if (message.msgType == BIM_MESSAGE_TYPE_VIDEO) {
        BIMVideoElement *file = (BIMVideoElement *)message.element;
        self.playBtn.hidden = message.msgStatus == BIM_MESSAGE_STATUS_SENDING_FILE_PARTS;
        
        if (self.localFilePath.length) {
            UIImage *img = [UIImage thumbnailImageForVideo:[NSURL fileURLWithPath:self.localFilePath] atTime:1];
            self.imageContent.image = img;
        } else {
            [self.imageContent sd_setImageWithURL:[NSURL URLWithString:file.coverImg.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error && error.code != SDWebImageErrorInvalidURL) {
                    [BIMToastView toast:error.localizedDescription];
                }
            }];
        }
    }
}

@end
