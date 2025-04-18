//
//  VEIMDemoUserSelectionController.h
//  VEIMDemo
//
//  Created by Weibai on 2022/11/11.
//

#import "BIMBaseTableViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    VEIMDemoUserSelectionStyleChoose,
    VEIMDemoUserSelectionStyleSingleSelection,
    VEIMDemoUserSelectionStyleMultiSelection,
} VEIMDemoUserSelectionStyle;

@class VEIMDemoUserSelectionController, VEIMDemoUser, BIMConversation;
@protocol VEIMDemoUserSelectionControllerDelegate <NSObject>

@optional

- (void)userSelectVC: (VEIMDemoUserSelectionController *)vc didSelectUsers: (NSArray <VEIMDemoUser *> *)users;
- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didChooseUser: (VEIMDemoUser *)user;

- (void)userSelectVCDidClickClose: (VEIMDemoUserSelectionController *)vc;

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didLongPressUser:(VEIMDemoUser *)user indexPath:(NSIndexPath *)indexPath;


@end

@interface VEIMDemoUserSelectionController : BIMBaseTableViewController

- (instancetype)initWithUsers: (NSArray <VEIMDemoUser *>*)users;

@property (nonatomic, assign) VEIMDemoUserSelectionStyle style;

@property (nonatomic, assign) BOOL isShowSilentMark;

@property (nonatomic, assign) BOOL isShowSearcTextField;

@property (nonatomic, strong) BIMConversation *conversation;

@property (nonatomic, weak) id <VEIMDemoUserSelectionControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray *users;

- (void)clearSelectedUsers;

@end

NS_ASSUME_NONNULL_END
