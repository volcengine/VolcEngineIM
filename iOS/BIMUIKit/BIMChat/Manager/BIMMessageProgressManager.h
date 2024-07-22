//
//  BIMMessageProgressManager.h
//  im-uikit-tob
//
//  Created Ding Jinyan on 2024/7/10.
//

#import <Foundation/Foundation.h>

@protocol BIMMessageProgressManagerDelegate <NSObject>

- (void)onUploadProgress:(NSString *)msgID progress:(int)progress;

@end

@interface BIMMessageProgressManager : NSObject

+ (instancetype)sharedInstance;

- (void)addDelegate:(id<BIMMessageProgressManagerDelegate>)delegate;
- (void)removeDelegate:(id<BIMMessageProgressManagerDelegate>)delegate;

- (void)updateProgress:(NSString *)msgID progress:(int)progress;
@end
