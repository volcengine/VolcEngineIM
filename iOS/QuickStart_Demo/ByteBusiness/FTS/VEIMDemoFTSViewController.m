//
//  VEIMDemoFTSViewController.m
//  ByteBusiness
//
//  Created by yangzhanjiang on 2023/8/31.
//  Copyright © 2023 loulan. All rights reserved.
//

#import "VEIMDemoFTSViewController.h"
#import <Masonry/Masonry.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>
#import "VEIMDemoUserManager.h"
#import <im-uikit-tob/BIMPortraitBaseCell.h>
#import <im-uikit-tob/NSDate+IMUtils.h>
#import "VEIMDemoChatViewController.h"

@interface VEIMDemoFTSViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITextField *txtfSearch;
@property (nonatomic, strong) UITableView *tblResult;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, copy) NSArray<BIMSearchMsgInfo *> *arrMessageResult;
@end

@implementation VEIMDemoFTSViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupViews];
    [self initLayout];
}

- (void)setupViews
{
    [self.view addSubview:self.txtfSearch];
    [self.view addSubview:self.tblResult];
    [self.view addSubview:self.emptyLabel];
    [self.txtfSearch becomeFirstResponder];
}

- (void)initLayout
{
    self.title = @"会话中搜索";
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];

    [self.txtfSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view.safeAreaInsets.top);
        make.height.mas_equalTo(40);
    }];

    [self.tblResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtfSearch.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtfSearch.mas_bottom).offset(150);
        make.left.right.equalTo(self.view);
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblResult reloadData];
    });
}

- (void)didSearchTextChange:(NSString *)word
{
    if (BTD_isEmptyString(word)) {
        self.arrMessageResult = @[];
        self.emptyLabel.hidden = YES;
        [self reloadTable];
        return;
    }

    @weakify(self);
    [[BIMClient sharedInstance] searchLocalMessage:self.conversationID key:word completion:^(NSArray<BIMSearchMsgInfo *> * _Nullable infos, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            [BIMToastView toast:error.localizedDescription];
        } else {
            self.arrMessageResult = infos;
        }
        self.emptyLabel.hidden = infos.count;
        [self reloadTable];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.arrMessageResult.count) {
        return @"消息记录";
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMessageResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIMPortraitBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BIMPortraitBaseCell.class)];
    if (!cell) {
        cell = [[BIMPortraitBaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(BIMPortraitBaseCell.class)];
    }
    BIMSearchMsgInfo *ftsMsg = self.arrMessageResult[indexPath.row];
    cell.nameLabel.text = [[VEIMDemoUserManager sharedManager] nicknameForTestUser:ftsMsg.message.senderUID];
    cell.subTitleLabel.attributedText = ({
        NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
        [astrm appendAttributedString:[self attributedStringWithString:ftsMsg.searchDetail.searchContent arrRange:ftsMsg.searchDetail.keyPositions]];
        astrm.copy;
    });
    cell.detailLabel.text = ftsMsg.message.createdTime.im_stringDate;
    NSString *imageName = [[VEIMDemoUserManager sharedManager] portraitForTestUser:ftsMsg.message.senderUID];
    cell.portrait.image = [UIImage imageNamed:imageName];
    [cell setupConstraints];
    return cell;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)string arrRange:(NSArray<NSValue *> *)arrRange
{
    NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:string];
    [arrRange enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [astrm addAttributes:@{
            NSForegroundColorAttributeName : [UIColor systemBlueColor],
        }
                       range:[obj rangeValue]];
    }];
    return astrm.copy;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BIMSearchMsgInfo *ftsMsg = self.arrMessageResult[indexPath.row];
    @weakify(self);
    [[BIMClient sharedInstance] getConversation:ftsMsg.message.conversationID completion:^(BIMConversation * _Nonnull conversation, BIMError * _Nullable error) {
        @strongify(self);
        VEIMDemoChatViewController *nVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
        nVC.anchorMessage = ftsMsg.message;
        [self.navigationController pushViewController:nVC animated:YES];
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField
{
    [self didSearchTextChange:textField.text];
}


#pragma mark - Getter & Setter

- (UITextField *)txtfSearch
{
    if (!_txtfSearch) {
        UITextField *txtf = [[UITextField alloc] init];
        txtf.delegate = self;
        txtf.placeholder = @"搜索";
        txtf.clearButtonMode = UITextFieldViewModeAlways;

        txtf.leftViewMode = UITextFieldViewModeAlways;
        txtf.leftView = ({
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 34)];
            UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 14, 14)];
            leftImgView.image = [UIImage imageNamed:@"icon_search2"];
            [leftView addSubview:leftImgView];
            leftView;
        });

        _txtfSearch = txtf;
        [_txtfSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _txtfSearch;
}

- (UITableView *)tblResult
{
    if (!_tblResult) {
        UITableView *tbl = [[UITableView alloc] init];
        tbl.backgroundColor = kIM_View_Background_Color;
        tbl.dataSource = self;
        tbl.delegate = self;
        tbl.tableFooterView = [[UIView alloc] init];
        tbl.estimatedRowHeight = 100;
        tbl.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbl.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

        _tblResult = tbl;
    }
    return _tblResult;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        UILabel *label = [UILabel new];
        label.text = @"未搜索到相关结果";
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        _emptyLabel = label;
    }
    return _emptyLabel;
}
@end
