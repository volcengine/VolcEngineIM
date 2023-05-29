//
//  NSString+IMUtils.m
//
//
//  Created by Weibai on 2022/11/9.
//

#import "NSString+IMUtils.h"

@implementation NSString (IMUtils)
- (NSString *)im_substringToIndex:(NSUInteger)to
{
    if (to <= 0) {
        return self;
    }

    if (self.length < to) {
        return self;
    }

    return [self substringToIndex:to];
}


- (CGSize)im_boundingRectWithFont:(UIFont *)font MaxSize:(CGSize)maxSize{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};

    CGSize labelSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);

    return labelSize;
}
@end
