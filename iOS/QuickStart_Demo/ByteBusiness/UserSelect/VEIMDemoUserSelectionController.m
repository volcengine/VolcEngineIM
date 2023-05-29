//
//  VEIMDemoUserSelectionController.m
//  VEIMDemo
//
//  Created by Weibai on 2022/11/11.
//

#import "VEIMDemoUserSelectionController.h"
#import "VEIMDemoTestUserCell.h"
#import "VEIMDemoUserManager.h"
#import "BIMUIDefine.h"

@interface VEIMDemoUserSelectionController ()

@property (nonatomic, weak) VEIMDemoUser *selectedUser;

@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) NSMutableArray *selectedUsers;

@end

@implementation VEIMDemoUserSelectionController

- (VEIMDemoUserSelectionController *)initWithUsers:(NSArray<VEIMDemoUser *> *)users{
    if (self = [super init]) {
        if ([users isKindOfClass:[NSArray class]]) {
            self.users = [users mutableCopy];
        } else {
            self.users = [NSMutableArray array];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.users) {
        self.users = [NSMutableArray array];
    }
    self.selectedUsers = [NSMutableArray array];
    
    for (VEIMDemoUser *user in self.users) {
        if (user.isSelected) {
            [self.selectedUsers addObject:user];
        }
    }
    
    if (self.style != VEIMDemoUserSelectionStyleChoose) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightClicked:)];
    }
}

- (void)rightClicked: (id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.style != VEIMDemoUserSelectionStyleChoose) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(userSelectVC:didSelectUsers:)]) {
                [self.delegate userSelectVC:self didSelectUsers:self.selectedUsers];
            }
        });
    }else{
        [self dismiss];
        if ([self.delegate respondsToSelector:@selector(userSelectVCDidClickClose:)]) {
            [self.delegate userSelectVCDidClickClose:self];
        }
    }
}



- (void)setupUIElements{
    [super setupUIElements];
    
    [self.tableview registerClass:[VEIMDemoTestUserCell class] forCellReuseIdentifier:@"VEIMDemoTestUserCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEIMDemoTestUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VEIMDemoTestUserCell"];
    VEIMDemoUser *user = [self.users objectAtIndex:indexPath.row];
    if (self.style == VEIMDemoUserSelectionStyleChoose) {
        [cell hideCheckMark:YES];
    }else{
        [cell hideCheckMark:NO];
    }
    [cell hideSilentMark:!self.isShowSilentMark];
    
    cell.user = user;
    
    kWeakSelf(self)
    [cell setLongPressHandler:^(UILongPressGestureRecognizer * _Nonnull gesture) {
        if ([weakself.delegate respondsToSelector:@selector(userSelectVC:didLongPressUser:indexPath:)]) {
            [weakself.delegate userSelectVC:weakself didLongPressUser:user indexPath:indexPath];
        }
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VEIMDemoUser *user = [self.users objectAtIndex:indexPath.row];
    if (!user.isNeedSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (self.style) {
        case VEIMDemoUserSelectionStyleChoose:{
            if ([self.delegate respondsToSelector:@selector(userSelectVC:didChooseUser:)]) {
                [self.delegate userSelectVC:self didChooseUser:user];
            }
            [self dismiss];
            break;
        }
        case VEIMDemoUserSelectionStyleSingleSelection:{
            if (self.selectedUser != user) {
                if (self.selectedUser) {
                    self.selectedUser.isSelected = NO;
                    [self.selectedUsers removeObject:self.selectedUser];
                }
                
                user.isSelected = YES;
                self.selectedUser = user;
                [self.selectedUsers addObject:user];
                [tableView reloadData];
            }
            break;
        }
        case VEIMDemoUserSelectionStyleMultiSelection:{
            user.isSelected = !user.isSelected;
            if (user.isSelected && ![self.selectedUsers containsObject:user]) {
                [self.selectedUsers addObject:user];
                self.selectedUser = user;
            }else if (!user.isSelected && [self.selectedUsers containsObject:user]){
                [self.selectedUsers removeObject:user];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        default:
            break;
    }
}

@end
