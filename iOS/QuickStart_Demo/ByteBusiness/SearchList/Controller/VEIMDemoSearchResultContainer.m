//
//  VEIMDemoSearchListViewController.m
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/17.
//  Copyright © 2024 loulan. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMSDK.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>
#import <im-uikit-tob/NSDate+IMUtils.h>
#import "VEIMDemoSearchResultContainer.h"
#import "VEIMDemoSearchResultController.h"
#import "VEIMDemoMediaResultController.h"
#import "VEIMDemoDateResultController.h"
#import "NSArray+BTDAdditions.h"

typedef NS_ENUM(NSInteger, VEIMDemoSelectedSegment) {
    // 文本
    VEIM_SELECTED_TEXT = 0,
    
    // 文件
    VEIM_SELECTED_FILE = 1,
    
    // 图片
    VEIM_SELECTED_IMAGE = 2,
    
    // 视频
    VEIM_SELECTED_VEDIO = 3
};

@interface VEIMDemoSearchResultContainer ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, strong) UIViewController *currentController;

@end

@implementation VEIMDemoSearchResultContainer

- (instancetype)initWithConversationID:(NSString *)conversationID conversationType:(BIMConversationType)convType direction:(BIMPullDirection)direction
{
    self = [super init];
    if (self) {
        _conversationID = conversationID;
        _convType = convType;
        
        VEIMDemoSearchResultController *vc_text = [[VEIMDemoSearchResultController alloc] initWithConversationID:conversationID msgType:BIM_MESSAGE_TYPE_TEXT direction:direction];
        VEIMDemoSearchResultController *vc_file = [[VEIMDemoSearchResultController alloc] initWithConversationID:conversationID msgType:BIM_MESSAGE_TYPE_FILE direction:direction];
        VEIMDemoMediaResultController *vc_image = [[VEIMDemoMediaResultController alloc] initWithConversationID:conversationID convtype:convType msgType:BIM_MESSAGE_TYPE_IMAGE direction:direction];
        VEIMDemoMediaResultController *vc_video = [[VEIMDemoMediaResultController alloc] initWithConversationID:conversationID convtype:convType msgType:BIM_MESSAGE_TYPE_VIDEO direction:direction];
        VEIMDemoDateResultController *vc_date = [[VEIMDemoDateResultController alloc] initWithConversationID:conversationID];
        
        _currentController = BTD_DYNAMIC_CAST(UIViewController, vc_text);
        _controllers = @[vc_text, vc_file, vc_image, vc_video, vc_date];
        [self addChildViewController:_currentController];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupViews];
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"会话中搜索";
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.currentController.view];
    [self.segmentedControl setFrame:CGRectMake(10, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height + 10, self.view.frame.size.width - 20, 35)];
    [self updateViews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.currentController becomeFirstResponder];
}

- (void)updateViews
{
    CGFloat current_y = CGRectGetMaxY(self.segmentedControl.frame);
    self.currentController.view.frame = CGRectMake(0, current_y, self.view.frame.size.width, self.view.frame.size.height - current_y);
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

#pragma mark - Getter & Setter

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"消息", @"文件", @"图片", @"视频", @"日期"]];
        segmentedControl.selectedSegmentIndex = VEIM_SELECTED_TEXT;
        segmentedControl.apportionsSegmentWidthsByContent = YES;
        
        NSDictionary *selectedTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0],
        };
        NSDictionary *textAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:14.0]
        };
        [segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
        [segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [segmentedControl sizeToFit];

        [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        
        _segmentedControl = segmentedControl;
    }
    return _segmentedControl;
}

#pragma mark - UISegementedControl 协议方法
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl
{
    if (self.currentController) {
        [self.currentController removeFromParentViewController];
        [self.currentController.view removeFromSuperview];
    }
    
    self.currentController = BTD_DYNAMIC_CAST(UIViewController, [self.controllers btd_objectAtIndex:segmentedControl.selectedSegmentIndex]);
    [self addChildViewController:self.currentController];
    [self.view addSubview:self.currentController.view];
    [self updateViews];
}


@end
