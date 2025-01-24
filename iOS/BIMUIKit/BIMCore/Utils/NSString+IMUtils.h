//
//  NSString+IMUtils.h
//
//
//  Created by Weibai on 2022/11/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSString (IMUtils)

- (NSString *)im_substringToIndex:(NSUInteger)to;


- (CGSize)im_boundingRectWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;

/// 字符串是否为 nil、空字符串或仅由空格组成
+ (BOOL)im_isBlankString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
