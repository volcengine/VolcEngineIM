//
//  VEIMDemoUserListCell.h
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BIMBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEIMDemoUserListCell : BIMBaseTableViewCell
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *userItems;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *minusBtn;

@property (nonatomic, strong) UIImageView *arrow;

@property (nonatomic, strong) UILabel *subTitleLabel;

//@property (nonatomic, assign) BOOL canAddRemove;

@property (nonatomic, assign) BOOL canAdd;
@property (nonatomic, assign) BOOL canRemove;


@property (nonatomic, strong) void(^clickHandler)(void);
@property (nonatomic, strong) void(^addHandler)(void);
@property (nonatomic, strong) void(^minusHandler)(void);

- (void)refreshWithConversationParticipants: (NSOrderedSet *)participants;

@end

NS_ASSUME_NONNULL_END
