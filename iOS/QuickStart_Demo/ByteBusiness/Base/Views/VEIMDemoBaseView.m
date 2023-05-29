//
//  VEIMDemoBaseView.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import "VEIMDemoBaseView.h"

@implementation VEIMDemoBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIElemets];
        
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUIElemets];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupUIElemets{
    
    
    
}

- (void)setupConstraints{
    
}

@end
