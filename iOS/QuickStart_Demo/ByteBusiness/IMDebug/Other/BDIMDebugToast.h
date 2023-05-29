//
//  BDIMDebugToast.h
//  DJCUMoZiModule-DJCUMoZiModule
//
//  Created by Weibai Lu on 2020/3/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDIMDebugToast : NSObject

+ (void)showToast:(id)obj;
+ (void)showToast:(id)obj view:(UIView *) view duration:(NSTimeInterval) duration;

@end

NS_ASSUME_NONNULL_END
