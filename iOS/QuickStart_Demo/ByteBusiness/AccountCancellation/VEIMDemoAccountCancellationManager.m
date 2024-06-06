//
//  VEIMDemoAccountCancellationManager.m
//  ByteBusiness
//
//  Created by Qin Fan on 2023/6/27.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoAccountCancellationManager.h"

#import <TTNetworkManager/TTNetworkManager.h>
#import <imsdk-tob/BIMClient.h>
#import <imsdk-tob/BIMClient+conversation.h>
#import <imsdk-tob/BIMClient+liveGroup.h>
#import <imsdk-tob/BIMConversation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <OneKit/BTDMacros.h>
#import <im-uikit-tob/BIMToastView.h>

static const NSInteger kTimeout = 60;

@interface VEIMDemoAccountCancellationManager ()

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) dispatch_semaphore_t sema;

@end

@implementation VEIMDemoAccountCancellationManager

+ (instancetype)sharedInstance
{
    static VEIMDemoAccountCancellationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[VEIMDemoAccountCancellationManager alloc] init];
        }
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.group = dispatch_group_create();
        _sema = dispatch_semaphore_create(5);
    }
    return self;
}

- (void)cancelAccountWithUid:(NSString *)uid token:(NSString *)token completion:(void(^)(BOOL success))completion
{
    BOOL result = NO;
    self.startTime = [[NSDate date] timeIntervalSince1970];
    [self quitAllConversationWithUid:uid cursor:0];
    [self clearAllDataWithUid:uid.longLongValue];
//    long timeout = dispatch_group_wait(self.group, dispatch_time(DISPATCH_TIME_NOW, 60 *NSEC_PER_SEC));
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        if ([[NSDate date] timeIntervalSince1970] - self.startTime <= 60) {
            [self cancelAccountRequestWithUid:uid token:token completion:completion];
        } else {
            completion(result);
        }
    });
}

// 注销请求
- (void)cancelAccountRequestWithUid:(NSString *)uid token:(NSString *)token completion:(void(^)(BOOL success))completion
{
    NSString *URL = @"https://imapi.volcvideo.com/imcloud/cancel_account";
    
    NSDictionary *params = @{
        @"token" : token,
        @"uid" : uid
    };
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    TTHttpTask *task = [[TTNetworkManager shareInstance] requestForJSONWithResponse:URL params:nil method:@"POST" needCommonParams:YES callback:^(NSError *error, id obj, TTHttpResponse *response) {
        if (completion) {
            completion(error ? NO : YES);
        }
    }];
    task.request.HTTPBody = httpBody;
    task.request.allHTTPHeaderFields = @{
        @"Content-Type" : @"application/json",
        @"Accept" : @"application/json",
    };
}

// 退出所有群聊
- (void)quitAllConversationWithUid:(NSString *)uid cursor:(uint64_t)cursor
{
    dispatch_group_enter(self.group);
    [[BIMClient sharedInstance] getConversationList:cursor count:100 completion:^(NSArray<BIMConversation *> * _Nullable conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 超时
            if ([[NSDate date] timeIntervalSince1970] - self.startTime > kTimeout) {
                dispatch_group_leave(self.group);
                return;
            }
            // 失败重试
            if (error) {
                [self quitAllConversationWithUid:uid cursor:cursor];
                dispatch_group_leave(self.group);
                return;
            }
            
            // 遍历会话，退出
            for (BIMConversation *conv in conversations) {
                @autoreleasepool {
                    [self quitConversation:conv withUid:uid];
                }
            }
            
            // hasMore拉取
            if (hasMore) {
                [self quitAllConversationWithUid:uid cursor:nextCursor];
            }
            
            dispatch_group_leave(self.group);
        });
    }];
}

// 退出聊天
- (void)quitConversation:(BIMConversation *)conv withUid:(NSString *)uid
{
    // 超时直接返回
    if ([[NSDate date] timeIntervalSince1970] - self.startTime > kTimeout) {
        return;
    }
//    dispatch_group_enter(self.group);
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    // 单聊
    if (conv.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        NSDictionary *dic = @{
            @"a:user_delete" : uid
        };
        NSString *convId = conv.conversationID;
        
        @weakify(self);
        [self setConversationCoreInfoWithExt:dic conversationId:convId completion:^(id extraInfo, NSError *error) {
            @strongify(self);
            dispatch_semaphore_signal(self.sema);
            if (error) {
                [self quitConversation:conv withUid:uid];
            }
//               dispatch_group_leave(self.group);
        }];
        
    } else if (conv.conversationType == 2) {  // 群聊
        @weakify(self);
        [[BIMClient sharedInstance] leaveGroup:conv.conversationID completion:^(BIMError * _Nullable error) {
            @strongify(self);
            dispatch_semaphore_signal(self.sema);
            if (error) {
                [self quitConversation:conv withUid:uid];
            }
//            dispatch_group_leave(self.group);
        }];
    }
}

// setConversationCoreInfor
- (void)setConversationCoreInfoWithExt:(NSDictionary *)dic conversationId:(NSString *)conversationId completion:(void(^)(id extraInfo, NSError *error)) completion
{
    Class cls = NSClassFromString(@"TIMConversationManager");
    NSObject *obj = [cls performSelector:@selector(sharedInstance)];
    SEL sel = NSSelectorFromString(@"updateConversationCoreInfoEntries:ext:onConversation:completion:");
    NSMethodSignature *signature = [[cls class] instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    NSDictionary *entries = [@{} mutableCopy];
    [invocation setArgument:&entries atIndex:2];
    [invocation setArgument:&dic atIndex:3];
    [invocation setArgument:&conversationId atIndex:4];
    [invocation setArgument:&completion atIndex:5];
    invocation.selector = sel;
    invocation.target = obj;
    [invocation invoke];
}

// 退出所有自己的直播群
//- (void)quitAllLiveGroup
//{
//    [[BIMClient sharedInstance] getOwnerLiveGroupList:0 count:10000 completion:^(NSArray<BIMConversation *> * _Nullable conversations, BOOL hasMore, long long nextCursor, BIMError * _Nullable error) {
//        // 遍历解散
//        for (BIMConversation *conv in conversations) {
//            [[BIMClient sharedInstance] dissolveLiveGroup:conv.conversationID completion:^(BIMError * _Nullable error) {
//                if (error) {
//                    // 解散失败
//
//                }
//                NSLog(@"qfdebug 解散直播群：%@", error ? @"成功" : @"失败");
//            }];
//        }
//    }];
//
//}

// 清除缓存
- (void)clearAllDataWithUid:(long long)uid
{
    Class cls = NSClassFromString(@"TIMOClient");
    if (cls && [cls respondsToSelector:@selector(sharedInstance)]) {
        
    }
    SEL sel = NSSelectorFromString(@"removeAllDataWithUserID:");
    NSMethodSignature *signature = [[cls class] instanceMethodSignatureForSelector:sel];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setArgument:&uid atIndex:2];
    invocation.selector = sel;
    invocation.target = [cls performSelector:@selector(sharedInstance)];
    [invocation invoke];
}



@end
