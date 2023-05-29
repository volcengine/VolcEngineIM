//
//AudioRecorder.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/21.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

#define RECORDPLAYBEGIN @"recordPlayBegin"   //录音开始播放
#define RECORDPLAYFINISH @"recordPlayFinish" //录音播放完毕


@interface BIMAudioRecorder () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSInteger currentTime;
@end


@implementation BIMAudioRecorder

- (id)initWithDelegate:(id<BIMAudioRecorderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)setRecorder
{
    _recorder = nil;
    NSError *recorderSetupError = nil;
    NSURL *url = [NSURL fileURLWithPath:[[self voicePath] stringByAppendingPathComponent:[self randomFileName]]];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //采样率
    [settings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey]; //44100.0
    //通道数
    [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                            settings:settings
                                               error:&recorderSetupError];
    if (recorderSetupError) {
//        NSLog(@"%@", recorderSetupError);
    }
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}

- (void)setSesstion
{
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    if (_session != nil){
        [_session setActive:YES error:nil];
    }
}

- (void)startRecord
{
    self.currentTime = 0;
    [self setSesstion];
    [self setRecorder];
    [_recorder record];
}

- (NSInteger)updateMeters
{
    [_recorder updateMeters];                           //更新测量值
    float power = [_recorder averagePowerForChannel:0]; //取得第一个通道的音频，注意音频强度范围时-160到0
    NSInteger progress = power + 160;
    return progress;
}

- (void)stopRecord
{
    double cTime = _recorder.currentTime;
    self.currentTime = cTime;
    [_recorder stop];

    if (cTime > 1) {
        if ([_delegate respondsToSelector:@selector(successRecord)]) {
            [_delegate successRecord];
        }
    } else {
        [_recorder deleteRecording];

        if ([_delegate respondsToSelector:@selector(failRecord)]) {
            [_delegate failRecord];
        }
    }
}

- (void)cancelRecord
{
    [_recorder stop];
    [_recorder deleteRecording];
}

- (void)startPlayRecordWithPath:(NSString *)path
{
    // 正在播放就返回
    [self stopPlayRecord];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:NULL];
    self.audioPlayer.delegate = self;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.audioPlayer play];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RECORDPLAYBEGIN object:nil];
}

- (void)stopPlayRecord
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        [[NSNotificationCenter defaultCenter] postNotificationName:RECORDPLAYFINISH object:nil];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECORDPLAYFINISH object:nil];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (![[NSFileManager defaultManager] fileExistsAtPath:recorder.url.path]) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderDidFinishRecordingWithPath:recordTime:)]) {
        [_delegate audioRecorderDidFinishRecordingWithPath:recorder.url.path recordTime:self.currentTime];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

#pragma mark - Path Utils

- (NSString *)voicePath
{
    NSString *voicePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"voiceCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return voicePath;
}

- (NSString *)randomFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"record_%.0f.m4a", timeInterval];
    return fileName;
}

@end
