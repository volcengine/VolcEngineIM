//
//  BIMUserCell.m
//  BIMUIKit
//
//  Created by zhanjiang on 2023/5/26.
//

#import "BIMUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BIMUIClient.h"
#import "BIMUICommonUtility.h"

@interface BIMUserCell ()

@end

@implementation BIMUserCell

- (void)setupUIElemets{
    [super setupUIElemets];
}

- (void)setUser:(BIMUser *)user{
    _user = user;
    
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:user.placeholderImage];
    self.nameLabel.text = [BIMUICommonUtility getShowNameWithUser:user];
    self.subTitleLabel.text = nil;
    
    [self setupConstraints];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
    }];
}

@end
