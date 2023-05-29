//
//  TIMQueuingScrollView.h
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/16.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMReusablePage.h"

@class BIMQueuingScrollView;

@protocol BIMQueuingScrollViewDelegate <UIScrollViewDelegate>

@required

- (UIView<BIMReusablePage> *)queuingScrollView:(BIMQueuingScrollView *)queuingScrollView viewBeforeView:(UIView *)view;
- (UIView<BIMReusablePage> *)queuingScrollView:(BIMQueuingScrollView *)queuingScrollView viewAfterView:(UIView *)view;

@optional

- (void)queuingScrollViewChangedFocusView:(BIMQueuingScrollView *)queuingScrollView previousFocusView:(UIView *)previousFocusView;

@end


@interface BIMQueuingScrollView : UIScrollView

@property (nonatomic, weak) id<BIMQueuingScrollViewDelegate> delegate;

@property (nonatomic) CGFloat pagePadding;

@property (nonatomic, readonly) CGPoint targetContentOffset;

- (id)reusableViewWithIdentifer:(NSString *)identifier;

- (void)displayView:(UIView<BIMReusablePage> *)view;

@property (nonatomic, readonly) UIView *focusView;

- (NSArray *)allViews;

- (void)scrollToNextPageAnimated:(BOOL)animated;

- (void)scrollToPreviousPageAnimated:(BOOL)animated;

- (void)locateTargetContentOffset;

- (BOOL)contentOffsetIsValid;

- (CGRect)contentBounds;

@end
