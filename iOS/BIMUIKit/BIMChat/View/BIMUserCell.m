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
    self.nameLabel.text = user.nickName;
    self.subTitleLabel.text = nil;
    
    [self setupConstraints];
}

@end
