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
#import "VEIMDemoGlobalSearchDefine.h"
#import "VEIMDemoGlobalSearchMoreResultController.h"

@interface VEIMDemoUserSelectionController () <UITextFieldDelegate>

@property (nonatomic, weak) VEIMDemoUser *selectedUser;

@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) NSMutableArray *selectedUsers;

@property (nonatomic, strong) UITextField *txtfSearch;

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
    if (self.isShowSearcTextField) {
        [self.view addSubview:self.txtfSearch];
    }
    [self updateConstraints];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (void)updateConstraints
{
    if (self.isShowSearcTextField) {
        UIStatusBarManager *manager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        CGFloat statusBarHeight = manager.statusBarFrame.size.height;
        CGFloat topOffset = self.navigationController.navigationBar.frame.size.height + statusBarHeight;
        [self.txtfSearch mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).offset(topOffset);
            make.height.mas_equalTo(40);
        }];
        
        [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.txtfSearch.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(self.view);
        }];
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
//            [self dismiss];
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

- (void)clearSelectedUsers
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.selectedUsers removeAllObjects];
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self didSearchTextChange:[textField.text copy]];
    self.txtfSearch.text = @"";
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self didSearchTextChange:[textField.text copy]];
    self.txtfSearch.text = @"";
}

- (void)didSearchTextChange:(NSString *)word
{
    VEIMDemoGlobalSearchMoreResultController *vc = [[VEIMDemoGlobalSearchMoreResultController alloc] initWithSearchType:VEIMDemoGlobalSearchTypeMember key:word limit:20];
    vc.conversation = self.conversation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter & Setter

- (UITextField *)txtfSearch
{
    if (!_txtfSearch) {
        UITextField *txtf = [[UITextField alloc] init];
        txtf.delegate = self;
        txtf.placeholder = @"搜索";
        txtf.clearButtonMode = UITextFieldViewModeAlways;

        txtf.leftViewMode = UITextFieldViewModeAlways;
        txtf.leftView = ({
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 34)];
            UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 14, 14)];
            leftImgView.image = [UIImage imageNamed:@"icon_search2"];
            [leftView addSubview:leftImgView];
            leftView;
        });

        _txtfSearch = txtf;
        [_txtfSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _txtfSearch;
}

@end
