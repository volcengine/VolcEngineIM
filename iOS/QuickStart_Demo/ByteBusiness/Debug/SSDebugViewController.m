//
//  SSDebugViewController.m
//  TTDebugCore
//
//  Created by 李琢鹏 on 2020/4/28.
//

#import "SSDebugViewController.h"
#import <OneKit/ByteDanceKit.h>
#if __has_include(<FLEX/FLEX.h>)
#import <FLEX/FLEX.h>
#endif
#import "BDIMDebugNetworkEnvironmentController.h"
#import "SSDebugManager.h"
#import <imsdk-tob/BIMClient.h>

@interface UIView (TTDebugCore)
- (id)tt_addSubviewWithClass:(Class)viewClass;
- (id)tt_addSubviewWithClass:(Class)viewClass frame:(CGRect)frame;
@end


@implementation UIView (TTDebugCore)

- (id)tt_addSubviewWithClass:(Class)viewClass
{
    return [self tt_addSubviewWithClass:viewClass frame:CGRectZero];
}
- (id)tt_addSubviewWithClass:(Class)viewClass frame:(CGRect)frame
{
    if (![viewClass isSubclassOfClass:[UIView class]]) return nil;
    UIView *subView = [[viewClass alloc] initWithFrame:frame];
    [self addSubview:subView];
    return subView;
}
@end


@interface UIApplication (TTDebugCore)

@end


@implementation UIApplication (TTDebugCore)

+ (void)load
{
    [self btd_swizzleInstanceMethod:@selector(motionEnded:withEvent:) with:@selector(ttdebugcore_motionEnded:withEvent:)];
}


- (void)ttdebugcore_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (SSDebugViewController.shakeEntranceEnabled && event.subtype == UIEventSubtypeMotionShake) {
        if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
            
            //             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"打开高级调试？" preferredStyle:UIAlertControllerStyleAlert sourceView:topVC.view];
            //             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
            //             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //                 [topVC presentViewController:[[UINavigationController alloc] initWithRootViewController:SSDebugViewController.new] animated:YES completion:nil];
            //             }];
            //             [alert addAction:ok];
            //             [alert addAction:cancel];
            //             [topVC presentViewController:alert animated:YES completion:nil];
            [SSDebugViewController showDebugVC];
        }
    } else {
        if ([self respondsToSelector:@selector(ttdebugcore_motionEnded:withEvent:)]) {
            [self ttdebugcore_motionEnded:motion withEvent:event];
        }
    }
}


@end


@interface SSDebugViewController ()

@end


@implementation SSDebugViewController

+ (void)showDebugVC
{
    SSDebugViewController *debugVC = [SSDebugViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:debugVC];
    [[BTDResponder topViewController] presentViewController:nav animated:YES completion:nil];
}

static BOOL _shakeEntranceEnabled = YES;
+ (void)setShakeEntranceEnabled:(BOOL)shakeEntranceEnabled
{
    _shakeEntranceEnabled = shakeEntranceEnabled;
}

+ (BOOL)shakeEntranceEnabled
{
    return _shakeEntranceEnabled;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"高级调试";
    self.dataSource = [self buildDataSource];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(_cancelActionFired:)];
}

- (NSArray<STTableViewSectionItem *> *)buildDataSource
{
    NSMutableArray *itemArray = [NSMutableArray array];

    @weakify(self)
    
    [itemArray addObject:({
        STTableViewCellItem *item = [[STTableViewCellItem alloc] initWithTitle:@"网络环境" target:self action:NULL];
        item.actionBlock = ^(STTableViewCellItem *_Nonnull item) {
            @strongify(self);
            BDIMDebugNetworkEnvironmentController *netVC = [[BDIMDebugNetworkEnvironmentController alloc] init];
            [self.navigationController pushViewController:netVC animated:YES];
        };
        item;
    })];
    
#if __has_include(<FLEX/FLEX.h>)
    [itemArray addObject:({
        STTableViewCellItem *item = [[STTableViewCellItem alloc] initWithTitle:@"Flex" target:self action:NULL];
        item.actionBlock = ^(STTableViewCellItem *_Nonnull item) {
            [[FLEXManager sharedManager] showExplorer];
        };
        item;
    })];
#endif
    
    [itemArray addObject:({
        STTableViewCellItem *item = [[STTableViewCellItem alloc] initWithTitle:@"UID登录" target:self action:NULL];
        item.style = STTableViewCellStyleSwitch;
        item.checked = [SSDebugManager sharedInstance].uidLogin;
        item.switchActionBlock = ^(STTableViewCellItem *_Nonnull item) {
            item.checked = !item.checked;
            [SSDebugManager sharedInstance].uidLogin = item.checked;
            @strongify(self);
            [self.tableView reloadData];
#warning zj--提交审核时注意下掉
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
            
            
        };
        item;
    })];
    
    [itemArray addObject:({
        STTableViewCellItem *item = [[STTableViewCellItem alloc] initWithTitle:@"click app crash" target:self action:NULL];
        item.actionBlock = ^(STTableViewCellItem *_Nonnull item) {
            [self performSelector:@selector(testAppCrash3)];
        };
        item;
    })];
    
    [itemArray addObject:({
        STTableViewCellItem *item = [[STTableViewCellItem alloc] initWithTitle:@"click sdk crash" target:self action:NULL];
        item.actionBlock = ^(STTableViewCellItem *_Nonnull item) {
            [[BIMClient sharedInstance] performSelector:@selector(testSDKCrash3)];
        };
        item;
    })];
    
    STTableViewSectionItem *section = [[STTableViewSectionItem alloc] initWithSectionTitle:@"" items:itemArray];
    return @[ section ];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)_cancelActionFired:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
