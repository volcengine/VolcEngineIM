//
//  VEIMDemoGlobalSearchResultCell.m
//  ByteBusiness
//
//  Created by hexi on 2024/11/19.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoGlobalSearchResultCell.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>
#import <im-uikit-tob/BIMUIClient.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/NSDate+IMUtils.h>

#import "UIImageView+WebCache.h"

@interface VEIMDemoGlobalSearchResultCell ()

/// 是否不展示 subTitleLabel
@property (nonatomic, assign) BOOL notShowSubTitleLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation VEIMDemoGlobalSearchResultCell

- (void)setupUIElemets
{
    [super setupUIElemets];
    
    [self.contentView addSubview:self.dateLabel];
}

- (void)reloadWithGroupInfo:(BIMSearchGroupInfo *)groupInfo
{
    [self.portrait sd_setImageWithURL:nil placeholderImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_avatar_group")];
    self.nameLabel.attributedText = ({
        NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
        if (groupInfo.nameDetail) {
            [astrm appendAttributedString:[self attributedStringWithSearchDetail:groupInfo.nameDetail]];
        } else {
            [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:kValidStr(groupInfo.conversation.name) ? groupInfo.conversation.name : @"未命名群聊"]];
        }
        [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%lu)", groupInfo.conversation.memberCount]]];
        astrm.copy;
    });
    self.subTitleLabel.attributedText = ({
        NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
        if (!BTD_isEmptyArray(groupInfo.memberInfoList)) {
            [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:@"包含群成员:"]];
            [groupInfo.memberInfoList enumerateObjectsUsingBlock:^(BIMSearchMemberInfo * _Nonnull memberInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                BIMSearchDetail *searchDeatil = [self getSearchDetailWithMemberInfo:memberInfo];
                [astrm appendAttributedString:[self attributedStringWithSearchDetail:searchDeatil]];
                [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }];
        } else if (groupInfo.cidDetail) {
            BIMSearchDetail *searchDeatil = groupInfo.cidDetail;
            [astrm appendAttributedString:[self attributedStringWithSearchDetail:searchDeatil]];
        }
        astrm.copy;
    });
}

- (void)reloadWithMemberInfo:(BIMSearchMemberInfo *)memberInfo
{
    BIMUser *user = [BIMUIClient sharedInstance].userProvider(memberInfo.member.userID);
    if (!user) {
        [self.portrait sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
    } else {
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:user.placeholderImage];
    }
    self.nameLabel.attributedText = ({
        NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
        BIMSearchDetail *searchDeatil = [self getSearchDetailWithMemberInfo:memberInfo];
        [astrm appendAttributedString:[self attributedStringWithSearchDetail:searchDeatil]];
        NSString *role = @"";
        if (memberInfo.member.role == BIM_MEMBER_ROLE_ADMIN) {
            role = @" [管理员] ";
        } else if (memberInfo.member.role == BIM_MEMBER_ROLE_OWNER){
            role = @" [群主] ";
        }
        [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:role]];
        astrm.copy;
    });
}

- (void)reloadWithFriendInfo:(BIMSearchFriendInfo *)friendInfo
{
    BIMUser *user = [BIMUIClient sharedInstance].userProvider(friendInfo.userInfo.uid);
    if (!user) {
        [self.portrait sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
    } else {
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:friendInfo.userInfo.portraitUrl] placeholderImage:user.placeholderImage];
    }
    self.notShowSubTitleLabel = NO;
    self.nameLabel.attributedText = ({
        NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
        if (friendInfo.friendAliasDetail) {
            [astrm appendAttributedString:[self attributedStringWithSearchDetail:friendInfo.friendAliasDetail]];
            self.notShowSubTitleLabel = YES;
        } else if (friendInfo.nickNameDetail) {
            [astrm appendAttributedString:[self attributedStringWithSearchDetail:friendInfo.nickNameDetail]];
            self.notShowSubTitleLabel = YES;
        } else if (!BTD_isEmptyString(friendInfo.userInfo.aliasName)) {
            [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:friendInfo.userInfo.aliasName]];
        } else if (!BTD_isEmptyString(friendInfo.userInfo.nickName)) {
            [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:friendInfo.userInfo.nickName]];
        } else {
            [astrm appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"用户%lld", friendInfo.userInfo.uid]]];
        }
        astrm.copy;
    });
    if (!self.notShowSubTitleLabel) {
        self.subTitleLabel.attributedText = ({
            NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@"包含:"];
            BIMSearchDetail *searchDeatil;
            if (friendInfo.nickNameDetail) {
                searchDeatil = friendInfo.nickNameDetail;
            } else if (friendInfo.uidDetail) {
                searchDeatil = friendInfo.uidDetail;
            }
            [astrm appendAttributedString:[self attributedStringWithSearchDetail:searchDeatil]];
            astrm.copy;
        });
    }
}

- (void)reloadWithMsgInConvInfo:(BIMSearchMsgInConvInfo *)msgInConvInfo
{
    if (msgInConvInfo.conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        long long chatUID = msgInConvInfo.conversation.oppositeUserID;
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(chatUID);
        if (!user) {
            [self.portrait sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
        } else {
            [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:user.placeholderImage];
        }
        if (!BTD_isEmptyString(user.alias)) {
            self.nameLabel.text = user.alias;
        } else if (!BTD_isEmptyString(user.nickName)) {
            self.nameLabel.text = user.nickName;
        } else {
            self.nameLabel.text = [NSString stringWithFormat:@"用户%lld", chatUID];
        }
    } else {
        self.nameLabel.text = kValidStr(msgInConvInfo.conversation.name) ? msgInConvInfo.conversation.name : @"未命名群聊";
        [self.portrait sd_setImageWithURL:nil placeholderImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_avatar_group")];
    }
    if (msgInConvInfo.count > 1) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"%lld条聊天记录", msgInConvInfo.count];
    } else {
        self.subTitleLabel.attributedText = ({
            NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
            BIMSearchDetail *searchDeatil = msgInConvInfo.messageInfo.searchDetail;
            [astrm appendAttributedString:[self attributedStringWithSearchDetail:searchDeatil]];
            astrm.copy;
        });
    }
}

- (void)reloadWithMsgInfo:(BIMSearchMsgInfo *)msgInfo conversation:(BIMConversation *)conversation
{
    long long sendId = msgInfo.message.senderUID;
    BIMUser *user = [BIMUIClient sharedInstance].userProvider(sendId);
    if (!user) {
        [self.portrait sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"icon_recommend_user_default"]];
    } else {
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:user.placeholderImage];
    }
    if (!BTD_isEmptyString(user.alias)) {
        self.nameLabel.text = user.alias;
    } else if (!BTD_isEmptyString(user.nickName)) {
        self.nameLabel.text = user.nickName;
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"用户%lld", sendId];
    }
    self.subTitleLabel.attributedText = ({
        NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:@""];
        BIMSearchDetail *searchDeatil = msgInfo.searchDetail;
        [astrm appendAttributedString:[self attributedStringWithSearchDetail:searchDeatil]];
        astrm.copy;
    });
    self.dateLabel.text = [msgInfo.message.createdTime btd_stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.dateLabel.hidden = NO;
}

- (void)setupConstraints
{
    [super setupConstraints];
    
    if (self.onlyShowNameLabel) {
        self.portrait.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.nameLabel.textColor = [UIColor systemBlueColor];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.right.mas_lessThanOrEqualTo(-40);
        }];
    }
    
    if (self.notShowSubTitleLabel) {
        self.subTitleLabel.hidden = YES;
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).with.offset(12);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.right.mas_lessThanOrEqualTo(-40);
        }];
    }
    
    if (!self.dateLabel.hidden) {
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(self.nameLabel);
        }];
    }
}

#pragma mark - Private

- (NSAttributedString *)attributedStringWithSearchDetail:(BIMSearchDetail *)searchDetail
{
    NSString *searchContent = searchDetail.searchContent;
    if (BTD_isEmptyString(searchContent)) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *astrm = [[NSMutableAttributedString alloc] initWithString:searchContent];
    [searchDetail.keyPositions enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [astrm addAttributes:@{
            NSForegroundColorAttributeName : [UIColor systemBlueColor]
        } range:[obj rangeValue]];
    }];
    return [astrm copy];
}

- (BIMSearchDetail *)getSearchDetailWithMemberInfo:(BIMSearchMemberInfo *)memberInfo
{
    BIMSearchDetail *searchDeatil;
    if (memberInfo.friendAliasDetail) {
        searchDeatil = memberInfo.friendAliasDetail;
    } else if (memberInfo.nickNameDetail) {
        searchDeatil = memberInfo.nickNameDetail;
    } else if (memberInfo.uidDetail) {
        searchDeatil = memberInfo.uidDetail;
    }
    return searchDeatil;
}

#pragma mark - Getter

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = kIM_Sub_Color;
        _dateLabel.hidden = YES;
    }
    return _dateLabel;
}

@end