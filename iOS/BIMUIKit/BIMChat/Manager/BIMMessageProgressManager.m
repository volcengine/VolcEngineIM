//
//  BIMMessageProgressManager.m
//  im-uikit-tob
//
//  Created by ByteDance on 2024/7/10.
//

#import "BIMMessageProgressManager.h"

@interface BIMMessageProgressManager ()

@property (nonatomic, strong) NSHashTable<id<BIMMessageProgressManagerDelegate>> *delegates;
@property (nonatomic, strong) dispatch_semaphore_t delegateLock;

@end

@implementation BIMMessageProgressManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegateLock = dispatch_semaphore_create(1);
        self.delegates = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    return self;
}

- (void)addDelegate:(id<BIMMessageProgressManagerDelegate>)delegate
{
    if (!delegate) {
        return;
    }
    
    dispatch_semaphore_wait(self.delegateLock, DISPATCH_TIME_FOREVER);
    [self.delegates addObject:delegate];
    dispatch_semaphore_signal(self.delegateLock);
}

- (void)removeDelegate:(id<BIMMessageProgressManagerDelegate>)delegate
{
    if (!delegate) {
        return;
    }
    
    dispatch_semaphore_wait(self.delegateLock, DISPATCH_TIME_FOREVER);
    [self.delegates removeObject:delegate];
    dispatch_semaphore_signal(self.delegateLock);
}

- (void)updateProgress:(NSString *)msgID progress:(int)progress
{
    if (!msgID) {
        return;
    }
    
    dispatch_semaphore_wait(self.delegateLock, DISPATCH_TIME_FOREVER);
    NSArray *allDelegates = self.delegates.allObjects;
    dispatch_semaphore_signal(self.delegateLock);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<BIMMessageProgressManagerDelegate> delegate in allDelegates) {
            if ([delegate respondsToSelector:@selector(onUploadProgress:progress:)]) {
                [delegate onUploadProgress:msgID progress:progress];
            }
        }
    });
}

@end
