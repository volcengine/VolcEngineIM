//
//  VEIMDemoSelectUserViewController.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/6/25.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewController.h"
#import <imsdk-tob/BIMSDK.h>


typedef NS_ENUM(NSUInteger, VEIMDemoSelectUserShowType) {
    VEIMDemoSelectUserShowTypeCreateChat,      // 创建聊天
    VEIMDemoSelectUserShowTypeAddParticipants, // 群聊添加成员
    VEIMDemoSelectUserShowTypeMarkUser,        // 标记用户
};

@protocol VEIMDemoSelectUserViewControllerDelegate <NSObject>

@optional

- (void)didSelectUidList:(NSArray<NSString *> *_Nullable)uidList;

@end

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoSelectUserViewController : BIMBaseTableViewController
@property (nonatomic, assign) VEIMDemoSelectUserShowType showType;
@property (nonatomic, assign) BIMConversationType conversationType;
@property (nonatomic, strong) BIMConversation *conversation; // 添加群成员
@property (nonatomic, weak, nullable) id<VEIMDemoSelectUserViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
