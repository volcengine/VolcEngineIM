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
    [coder encodeInt64:self.userIDNumber forKey:@"userID"];
    [coder encodeObject:self.userIDString forKey:@"userIDString"];
    [coder encodeObject:self.userToken forKey:@"userToken"];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.portrait = [coder decodeObjectForKey:@"portrait"];
        self.userIDNumber = [coder decodeInt64ForKey:@"userID"];
        self.userIDString = [coder decodeObjectOfClass:[NSString class] forKey:@"userIDString"];
        self.userToken = [coder decodeObjectOfClass:[NSString class] forKey:@"userToken"];
    }
    return self;
}

#pragma mark - Equal

- (BOOL)isEqual:(VEIMDemoUser *)object {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    
    if ([self.userIDString isEqualToString:object.userIDString]) {
        return YES;
    }
    return self.userIDNumber == object.userIDNumber;
}

- (NSUInteger)hash {
    if (self.userIDString) {
        return self.userIDString.hash;
    }
    return self.userIDNumber;
}

@end
