//
//  BDIMDebugNetworkRequestMonitor.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/17.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugNetworkRequestMonitor.h"
#import "BDIMDebugNetworkManager.h"
#import "BDIMDebugNetworkRequestCell.h"
#import "BDIMDebugToast.h"
#import "BDIMDebugNetworkRequestInfoView.h"
#import <OneKit/ByteDanceKit.h>

typedef enum : NSUInteger {
    BDIMDebugNetworkMonitorTypeAll,
    BDIMDebugNetworkMonitorTypeErrorOnly,
} BDIMDebugNetworkMonitorType;

@interface BDIMDebugNetworkRequestMonitor ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) UIView *requestTableContainer;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *scrollToTop;
@property (nonatomic, strong) UIButton *filter;

@property (nonatomic, strong) BDIMDebugNetworkRequestInfoView *requestInfoView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, assign) BDIMDebugNetworkMonitorType showingType;
@property (nonatomic, strong) NSMutableArray *filterRequests;

@property (nonatomic, strong) NSString *filteringPath;
@end

@implementation BDIMDebugNetworkRequestMonitor


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.alpha = 0.9;
        
        self.requestTableContainer = [[UIView alloc] init];
        [self addSubview:self.requestTableContainer];
        
        self.tableview = [[UITableView alloc] init];
        self.tableview.backgroundColor = [UIColor lightGrayColor];
        [self.requestTableContainer addSubview:self.tableview];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [self.tableview registerClass:[BDIMDebugNetworkRequestCell class] forCellReuseIdentifier:@"BDIMDebugNetworkRequestCell"];
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.pan];
        self.pan.delegate = self;
        
        self.clearBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        self.clearBtn.backgroundColor = [UIColor whiteColor];
        [self.clearBtn setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        [self.clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
        [self.requestTableContainer addSubview:self.clearBtn];
        
        self.scrollToTop = [UIButton buttonWithType: UIButtonTypeCustom];
        self.scrollToTop.backgroundColor = [UIColor whiteColor];
        [self.scrollToTop setBackgroundImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
        [self.scrollToTop addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside];
        [self.requestTableContainer addSubview:self.scrollToTop];
        
        
        self.filter = [UIButton buttonWithType: UIButtonTypeCustom];
        self.filter.backgroundColor = [UIColor whiteColor];
        [self.filter setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
        [self.filter addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        [self.requestTableContainer addSubview:self.filter];
        
        _showingType = BDIMDebugNetworkMonitorTypeAll;
        
        self.requestInfoView = [[BDIMDebugNetworkRequestInfoView alloc] init];
        [self addSubview:self.requestInfoView];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self.requestInfoView addSubview:self.backBtn];
        

        CGFloat btnWH = 30;
        self.clearBtn.layer.cornerRadius = btnWH*0.5;
        self.scrollToTop.layer.cornerRadius = btnWH*0.5;
        self.filter.layer.cornerRadius = btnWH*0.5;
        self.backBtn.layer.cornerRadius = btnWH*0.5;
        
        
        self.requestTableContainer.frame = self.bounds;
        self.tableview.frame = self.bounds;
        self.clearBtn.frame = CGRectMake(self.bounds.size.width - 12 - btnWH, 12, btnWH, btnWH);
        self.scrollToTop.frame = CGRectMake(self.bounds.size.width - 12 - btnWH, 12+btnWH+12, btnWH, btnWH);
        self.filter.frame = CGRectMake(self.bounds.size.width - 12 - btnWH, 12+btnWH+12+btnWH+12, btnWH, btnWH);
        
        self.requestInfoView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        self.backBtn.frame = CGRectMake(12, 12, btnWH, btnWH);
        
//        [self.requestTableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.requestTableContainer);
//        }];
//        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(btnWH);
//            make.right.mas_equalTo(-12);
//            make.top.mas_equalTo(12);
//        }];
//
//        [self.scrollToTop mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(btnWH);
//            make.right.mas_equalTo(-12);
//            make.top.equalTo(self.clearBtn.mas_bottom).with.offset(12);
//        }];
//
//        [self.filter mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(btnWH);
//            make.right.mas_equalTo(-12);
//            make.top.equalTo(self.scrollToTop.mas_bottom).with.offset(12);
//        }];
//
//        [self.requestInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(-self.bounds.size.width);
//            make.width.height.equalTo(self);
//            make.top.mas_equalTo(0);
//        }];
//        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-12);
//            make.width.height.mas_equalTo(btnWH);
//        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)back: (id)sender{
    [self hideRequest];
}

- (NSMutableArray *)filterRequests{
    NSMutableArray *results = [NSMutableArray array];

    if (self.showingType == BDIMDebugNetworkMonitorTypeAll) {
        results = [BDIMDebugNetworkManager sharedManager].requests;
    }else{
        for (BDIMDebugNetworkRequest *request in [BDIMDebugNetworkManager sharedManager].requests) {
            if ((self.showingType == BDIMDebugNetworkMonitorTypeErrorOnly && request.error) || (self.filteringPath.length && [request.path containsString:self.filteringPath])){
                [results addObject:request];
            }
        }
    }
    
    return results;
}

- (void)clear: (id)sender{
    [[BDIMDebugNetworkManager sharedManager] clearMonitorRequests];
}

- (void)scrollToTop: (id)sender{
    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)filter: (id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"过滤器" message:@"选择过滤类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *all = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.filteringPath = @"";
        self.showingType = BDIMDebugNetworkMonitorTypeAll;
    }];
    [alertController addAction:all];
    UIAlertAction *err = [UIAlertAction actionWithTitle:@"只看失败请求" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.filteringPath = @"";
        self.showingType = BDIMDebugNetworkMonitorTypeErrorOnly;
    }];
    [alertController addAction:err];
    UIAlertAction *enterPath = [UIAlertAction actionWithTitle:@"输入path" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Path" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.text = @"";
            textField.placeholder = @"输入想要过滤的Path";
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            UITextField *textField = alertVC.textFields.firstObject;
            if (textField.text.length) {
                self.filteringPath = textField.text;
                [self.tableview reloadData];
            }
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:confirm];
        [[BTDResponder topViewController] presentViewController:alertVC animated:YES completion:nil];
    }];
    [alertController addAction:enterPath];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [[BTDResponder topViewController] presentViewController:alertController animated:YES completion:nil];
}


- (void)setShowingType:(BDIMDebugNetworkMonitorType)showingType{
    _showingType = showingType;
    
    [self.tableview reloadData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)pan: (UIPanGestureRecognizer *)ges{
    static CGPoint st;
    static CGRect stF;
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:{
            st = [ges locationInView:ges.view];
            stF = self.frame;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint pt = [ges locationInView:ges.view];
            CGFloat move = (pt.x - st.x);
            if (move > 40 || move < -40) {
                CGFloat targetX = self.frame.origin.x + move;
                if (targetX<0) {
                    targetX = 0;
                }
                self.frame = CGRectMake(targetX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            }

            break;

        }
        case UIGestureRecognizerStateEnded:{
            if (stF.origin.x - self.frame.origin.x > 50) {//向左
                [UIView animateWithDuration:0.3 animations:^{
                    self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                }completion:^(BOOL finished) {
                    self.tableview.userInteractionEnabled = YES;
                }];
            }else if (stF.origin.x - self.frame.origin.x < -50){
                [UIView animateWithDuration:0.3 animations:^{
                    self.frame = CGRectMake(self.bounds.size.width - 16, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                }completion:^(BOOL finished) {
                    self.tableview.userInteractionEnabled = NO;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.frame = stF;
                }completion:^(BOOL finished) {
                    self.tableview.userInteractionEnabled = YES;
                }];
            }
            break;
        }
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BDIMDebugNetworkRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BDIMDebugNetworkRequestCell"];
    BDIMDebugNetworkRequest *request = [[self filterRequests] objectAtIndex:indexPath.row];
    cell.request = request;
//    cell.textLabel.text = request.url.absoluteString;
//    if (request.error) {
//        cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:128/255.0 blue:114/255.0 alpha:0.9];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"[status: %@] %@",request.statusCode, request.error.localizedDescription];
//    }else{
//        cell.backgroundColor = [UIColor colorWithRed:179/255.0 green:242/255.0 blue:191/255.0 alpha:0.9];
//        cell.detailTextLabel.text = request.statusCode.stringValue;
//    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self filterRequests].count;
}

- (void)showRequest: (BDIMDebugNetworkRequest *)request{
    self.pan.enabled = NO;
    [self.requestInfoView showRequest:request];
    [UIView animateWithDuration:0.3 animations:^{
        self.requestTableContainer.frame = CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        self.requestInfoView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }];
}

- (void)hideRequest{
    self.pan.enabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.requestTableContainer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.requestInfoView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BDIMDebugNetworkRequest *request = [[self filterRequests] objectAtIndex:indexPath.row];
    [self showRequest:request];
    
    [UIPasteboard generalPasteboard].string = request.logid;
    [BDIMDebugToast showToast:@"logid 已复制"];
}

@end
