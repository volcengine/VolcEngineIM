//
//  MenuView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/22.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BIMStickerDataManager.h"

/// 根据不同的类型显示不同的menu
typedef NS_ENUM(NSInteger, BIMChatShowType) {
    BIMChatShowTypeNone = 0,
    BIMChatShowTypeNormal,
    BIMChatShowTypeNoCopy, /// menu不包含复制功能
    BIMChatShowTypeNoReadReceipt,
    BIMChatShowTypeNoRecall,
    BIMChatShowTypeNoPin,
    BIMChatShowTypeNoUnPin,
    BIMChatShowTypeNoMarkUnRead,
    BIMChatShowTypeNoMarkRead,
};

typedef NS_ENUM(NSInteger, BIMChatMenuType) {
    BIMChatMenuTypeCopy = 0,
    BIMChatMenuTypeDel,
    BIMChatMenuTypeRecall,
    BIMChatMenuTypeReadReceipt,
    BIMChatMenuTypeForceDel,     ///硬删除，测试消息完整性检查用的
    BIMChatMenuTypeReferMessage, ///引用消息
    BIMChatMenuTypePin,
    BIMChatMenuTypeUnPin,
    BIMChatMenuTypeFavorite,
    BIMChatMenuTypeMarkUnRead,
    BIMChatMenuTypeMarkRead,
    BIMChatMenuTypePinTag,
    BIMChatMenuTypeModify,
    BIMChatMenuTypeDebug,
    BIMChatMenuTypeDebugMessageDetail,
};

@protocol BIMChatMenuViewDelegate <NSObject>

- (void)menuViewDidSelectItem:(BIMChatMenuType)type;
- (void)menuViewDidSelectEmoji:(BIMEmoji *)emoji;

@end


@interface BIMChatMenuView : UIView
@property (nonatomic, weak) id <BIMChatMenuViewDelegate> delegate;

/// 传ShowType类型
@property (nonatomic, strong) NSArray<NSNumber *> *typesMAry;

@end
