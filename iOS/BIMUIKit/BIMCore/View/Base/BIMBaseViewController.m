//
//  BIMBaseViewController.m
//  
//
//  Created by Weibai on 2022/10/26.
//

#import "BIMBaseViewController.h"
#import "BIMUIDefine.h"

@interface BIMBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BIMBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedLeftBack = YES;
        self.isNeedCloseBtn = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIElements];
    [self registerNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)registerNotification{
    
}

- (void)setupUIElements{
    if ([self isNeedLeftBack]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_back") style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked:)];
    }
    if ([self isNeedCloseBtn]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_close") style:UIBarButtonItemStylePlain target:self action:@selector(rightClicked:)];
    }
}

- (void)dismiss{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightClicked: (id)sender{
    [self dismiss];
}

- (void)backItemClicked: (id)sender{
    [self dismiss];
}

@end
