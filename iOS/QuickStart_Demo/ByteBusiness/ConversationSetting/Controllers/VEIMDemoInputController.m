//
//  VEIMDemoInputController.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoInputController.h"

@interface VEIMDemoInputController () <UITextViewDelegate>
@property (nonatomic, strong) NSString *inputText;
@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) int maxWordCount;
@property (nonatomic, strong) void(^handler)(NSString *text);
@end

@implementation VEIMDemoInputController

- (instancetype)initWithTitle: (NSString *)title text:(NSString *)text maxWordCount:(NSInteger)max editable: (BOOL)editable handler:(nonnull void (^)(NSString *text))hander
{
    self = [super init];
    if (self) {
        self.title = title;
        self.inputText = text;
        self.handler = hander;
        self.editable = editable;
        if (max <= 0) {
            self.maxWordCount = NSIntegerMax;
        } else {
            self.maxWordCount = max;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textview = [UITextView new];
    self.textview.text = self.inputText;
    self.textview.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.textview];
    self.textview.delegate = self;
    self.textview.frame = CGRectMake(16, 16, self.view.bounds.size.width - 32, self.view.bounds.size.height - 32);
    self.textview.editable = self.editable;
    if (self.editable) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightClicked:)];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textview becomeFirstResponder];
}

- (void)rightClicked: (id)sender{
    if (self.handler) {
        self.handler(self.textview.text);
    }
    [self dismiss];
}

- (void)textViewDidChange:(UITextView *)textView{
    int length = self.maxWordCount;
    NSString *toBeString = textView.text;

    NSString *lang = [[textView textInputMode] primaryLanguage];; // 键盘输入模式

    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            if (toBeString.length > length){
                textView.text = [toBeString substringToIndex:length];
            }
        }else{

        }
    }else{
        if (toBeString.length > length) {
            textView.text = [toBeString substringToIndex:length];
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
