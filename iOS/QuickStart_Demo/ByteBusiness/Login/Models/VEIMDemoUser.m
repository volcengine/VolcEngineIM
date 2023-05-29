//
//  VEIMDemoUser.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/1.
//

#import "VEIMDemoUser.h"

@implementation VEIMDemoUser

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.portrait forKey:@"portrait"];
    [coder encodeInt64:self.userID forKey:@"userID"];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.portrait = [coder decodeObjectForKey:@"portrait"];
        self.userID = [coder decodeInt64ForKey:@"userID"];
    }
    return self;
}

@end
