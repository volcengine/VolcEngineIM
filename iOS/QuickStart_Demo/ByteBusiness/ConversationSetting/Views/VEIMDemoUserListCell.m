//
//  VEIMDemoUserListCell.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/23.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoUserListCell.h"
#import "VEIMDemoUserListItem.h"
#import "BIMUIDefine.h"
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>

@interface VEIMDemoUserListCell ()
@property (nonatomic, strong) UIButton *bgBtn;
//@property (nonatomic, strong) UIStackView *stack;

@property (nonatomic, strong) UIVisualEffectView *arrowBg;

@end

@implementation VEIMDemoUserListCell

- (void)setupUIElemets{
    [super setupUIElemets];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.contentScrollView];
    
    self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentScrollView addSubview:self.bgBtn];
    [self.bgBtn addTarget:self action:@selector(bgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.stack = [[UIStackView alloc] init];
//    [self.contentScrollView addSubview:self.stack];
//    self.stack.axis = UIAxisHorizontal;
//    self.stack.distribution = UIStackViewDistributionFillEqually;
//    self.stack.spacing = 0;
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_addUser"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.addBtn];
    
    self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_deleteUser"] forState:UIControlStateNormal];
    [self.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.minusBtn];
    
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.arrowBg = [[UIVisualEffectView alloc]initWithEffect:eff];
    self.arrowBg.alpha = 0.8;
    self.arrowBg.userInteractionEnabled = NO;
    [self.contentView addSubview:self.arrowBg];
    
    self.arrow = [UIImageView new];
//    self.arrow.backgroundColor = [UIColor whiteColor];
    self.arrow.image = [UIImage imageNamed:@"icon_detail"];
    [self.contentView addSubview:self.arrow];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = kIM_Sub_Color;
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.subTitleLabel];
    
}

- (void)bgBtnClicked: (id)sender{
    if (self.clickHandler) {
        self.clickHandler();
    }
}

- (void)addBtnClicked: (id)sender{
    if (self.addHandler) {
        self.addHandler();
    }
}

- (void)minusBtnClicked: (id)sender{
    if (self.minusHandler) {
        self.minusHandler();
    }
}

- (void)itemClick:(UITapGestureRecognizer *)gesture
{
    NSInteger index = gesture.view.tag;
    if (self.itemClickHandler) {
        self.itemClickHandler(index);
    }
}

- (NSMutableArray *)userItems{
    if (!_userItems) {
        _userItems = [NSMutableArray array];
    }
    return _userItems;
}

//- (void)setupConstraints{
//    [super setupConstraints];
//
//    [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//        make.height.mas_equalTo(120);
//    }];
//
//    [self.stack mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentScrollView);
//    }];
//
//    [self.arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self);
//        make.right.mas_equalTo(-16);
//    }];
//
//
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentScrollView.frame = self.bounds;
    CGFloat itemWidth = 60;
    UIView *lastItem;
    for (int i = 0; i<self.userItems.count; i++) {
        VEIMDemoUserListItem *item = self.userItems[i];
        
        item.frame = CGRectMake(i*itemWidth, 0, itemWidth, self.bounds.size.height);
        
        lastItem = item;
    }
    
    CGRect addRemoveFrame = CGRectMake(CGRectGetMaxX(lastItem.frame)+10, 16, 40, 40);
    if (self.canAdd) {
        self.addBtn.hidden = NO;
        self.addBtn.frame = addRemoveFrame;
        addRemoveFrame = CGRectMake(CGRectGetMaxX(self.addBtn.frame)+20, 16, 40, 40);
        lastItem = self.addBtn;
    } else {
        self.addBtn.hidden = YES;
    }
    
    if (self.canRemove) {
        self.minusBtn.hidden = NO;
        self.minusBtn.frame = addRemoveFrame;
        lastItem = self.minusBtn;
    } else {
        self.minusBtn.hidden = YES;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastItem.frame)+32, 0);
    
//    if (self.canAddRemove) {
//        self.addBtn.hidden = NO;
//        self.minusBtn.hidden = NO;
//        self.addBtn.frame = CGRectMake(CGRectGetMaxX(lastItem.frame)+10, 16, 40, 40);
//        self.minusBtn.frame = CGRectMake(CGRectGetMaxX(self.addBtn.frame)+20, 16, 40, 40);
//        self.contentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.minusBtn.frame)+32, 0);
//    }else{
//        self.addBtn.hidden = YES;
//        self.minusBtn.hidden = YES;
//        self.contentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastItem.frame)+16+8, 0);
//    }
    
    self.bgBtn.frame = CGRectMake(0, 0, MAX(self.contentScrollView.contentSize.width, self.contentScrollView.bounds.size.width), self.contentScrollView.bounds.size.height);
    
    
    [self.arrow sizeToFit];
    self.arrow.frame = CGRectMake(self.bounds.size.width - self.arrow.bounds.size.width - 8, (self.bounds.size.height - self.arrow.bounds.size.height) * 0.5, self.arrow.bounds.size.width, self.arrow.bounds.size.height);
    
    CGFloat arrowBgX = self.bounds.size.width - self.arrow.bounds.size.width - 16;
    self.arrowBg.frame = CGRectMake(arrowBgX, 0, self.arrow.bounds.size.width + 16, self.contentView.bounds.size.height);
    
    CGFloat subTitleW = 100;
    self.subTitleLabel.frame = CGRectMake(arrowBgX - subTitleW, 0, subTitleW, self.contentView.bounds.size.height);
}

- (void)refreshWithConversationParticipants:(NSArray<id<BIMMember>> *)participants{
    for (UIView *sub in self.userItems) {
        [sub removeFromSuperview];
    }
    
    [self.userItems removeAllObjects];
    
    NSInteger index = 0;
    for (id <BIMMember> participant in participants) {
        VEIMDemoUserListItem *item = [[VEIMDemoUserListItem alloc] init];
        item.tag = index;
        index ++;
        [item refreshWithParticipant:participant];
        [self.contentScrollView addSubview:item];
        [self.userItems addObject:item];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
        [item addGestureRecognizer:tap];
    }
}
@end
