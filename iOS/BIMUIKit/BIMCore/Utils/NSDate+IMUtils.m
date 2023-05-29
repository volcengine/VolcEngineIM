//
//  NSDate+IMUtils.m
//
//
//  Created by Weibai on 2022/11/4.
//

#import "NSDate+IMUtils.h"

@implementation NSDate (IMUtils)
/**
 根据给定日期转换（当天是HH:mm，之前的日期是年/月/日）
 */
- (NSString *)im_stringDate
{
    NSDate *today = [[NSDate alloc] init];
    NSString *todayString = [[today description] substringToIndex:10];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self];

    if ([dateString isEqualToString:todayString]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self];
        return dateString;
    } else {
        return dateString;
    }
}

- (NSString *)im_convDetailDate{
    NSDate *today = [[NSDate alloc] init];

    NSString *yearString = [[today description] substringToIndex:4];
    NSString *todayString = [[today description] substringToIndex:10];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self];

    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy"];
    NSString *dateString2 = [dateFormatter2 stringFromDate:self];

    if ([dateString isEqualToString:todayString]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self];
        return dateString;
    } else if ([dateString2 isEqualToString:yearString]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self];
        return dateString;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self];
        return dateString;
    }
    
    return dateString;
}

@end
