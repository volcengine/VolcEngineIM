//
//  BIMUserCell.m
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import "BIMUserCell.h"

@interface BIMUserCell ()

@end

@implementation BIMUserCell

- (void)setupUIElemets{
    [super setupUIElemets];
}

- (void)setUser:(BIMUser *)user{
    _user = user;
    
    self.portrait.image = user.headImg;
    self.nameLabel.text = (user.alias && user.alias.length) ? user.alias : user.nickName;
    self.subTitleLabel.text = nil;
    
    [self setupConstraints];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
    }];
}

@end
