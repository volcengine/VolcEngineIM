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

@interface BIMAudioChatCell ()

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) BIMAudioElement *file;

@end

@implementation BIMAudioChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    self.durationLabel = [UILabel new];
    self.durationLabel.font = kFont(14);
    [self.contentView addSubview:self.durationLabel];
    
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
//        self.imageBg.backgroundColor = kIM_Blue_Color;
        
        self.imageContent.image = kIMAGE_IN_BUNDLE_NAMED(@"icon_selfVoice");
        self.durationLabel.textColor = [UIColor whiteColor];
    } else {
//        self.imageBg.backgroundColor = [UIColor whiteColor];
        self.imageContent.image = kIMAGE_IN_BUNDLE_NAMED(@"icon_otherVoice");
        self.durationLabel.textColor = [UIColor blackColor];
    }

    if (message.msgType == BIM_MESSAGE_TYPE_AUDIO) {
        BIMAudioElement *file = self.file;
        
        int duration = file.duration;
        if (file.duration == 0) {
            NSURL *fileURL;
            if (self.file.localPath.length) {
                fileURL = [NSURL fileURLWithPath:file.localPath];
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
//        [self.imageBg mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.imageContent).offset(-margin*0.5);
//            make.bottom.equalTo(self.imageContent).offset(margin*0.5);
//            make.right.equalTo(self.imageContent).offset(margin*0.5);
//            make.bottom.mas_equalTo(-margin);
//        }];
    }else{
        [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel).offset(margin);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(margin);
            make.width.height.mas_equalTo(20);
        }];
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageContent);
            make.left.equalTo(self.imageContent.mas_right).offset(4);
        }];
//        [self.imageBg mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.imageContent.mas_left).offset(-margin*0.5);
//            make.top.equalTo(self.imageContent).offset(-margin*0.5);
//            make.bottom.equalTo(self.imageContent).offset(margin*0.5);
//            make.width.mas_equalTo(audioW);
//            make.bottom.mas_equalTo(-margin);
//        }];
    }
}

- (void)bgDidClicked: (id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        NSURL *fileURL;
        if (self.localFilePath) {
            fileURL = [NSURL fileURLWithPath:self.localFilePath];
        } else {
            fileURL = [NSURL URLWithString:self.file.url];
        }
        
        if (fileURL) {
            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:fileURL];
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
        }else{
            [BIMToastView toast:[NSString stringWithFormat:@"无法播放，URL错误:%@",self.file.url]];
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
    if (self.converstaion.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        [[BIMClient sharedInstance] sendMessageReadReceipts:@[self.message] completion:^(BIMError * _Nullable error) {}];
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
