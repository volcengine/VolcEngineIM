//
//  BIMLableTextField.h
//  Bolts
//
//  Created by yangzhanjiang on 2024/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIMLableTextField : UIView
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UITextField *textField;
@end

NS_ASSUME_NONNULL_END
