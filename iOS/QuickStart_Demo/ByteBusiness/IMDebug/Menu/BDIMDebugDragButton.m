//
//  BDIMDebugButton.m
//  ByteBusiness
//
//  Created by Weibai on 2022/9/30.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugDragButton.h"
#import "BDIMDebugFPSLabel.h"

@interface BDIMDebugDragButton ()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) BDIMDebugFPSLabel *fpsLabel;

@end

@implementation BDIMDebugDragButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.pan];
//        self.backgroundColor = [UIColor grayColor];
        self.fpsLabel = [[BDIMDebugFPSLabel alloc] init];
        self.fpsLabel.userInteractionEnabled = NO;
        [self addSubview:self.fpsLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.fpsLabel.frame = self.bounds;
}

- (void)pan: (UIPanGestureRecognizer *)ges{
    static CGPoint st;
//    CGRect stF;
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:{
            st = [ges locationInView:ges.view];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint pt = [ges locationInView:ges.view];
            self.alpha = 0.3;
            self.frame = CGRectMake(self.frame.origin.x + (pt.x - st.x), self.frame.origin.y + (pt.y - st.y), self.frame.size.width, self.frame.size.height);
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //判断向左还是向右
            CGFloat y = self.frame.origin.y;
            if (y > [UIApplication sharedApplication].keyWindow.bounds.size.height - self.bounds.size.height - 48) {
                y = [UIApplication sharedApplication].keyWindow.bounds.size.height - self.bounds.size.height - 48;
            }else if (y < self.bounds.size.height + 48){
                y = self.bounds.size.height + 48;
            }
            if (self.frame.origin.x < [UIApplication sharedApplication].keyWindow.bounds.size.width * 0.5) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.alpha = 1.0;
                    self.frame = CGRectMake(8, y, self.bounds.size.width, self.bounds.size.height);
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.alpha = 1.0;
                    self.frame = CGRectMake([UIApplication sharedApplication].keyWindow.bounds.size.width - 8 - self.bounds.size.width, y, self.bounds.size.width, self.bounds.size.height);
                }];
            }
            break;
        }
        default:
            break;
    }
}

@end
