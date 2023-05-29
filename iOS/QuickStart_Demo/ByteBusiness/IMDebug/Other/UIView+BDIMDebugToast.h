//
//  UIView+DJDebugToast.h
//
//  Created by Weibai Lu on 2020/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const CSToastPositionTop;
extern NSString * const CSToastPositionCenter;
extern NSString * const CSToastPositionBottom;

@interface UIView (BDIMDebugToast)

// each makeToast method creates a view and displays it as toast
- (void)bdim_makeToast:(NSString *)message;
- (void)bdim_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)bdim_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)bdim_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)bdim_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner
- (void)bdim_makeToastActivity;
- (void)bdim_makeToastActivity:(id)position;
- (void)bdim_hideToastActivity;

// the showToast methods display any view as toast
- (void)bdim_showToast:(UIView *)toast;
- (void)bdim_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)bdim_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point
      tapCallback:(void(^)(void))tapCallback;

+(BOOL)isViewVisible:(UIView*)view inScrollView:(UIScrollView*)scroll;
@end

NS_ASSUME_NONNULL_END
