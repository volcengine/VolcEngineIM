//
//  VEIMDemoGlobalSearchMoreResultController.h
//  ByteBusiness
//
//  Created by hexi on 2024/11/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "BIMBaseViewController.h"

@class BIMConversation;
typedef NS_ENUM(NSInteger, VEIMDemoGlobalSearchType);

@interface VEIMDemoGlobalSearchMoreResultController : BIMBaseViewController

@property (nonatomic, strong, nullable) BIMConversation *conversation;
@property (nonatomic, assign) BOOL canSearchEmptyGroup;

- (instancetype _Nonnull)initWithSearchType:(VEIMDemoGlobalSearchType)searchType key:(NSString *_Nullable)key limit:(NSInteger)limit;

@end
