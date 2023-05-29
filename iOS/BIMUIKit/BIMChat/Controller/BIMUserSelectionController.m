//
//  BIMUserSelectionController.m
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import "BIMUserSelectionController.h"
#import "BIMUserCell.h"
#import "BIMUIDefine.h"

@interface BIMUserSelectionController ()

@property (nonatomic, weak) BIMUser *selectedUser;

@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation BIMUserSelectionController

- (BIMUserSelectionController *)initWithUsers:(NSArray<BIMUser *> *)users{
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
}

- (void)rightClicked: (id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(userSelectVCDidClickClose:)]) {
        [self.delegate userSelectVCDidClickClose:self];
    }
}

- (void)setupUIElements{
    [super setupUIElements];
    
    [self.tableview registerClass:[BIMUserCell class] forCellReuseIdentifier:@"BIMUserCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BIMUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BIMUserCell"];
    BIMUser *user = [self.users objectAtIndex:indexPath.row];
    cell.user = user;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BIMUser *user = [self.users objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.delegate respondsToSelector:@selector(userSelectVC:didChooseUser:)]) {
        [self.delegate userSelectVC:self didChooseUser:user];
    }
    [self dismiss];
}

@end
