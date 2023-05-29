//
//  BDIMDebugToast.m
//  DJCUMoZiModule-DJCUMoZiModule
//
//  Created by Weibai Lu on 2020/3/26.
//

#import "BDIMDebugToast.h"
#import "UIView+BDIMDebugToast.h"

#ifndef dispatch_main_sync_safe
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
}\
else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
#endif

@implementation BDIMDebugToast
+ (void)showDebugToast:(id)obj {
#if DEBUG
    [self showToast:obj];
#endif
}

+ (void)showToast:(id)obj view:(UIView *) view duration:(NSTimeInterval) duration
{
    dispatch_block_t block = ^{
        NSString *text = [NSString stringWithFormat:@"%@",obj];
        [[UIApplication sharedApplication].delegate.window bdim_makeToast:text duration:duration position:@"center"];
    };
    dispatch_main_sync_safe(block);
}

+ (void)showToast:(id)obj
{
    dispatch_block_t block = ^{
        NSString *text = [NSString stringWithFormat:@"%@",obj];
        [[UIApplication sharedApplication].delegate.window  bdim_makeToast:text duration:0.7 position:@"center"];
    };
    dispatch_main_sync_safe(block);
}


@end
