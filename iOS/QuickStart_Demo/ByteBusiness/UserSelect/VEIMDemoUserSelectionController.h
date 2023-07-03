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

@class VEIMDemoUserSelectionController, VEIMDemoUser;
@protocol VEIMDemoUserSelectionControllerDelegate <NSObject>

- (void)userSelectVC: (VEIMDemoUserSelectionController *)vc didSelectUsers: (NSArray <VEIMDemoUser *> *)users;
- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didChooseUser: (VEIMDemoUser *)user;

- (void)userSelectVCDidClickClose: (VEIMDemoUserSelectionController *)vc;

- (void)userSelectVC:(VEIMDemoUserSelectionController *)vc didLongPressUser:(VEIMDemoUser *)user indexPath:(NSIndexPath *)indexPath;


@end

@interface VEIMDemoUserSelectionController : BIMBaseTableViewController

- (instancetype)initWithUsers: (NSArray <VEIMDemoUser *>*)users;

@property (nonatomic, assign) VEIMDemoUserSelectionStyle style;

@property (nonatomic, assign) BOOL isShowSilentMark;

@property (nonatomic, weak) id <VEIMDemoUserSelectionControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray *users;


@end

NS_ASSUME_NONNULL_END
