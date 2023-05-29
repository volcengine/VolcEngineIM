//
//  PPReusablePage.h
//  SimpleChat
//
//  Created by 暖阳 on 2019/10/16.
//  Copyright © 2019 musical.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BIMReusablePage <NSObject>

@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic) BOOL nonreusable;

@property (nonatomic) BOOL focused;

- (void)prepareForReuse;

@optional

- (void)didBecomeFocusPage;
- (void)didResignFocusPage;

@end
