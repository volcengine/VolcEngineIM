//
//  VEIMDemoSetInpuView.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/4/24.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol VEIMDemoSetInpuViewDelegate <NSObject>
//
//- (void)clickConfirmBtnWithInputText:(NSString *)input;
//
//@end

@interface VEIMDemoSetInpuViewController : UIViewController

//@property(nonatomic, weak) id<VEIMDemoSetInpuViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title confirmBlock:(void(^)(NSString * text))confirmBlock;

@end

NS_ASSUME_NONNULL_END
