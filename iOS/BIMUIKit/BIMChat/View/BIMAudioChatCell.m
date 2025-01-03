//
//AudioChatCell.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/14.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMAudioChatCell.h"
#import "BIMToastView.h"
#import "BIMUIDefine.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>
#import <OneKit/BTDMacros.h>

static const CGFloat kRedDotWH = 6;
static NSString *const kHasPlay = @"hasPlay";

@interface BIMAudioChatCell ()

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) BIMAudioElement *file;

@property (nonatomic, strong) UIView *redDotView;

@end

@implementation BIMAudioChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.durationLabel = [UILabel new];
    self.durationLabel.font = kFont(14);
    [self.contentView addSubview:self.durationLabel];
    
    self.redDotView = [UIView new];
    self.redDotView.backgroundColor = [UIColor redColor];
    self.redDotView.clipsToBounds = YES;
    self.redDotView.layer.cornerRadius = kRedDotWH * 0.5;
    [self addSubview:self.redDotView];
    
    
    self.player = [[AVPlayer alloc] init];
}

- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
        [self stopAnimation];
        [self.player pause];
    }
}

- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    self.file = (BIMAudioElement *)message.element;
    
    if ([self.imageContent isAnimating]) {
        [self.imageContent stopAnimating];
    }

    if (self.isSelfMsg) {
        self.imageContent.image = kIMAGE_IN_BUNDLE_NAMED(@"icon_selfVoice");
        self.durationLabel.textColor = [UIColor whiteColor];
        self.redDotView.hidden = YES;
    } else {
        self.imageContent.image = kIMAGE_IN_BUNDLE_NAMED(@"icon_otherVoice");
        self.durationLabel.textColor = [UIColor blackColor];
        self.redDotView.hidden = self.converstaion.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP || [message.localExt[kHasPlay] boolValue];
    }

    if (message.msgType == BIM_MESSAGE_TYPE_AUDIO) {
        BIMAudioElement *file = self.file;
        
        int duration = file.duration;
        if (file.duration == 0) {
            NSURL *fileURL;
            if (file.localPath.length) {
                fileURL = [NSURL fileURLWithPath:file.localPath];
            } else if (file.downloadPath) {
                fileURL = [NSURL URLWithString:file.downloadPath];
            } else {
                fileURL = [NSURL URLWithString:file.url];
            }
            
            if (fileURL) {
                AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
                duration = (int)CMTimeGetSeconds(audioAsset.duration);
            }
        }
        self.durationLabel.text = [NSString stringWithFormat:@"%.d", duration];
    }
    [self setupConstraints];
}

- (UIView *)bgLeft{
    if (self.isSelfMsg) {
        return nil;
    }else{
        return [super bgLeft];
    }
}

- (UIView *)bgRight{
    if (!self.isSelfMsg) {
        return nil;
    }else{
        return [super bgRight];
    }
}

- (UIView*)bgTop{
    return self.imageContent;
}

- (UIView*)bgBottom{
    return self.imageContent;
}

- (CGFloat)bgWidth{
    CGFloat minAudioW = 60;
    CGFloat maxAudioW = 150;
    CGFloat audioW = minAudioW;
    if (self.file) {
        float audioDurationSeconds = [self.durationLabel.text floatValue];

        if (audioDurationSeconds <= 2.0) {
            audioW = minAudioW;
        }else{
            audioW = (audioDurationSeconds - 2.0) / 15.0 * 100 + minAudioW;
            if (audioW > maxAudioW) {
                audioW = maxAudioW;
            }
        }
    }
    return audioW;
}

- (void)setupConstraints{
    [super setupConstraints];
    
    CGFloat margin = 16;

    
    if (self.isSelfMsg) {
        [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.portrait.mas_left).offset(-margin);
            make.centerY.equalTo(self.portrait);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageContent);
            make.right.equalTo(self.imageContent.mas_left).offset(-4);
        }];
        
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.right.equalTo(self.chatBg.mas_left).offset(-8);
            make.centerY.mas_equalTo(self.chatBg);
        }];
        
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
            make.centerY.mas_equalTo(self.progressView);
            make.centerX.mas_equalTo(self.progressView);
        }];
    } else {
        [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel).offset(margin);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
            make.width.height.mas_equalTo(20);
        }];
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageContent);
            make.left.equalTo(self.imageContent.mas_right).offset(4);
        }];

        [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.chatBg.mas_right).offset(5);
            make.centerY.equalTo(self.chatBg);
            make.width.height.mas_equalTo(kRedDotWH);
        }];
    }
}

- (void)bgDidClicked: (id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        AVPlayerItem *item;
        NSURL *fileURL;
        BIMAudioElement *element = BTD_DYNAMIC_CAST(BIMAudioElement, self.message.element);
        if ([[NSFileManager defaultManager] fileExistsAtPath:element.downloadPath]) {
            item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:element.downloadPath]];
            [self playItem:item];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        } else {
            if (self.converstaion.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
                [[BIMClient sharedInstance] downloadFile:self.message remoteURL:element.url progressBlock:nil completion:^(BIMError * _Nullable error) {
                    if (error) {
                        if (error.code != BIM_DOWNLOAD_FILE_DUPLICATE) {
                            [BIMToastView toast:@"下载失败，请重试"];
                        }
                    } else {
                        [BIMToastView toast:@"下载成功"];
                    }
                }];
            }
            
            // 下载不能影响在线播放
            if (self.localFilePath) {
                fileURL = [NSURL fileURLWithPath:self.localFilePath];
            } else {
                fileURL = [NSURL URLWithString:self.file.url];
            }
            
            if (fileURL) {
                item = [AVPlayerItem playerItemWithURL:fileURL];
                if (item != nil) {
                    if (self.file.isExpired) {
                        kWeakSelf(self);
                        [self refreshMediaMessage:self.message completion:^(BIMError * _Nullable error) {
                            kStrongSelf(self);
                            if (error) {
                                [BIMToastView toast:[NSString stringWithFormat:@"无法播放，URL错误:%@",self.file.url]];
                            } else {
                                [self playItem:item];
                            }
                        }];
                    } else {
                        [self playItem:item];
                    }
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
                }
            } else {
                [BIMToastView toast:[NSString stringWithFormat:@"无法播放，URL错误:%@",self.file.url]];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(cell:didClickImageContent:)]) {
            [self.delegate cell:self didClickImageContent:self.message];
        }
    });
}

- (void)playItem:(AVPlayerItem *)item
{
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
    [self startAnimation];
    
   
    if (self.converstaion.conversationType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] sendMessageReadReceipts:@[self.message] completion:^(BIMError * _Nullable error) {}];
        [[BIMClient sharedInstance] setMessageLocalExt:self.message localExt:@{kHasPlay: @"1"} completion:^(BIMError * _Nullable error) {}];
    }
    
}

- (void)refreshMediaMessage:(BIMMessage *)message completion:(BIMCompletion)completion
{
    if (self.converstaion.conversationType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] refreshLiveGroupMediaMessage:message completion:completion];
    } else {
        [[BIMClient sharedInstance] refreshMediaMessage:message completion:completion];
    }
}

- (void)startAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.imageContent.animating) {
            [self.imageContent stopAnimating];
        }

        if (self.isSelfMsg) {
            self.imageContent.animationImages = @[
                kIMAGE_IN_BUNDLE_NAMED(@"icon_self_audio_animation_1.png"),
                kIMAGE_IN_BUNDLE_NAMED(@"icon_self_audio_animation_2.png"),
                kIMAGE_IN_BUNDLE_NAMED(@"icon_self_audio_animation_3.png")
            ];
        } else {
            self.imageContent.animationImages = @[
                kIMAGE_IN_BUNDLE_NAMED(@"icon_other_audio_animation_1.png"),
                kIMAGE_IN_BUNDLE_NAMED(@"icon_other_audio_animation_2.png"),
                kIMAGE_IN_BUNDLE_NAMED(@"icon_other_audio_animation_3.png")
            ];
        }
        self.imageContent.animationDuration = 1.5;
        [self.imageContent startAnimating];
    });
}

- (void)stopAnimation{
    [self.imageContent stopAnimating];
}

@end
