//
//AudioRecorder.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/21.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BIMAudioRecorderDelegate <NSObject>

/// 录音失败 时间太短的原因
- (void)failRecord;
- (void)successRecord;
/// 开始录音
- (void)beginConvert;

/// 结束录音 并返回录音转MP3所存储的地址 和 时间
- (void)audioRecorderDidFinishRecordingWithPath:(NSString *)path recordTime:(NSInteger)recordTime;

@end


@interface BIMAudioRecorder : NSObject

@property (nonatomic, weak) id <BIMAudioRecorderDelegate> delegate;

- (id)initWithDelegate:(id<BIMAudioRecorderDelegate>)delegate;

/// 开始录音
- (void)startRecord;

/// 停止录音
- (void)stopRecord;

/// 取消录音
- (void)cancelRecord;

/// 开始播放语音 传入一个地址
- (void)startPlayRecordWithPath:(NSString *)path;

/// 停止播放语音
- (void)stopPlayRecord;

/// 更新分贝
- (NSInteger)updateMeters;

@end
