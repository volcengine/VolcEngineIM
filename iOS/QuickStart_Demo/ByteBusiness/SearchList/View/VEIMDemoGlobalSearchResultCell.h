//
//  VEIMDemoGlobalSearchResultCell.h
//  ByteBusiness
//
//  Created by hexi on 2024/11/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "BIMPortraitBaseCell.h"

@class BIMSearchFriendInfo, BIMSearchGroupInfo, BIMSearchMemberInfo, BIMSearchMsgInConvInfo, BIMSearchMsgInfo, BIMConversation;

@interface VEIMDemoGlobalSearchResultCell : BIMPortraitBaseCell

/// 是否只展示 NameLabel
@property (nonatomic, assign) BOOL onlyShowNameLabel;

- (void)reloadWithGroupInfo:(BIMSearchGroupInfo *_Nonnull)groupInfo;
- (void)reloadWithMemberInfo:(BIMSearchMemberInfo *_Nonnull)memberInfo;
- (void)reloadWithFriendInfo:(BIMSearchFriendInfo *_Nonnull)friendInfo;
- (void)reloadWithMsgInConvInfo:(BIMSearchMsgInConvInfo *_Nonnull)msgInConvInfo;
- (void)reloadWithMsgInfo:(BIMSearchMsgInfo *_Nonnull)msgInfo conversation:(BIMConversation *_Nonnull)conversation;


@end
