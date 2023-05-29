//
//  BDIMDebugNetworkRequestInfoView.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/21.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugNetworkRequestInfoView.h"

@interface BDIMDebugNetworkRequestInfoView ()

@property (nonatomic, strong) UIScrollView *containter;

@property (nonatomic, strong) UILabel *hostLabel;
@property (nonatomic, strong) UILabel *pathLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *wsLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *logidLabel;
@property (nonatomic, strong) UILabel *requestTitleLabel;
@property (nonatomic, strong) UILabel *requestLabel;
@property (nonatomic, strong) UILabel *responseTitleLabel;
@property (nonatomic, strong) UILabel *responseLabel;
@property (nonatomic, strong) UILabel *errorLabel;
@end

@implementation BDIMDebugNetworkRequestInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.containter = [[UIScrollView alloc] init];
        self.containter.showsHorizontalScrollIndicator = NO;
        self.containter.showsVerticalScrollIndicator = NO;
        self.containter.alwaysBounceHorizontal = NO;
        [self addSubview:self.containter];
        
        self.hostLabel = [UILabel new];
        self.hostLabel.font = [UIFont boldSystemFontOfSize:11];
        self.hostLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.hostLabel];
        
        self.pathLabel = [UILabel new];
        self.pathLabel.font = [UIFont boldSystemFontOfSize:11];
        self.pathLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.pathLabel];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:11];
        self.dateLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.dateLabel];
        
        self.wsLabel = [UILabel new];
        self.wsLabel.font = [UIFont boldSystemFontOfSize:11];
        self.wsLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.wsLabel];
        
        self.codeLabel = [UILabel new];
        self.codeLabel.font = [UIFont boldSystemFontOfSize:11];
        self.codeLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.codeLabel];
        
        self.logidLabel = [UILabel new];
        self.logidLabel.font = [UIFont boldSystemFontOfSize:11];
        self.logidLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.logidLabel];
        
        self.requestTitleLabel = [UILabel new];
        self.requestTitleLabel.text = @"Request";
        self.requestTitleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.requestTitleLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.requestTitleLabel];
        
        self.requestLabel = [UILabel new];
        self.requestLabel.numberOfLines = 0;
        self.requestLabel.font = [UIFont systemFontOfSize:11];
        self.requestLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.requestLabel];
        
        self.responseTitleLabel = [UILabel new];
        self.responseTitleLabel.text = @"Response";
        self.responseTitleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.responseTitleLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.responseTitleLabel];
        
        self.responseLabel = [UILabel new];
        self.responseLabel.numberOfLines = 0;
        self.responseLabel.font = [UIFont systemFontOfSize:11];
        self.responseLabel.textColor = [UIColor blackColor];
        [self.containter addSubview:self.responseLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.containter.frame = self.bounds;
    [self.hostLabel sizeToFit];
    self.hostLabel.frame = CGRectMake(12, 12 + 30+8, self.hostLabel.bounds.size.width, self.hostLabel.bounds.size.height);
    
    [self.pathLabel sizeToFit];
    self.pathLabel.frame = CGRectMake(12, CGRectGetMaxY(self.hostLabel.frame)+8, self.pathLabel.bounds.size.width, self.pathLabel.bounds.size.height);
    
    [self.dateLabel sizeToFit];
    self.dateLabel.frame = CGRectMake(12, CGRectGetMaxY(self.pathLabel.frame)+8, self.dateLabel.bounds.size.width, self.dateLabel.bounds.size.height);
    [self.wsLabel sizeToFit];
    self.wsLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame)+8, self.dateLabel.frame.origin.y, self.wsLabel.bounds.size.width, self.wsLabel.bounds.size.height);
    [self.codeLabel sizeToFit];
    self.codeLabel.frame = CGRectMake(CGRectGetMaxX(self.wsLabel.frame)+8, self.dateLabel.frame.origin.y, self.codeLabel.bounds.size.width, self.codeLabel.bounds.size.height);
    
    [self.logidLabel sizeToFit];
    self.logidLabel.frame = CGRectMake(12, CGRectGetMaxY(self.dateLabel.frame) + 8, self.logidLabel.bounds.size.width, self.logidLabel.bounds.size.height);
    
    [self.requestTitleLabel sizeToFit];
    self.requestTitleLabel.frame = CGRectMake(12, CGRectGetMaxY(self.logidLabel.frame) + 8, self.requestTitleLabel.bounds.size.width, self.requestTitleLabel.bounds.size.height);
    self.requestLabel.bounds = CGRectMake(0, 0, self.bounds.size.width - 24, MAXFLOAT);
    [self.requestLabel sizeToFit];
    self.requestLabel.frame = CGRectMake(12, CGRectGetMaxY(self.requestTitleLabel.frame) + 8, self.requestLabel.bounds.size.width, self.requestLabel.bounds.size.height);
    
    [self.responseTitleLabel sizeToFit];
    self.responseTitleLabel.frame = CGRectMake(12, CGRectGetMaxY(self.requestLabel.frame) + 8, self.responseTitleLabel.bounds.size.width, self.responseTitleLabel.bounds.size.height);
    self.responseLabel.bounds = CGRectMake(0, 0, self.bounds.size.width - 24, MAXFLOAT);
    [self.responseLabel sizeToFit];
    self.responseLabel.frame = CGRectMake(12, CGRectGetMaxY(self.responseTitleLabel.frame) + 8, self.responseLabel.bounds.size.width, self.responseLabel.bounds.size.height);
    
    self.containter.contentSize = CGSizeMake(0, CGRectGetMaxY(self.responseLabel.frame)+12);
}

- (void)showRequest:(BDIMDebugNetworkRequest *)request{
    self.containter.contentOffset = CGPointZero;
    self.hostLabel.text = [NSString stringWithFormat:@"Host: %@", request.host];
    self.pathLabel.text = [NSString stringWithFormat:@"Path: %@", request.path];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm:ss";
    self.dateLabel.text = [NSString stringWithFormat:@"【%@】",[formatter stringFromDate:request.date]];
    self.wsLabel.text = [NSString stringWithFormat:@" %@ ",request.method];
    if ([request.method isEqualToString:@"Websocket"]) {
        self.wsLabel.textColor = [UIColor blackColor];
        self.wsLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:224/255.0 blue:98/255.0 alpha:1.0];
    }else{
        self.wsLabel.textColor = [UIColor whiteColor];
        self.wsLabel.backgroundColor = [UIColor colorWithRed:97/255.0 green:23/255.0 blue:218/255.0 alpha:1.0];
    }
    self.codeLabel.text = [NSString stringWithFormat:@"Status: %@",request.statusCode];
    self.logidLabel.text = [NSString stringWithFormat:@"Logid: %@",request.logid];
    self.requestLabel.text = request.requestObject.description;
    self.responseLabel.text = request.responseObject.description;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
