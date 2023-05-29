//
//  BDIMDebugNetworkRequestCell.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/17.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugNetworkRequestCell.h"
#import "BDIMDebugNetworkManager.h"
#import <Masonry/Masonry.h>

@implementation BDIMDebugNetworkRequestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.methodLabel = [UILabel new];
//        self.methodLabel.font = [UIFont boldSystemFontOfSize:14];
//        self.methodLabel.textColor = [UIColor whiteColor];
//        self.methodLabel.backgroundColor = [UIColor colorWithRed:41/255.0 green:36/255.0 blue:33/255.0 alpha:1.0];
//        [self.contentView addSubview:self.methodLabel];
        
        self.wsMethod = [UILabel new];
        self.wsMethod.font = [UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:self.wsMethod];
        
        self.urlDescLabel = [UILabel new];
        self.urlDescLabel.font = [UIFont boldSystemFontOfSize:11];
        self.urlDescLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.urlDescLabel];
        
        self.urlLabel = [UILabel new];
        self.urlLabel.font = [UIFont systemFontOfSize:11];
        self.urlLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.urlLabel];
        
        [self.wsMethod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(8);
            make.bottom.mas_equalTo(-6);
        }];
        
        [self.wsMethod setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.urlDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wsMethod.mas_right).with.offset(8);
            make.centerY.mas_equalTo(0);
        }];
        [self.urlDescLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.urlDescLabel.mas_right).with.offset(4);
            make.centerY.mas_equalTo(0);
            make.right.mas_lessThanOrEqualTo(-8);
        }];
        [self.urlLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}

- (void)setRequest:(BDIMDebugNetworkRequest *)request{
    _request = request;
//    self.methodLabel.text = [NSString stringWithFormat:@" %@ ",request.method];
    self.wsMethod.text = [NSString stringWithFormat:@" %@ ",request.wsMethod];
    if ([request.wsMethod isEqualToString:@"Websocket"]) {
        self.wsMethod.textColor = [UIColor blackColor];
        self.wsMethod.backgroundColor = [UIColor colorWithRed:238/255.0 green:224/255.0 blue:98/255.0 alpha:1.0];
    }else{
        self.wsMethod.textColor = [UIColor whiteColor];
        self.wsMethod.backgroundColor = [UIColor colorWithRed:97/255.0 green:23/255.0 blue:218/255.0 alpha:1.0];
    }
    self.urlLabel.text = [NSString stringWithFormat:@"%@",request.path];
    self.urlDescLabel.text = [[BDIMDebugNetworkManager sharedManager] pathToDesc:request.path];
    if (request.error) {
//        self.statusLabel.text = [NSString stringWithFormat:@"ErrorCode: %zd",request.error.code];
//        self.errorLabel.text = request.error.localizedDescription;
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:128/255.0 blue:114/255.0 alpha:0.9];
        
//        [self.urlLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(12);
//            make.right.mas_lessThanOrEqualTo(-12);
//            make.top.equalTo(self.errorLabel.mas_bottom).with.offset(8);
//            make.bottom.mas_equalTo(-12);
//        }];
    }else{
//        self.statusLabel.text = [NSString stringWithFormat:@"Status: %@",request.statusCode];
//        self.errorLabel.text = @"";
        self.backgroundColor = [UIColor colorWithRed:179/255.0 green:242/255.0 blue:191/255.0 alpha:0.9];
        
    }
//    self.logidLabel.text = [NSString stringWithFormat:@"logid:%@",request.logid];
    
//    [self.methodLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(12);
//        make.left.mas_equalTo(12);
//    }];
    

    
//    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.wsMethod.mas_right).with.offset(8);
//        make.centerY.equalTo(self.methodLabel);
//    }];
    
//    [self.logidLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.right.mas_lessThanOrEqualTo(-12);
//        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(8);
//    }];
    
//    [self.errorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.right.mas_lessThanOrEqualTo(-12);
//        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(8);
//    }];
    
}

@end
