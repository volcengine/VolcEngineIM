//
//  VEIMDemoConversationListSelectionCollectionView.h
//  ByteBusiness
//
//  Created by hexi on 2023/11/20.
//  Copyright © 2023 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BIMConversationListType);

@protocol VEIMDemoConversationListSelectionDelegate <NSObject>

@required

- (void)didSelectType:(BIMConversationListType)type;

@end

@interface VEIMDemoConversationListSelectionCollectionView : UICollectionView

@property (nonatomic, weak, nullable) id<VEIMDemoConversationListSelectionDelegate> viewDelegate;

- (void)setTotalUnreadCount:(NSUInteger)totalUnreadCount withType:(BIMConversationListType)type;

@end
