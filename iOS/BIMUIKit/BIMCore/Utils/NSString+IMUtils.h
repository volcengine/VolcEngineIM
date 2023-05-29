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
@end

NS_ASSUME_NONNULL_END
