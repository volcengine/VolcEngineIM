//
//ConversationCell.m
//
//
//  Created by Weibai on 2022/11/1.
//

#import "BIMConversationCell.h"
#import "UIImage+IMUtils.h"
#import "BIMUIDefine.h"
#import "NSDate+IMUtils.h"
#import "BIMUnreadLabel.h"
#import "BIMUIClient.h"
#import "BIMUICommonUtility.h"

#import <Masonry/Masonry.h>
#import <imsdk-tob/BIMSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <OneKit/BTDMacros.h>
#import <OneKit/ByteDanceKit.h>

@interface BIMConversationCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) BIMUnreadLabel *unreadNumsLabel;
@property (nonatomic, strong) UIImageView *stickOnTopImgView;
@property (nonatomic, strong) UIImageView *muteImgView;
@property (nonatomic, strong) id<BIMMember> sender;

@end

@implementation BIMConversationCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.contentView addGestureRecognizer:longGes];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = kIM_Sub_Color;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.dateLabel];
    
    self.unreadNumsLabel = [BIMUnreadLabel new];
    [self.contentView addSubview:self.unreadNumsLabel];
    
    self.stickOnTopImgView = [UIImageView new];
    self.stickOnTopImgView.image = kIMAGE_IN_BUNDLE_NAMED(@"icon_stickOnTop");
    [self.contentView addSubview:self.stickOnTopImgView];
    
    self.muteImgView = [UIImageView new];
    self.muteImgView.image = kIMAGE_IN_BUNDLE_NAMED(@"icon_mute");
    [self.contentView addSubview:self.muteImgView];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.nameLabel);
        make.width.mas_equalTo(72);
    }];
    
    [self.unreadNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.portrait).with.offset(4);
        make.top.equalTo(self.portrait).with.offset(-4);
    }];
    
    [self.stickOnTopImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.height.mas_equalTo(16);
    }];
    [self.muteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subTitleLabel);
        make.right.mas_equalTo(-12);
        make.width.height.mas_equalTo(16);
    }];
}

- (void)longPress: (UILongPressGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(cellDidLongPress:)]) {
        [self.delegate cellDidLongPress:self];
    }
}

- (void)refreshWithConversation:(BIMConversation *)conversation{
    [self refreshWithConversation:conversation member:nil];
}

- (void)refreshWithConversation:(BIMConversation *)conversation member:(id<BIMMember>)member
{
    self.conversation = conversation;
    self.nameLabel.text = [BIMUICommonUtility getShowNameWithConversation:conversation];
    if (conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
        long long chatUID = conversation.oppositeUserID;
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(chatUID);
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:user.portraitUrl] placeholderImage:user.placeholderImage];
        if (!user) {
            @weakify(self);
            // 获取会话信息
            if ([[BIMUIClient sharedInstance].userInfoDataSource respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
                [[BIMUIClient sharedInstance].userInfoDataSource getUserInfoWithUserId:chatUID completion:^(BIMUser *u) {
                    @strongify(self);
                    if (![conversation.conversationID isEqualToString:self.conversation.conversationID]) {
                        return;
                    }
                    // 会话用户信息及hint的刷新后面改成非递归形式
                    [self refreshWithConversation:conversation];
                }];
            }
        }

    } else if (conversation.conversationType == BIM_CONVERSATION_TYPE_GROUP_CHAT){
        NSURL *portraitURL = nil;
        if (!BTD_isEmptyString(conversation.portraitURL)) {
            portraitURL = [NSURL URLWithString:conversation.portraitURL];
        }
        [self.portrait sd_setImageWithURL: portraitURL placeholderImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_avatar_group")];
    }
    
    [self.unreadNumsLabel refreshWithConversation:conversation];
    
    self.stickOnTopImgView.hidden = !conversation.isStickTop;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    if (conversation.draftText) {
        [attrString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"草稿：%@",conversation.draftText]]];
    } else if (conversation.lastMessage) {
        NSAttributedString *mentionString = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
//        if (conversation.hasUnreadMention) {
//            mentionString = [[NSAttributedString alloc] initWithString:@"[有人@你] " attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
//        }
        
        BIMMessage *msg =  [conversation lastMessage];
        NSString *displayStr = @"";
        
        self.dateLabel.text = msg.createdTime.im_stringDate;
        
        BIMUser *user = [BIMUIClient sharedInstance].userProvider(msg.senderUID);
        if (!user) {
            @weakify(self);
            // 获取hint相关信息
            if ([[BIMUIClient sharedInstance].userInfoDataSource respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
                [[BIMUIClient sharedInstance].userInfoDataSource getUserInfoWithUserId:msg.senderUID completion:^(BIMUser *u) {
                    @strongify(self);
                    if (![conversation.conversationID isEqualToString:self.conversation.conversationID]) {
                        return;
                    }
                    [self refreshWithConversation:conversation];
                }];
            }
        }
        NSString *msgSenderNickname = [BIMUICommonUtility getShowNameInGroupWithUser:user member:member];
        if (msg.isRecalled) {
            if (msg.senderUID == [BIMClient sharedInstance].getCurrentUserID.longLongValue) {
                displayStr = @"你撤回了一条消息";
            } else {
                if (conversation.conversationType == BIM_CONVERSATION_TYPE_ONE_CHAT) {
                    displayStr = [NSString stringWithFormat:@"对方撤回了一条消息"];
                }else{
                    displayStr = [NSString stringWithFormat:@"%@撤回了一条消息", msgSenderNickname];
                }
                
            }
        } else {
            switch (msg.msgType) {
                case BIM_MESSAGE_TYPE_TEXT: {
                    BIMTextElement *element = (BIMTextElement *)msg.element;
                    displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, element.text];
                    if (msg.editInfo.isEdit) {
                        displayStr = [displayStr stringByAppendingString:@"(已编辑)"];
                    }
                } break;
                case BIM_MESSAGE_TYPE_IMAGE: {
                    displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, @"[图片]"];
                } break;
                case BIM_MESSAGE_TYPE_VIDEO:
                case BIM_MESSAGE_TYPE_VIDEO_V2: {
                    displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, @"[视频]"];
                } break;
                case BIM_MESSAGE_TYPE_FILE: {
                    displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, @"[文件]"];
                } break;
                case BIM_MESSAGE_TYPE_AUDIO: {
                    displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, @"[语音]"];
                } break;
                case BIM_MESSAGE_TYPE_CUSTOM: {
                    BIMCustomElement *element = (BIMCustomElement *)msg.element;
                    int type = [element.dataDict[@"type"] intValue];
                    if (type == 2) {
                        displayStr = @"[系统消息]";
                    }else{
                        displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, @"[自定义消息]"];
                    }
                } break;
                default:
                    displayStr = [NSString stringWithFormat:@"%@: %@", msgSenderNickname, @"[未知消息类型]"];
                    break;
            }
        }
        [attrString appendAttributedString:mentionString];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:displayStr]];
    } else {
        self.dateLabel.text = conversation.updatedTime.im_stringDate;
    }
    
    self.subTitleLabel.text = attrString.string;

    self.muteImgView.hidden = !conversation.isMute;
    
    [self setupConstraints];
}

- (void)setupConstraints{
    [super setupConstraints];
    
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portrait.mas_right).with.offset(12);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(self.dateLabel.mas_left).mas_equalTo(-12);
    }];
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.right.mas_equalTo(-60);
    }];
    
}


@end
