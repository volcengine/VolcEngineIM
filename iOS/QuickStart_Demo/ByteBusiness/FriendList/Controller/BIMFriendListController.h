//
//  BIMFriendListController.h
//  ByteBusiness
//
//  Created by Qin Fan on 2023/7/11.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "BIMBaseTableViewController.h"

@class BIMFriendListController, BIMUserFullInfo;
@protocol BIMFriendListControllerDelegate <NSObject>

- (void)friendListController:(BIMFriendListController *)controller didSelectFriend:(BIMUserFullInfo *)friendInfo;

@end

@interface BIMFriendListController : BIMBaseTableViewController

@property (nonatomic, weak) id<BIMFriendListControllerDelegate> delegate;

@end
