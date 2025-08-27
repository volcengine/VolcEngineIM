//
//  BIMUserSelectionController.h
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import "BIMBaseTableViewController.h"

#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>

NS_ASSUME_NONNULL_BEGIN

@class BIMUserSelectionController, BIMUser;
@protocol BIMUserSelectionControllerDelegate <NSObject>

- (void)userSelectVC:(BIMUserSelectionController *)vc didChooseUser: (BIMUser *)user;

- (void)userSelectVCDidClickClose: (BIMUserSelectionController *)vc;

@end

@interface BIMUserSelectionController : BIMBaseTableViewController

- (instancetype)initWithConversationID:(NSString *)conversationID;

@property (nonatomic, weak) id<BIMUserSelectionControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray *users;


@end

NS_ASSUME_NONNULL_END
