//
//FileChatCell.m
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMFileChatCell.h"
#import "BIMUIDefine.h"

@interface BIMFileChatCell ()
@property (nonatomic, strong) BIMFileElement *file;
@end

@implementation BIMFileChatCell

- (void)setupUIElemets{
    [super setupUIElemets];
    
//    self.imageBg = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:self.imageBg];
//    self.imageBg.layer.cornerRadius = 8;
//    self.imageBg.backgroundColor = [UIColor whiteColor];
    
    self.imageContent = [UIImageView new];
    [self.contentView addSubview:self.imageContent];
    
    self.fileNameLabel = [UILabel new];
    self.fileNameLabel.numberOfLines = 2;
    self.fileNameLabel.textColor = kIM_Sub_Color;
    self.fileNameLabel.font = kFont(12);
    [self.contentView addSubview:self.fileNameLabel];
    
    self.fileSizeLabel = [UILabel new];
    self.fileSizeLabel.textColor = kIM_Sub_Color;
    self.fileSizeLabel.font = kFont(12);
    [self.contentView addSubview:self.fileSizeLabel];
}

- (UIView*)bgLeft{
    if(self.isSelfMsg){
        return self.fileNameLabel;
    }else{
        return self.imageContent;
    }
}
- (UIView*)bgTop{
    if (self.referMessageLabel.text.length) {
        return self.referMessageLabel;
    }
    return self.imageContent;
}
- (UIView*)bgRight{
    if(!self.isSelfMsg){
        return self.fileNameLabel;
    }else{
        return self.imageContent;
    }
}
- (UIView*)bgBottom{
    return self.fileSizeLabel;
}

- (void)bgDidClicked: (id)sender{
    if ([self.delegate respondsToSelector:@selector(cell:didClickImageContent:)]) {
        [self.delegate cell:self didClickImageContent:self.message];
    }
}

- (void)refreshWithMessage:(BIMMessage *)message inConversation:(BIMConversation *)conversation sender:(id<BIMMember>)sender{
    [super refreshWithMessage:message inConversation:conversation sender:sender];
    self.imageContent.image = nil;
    self.file = (BIMFileElement *)message.element;
    
    if (self.file.localPath.length > 0) {
        NSString *localStr = self.file.localPath;
        NSString *str = [localStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        NSString *str2 = [str stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        if ([[NSFileManager defaultManager] fileExistsAtPath:str2]) {
            self.localFilePath = str2;
        } else {
            self.localFilePath = nil;
        }
    }

    if (message.msgType == BIM_MESSAGE_TYPE_FILE) {
        self.fileNameLabel.text = self.file.fileName;
        CGFloat mbSize = self.file.fileSize/1000.0/1000.0;
        CGFloat kbSize = self.file.fileSize/1000.0;
        if (mbSize > 1){
            self.fileSizeLabel.text = [NSString stringWithFormat:@"%.2f MB", mbSize];
        } else if (kbSize > 1) {
            self.fileSizeLabel.text = [NSString stringWithFormat:@"%.2f KB", kbSize];
        } else {
            self.fileSizeLabel.text = [NSString stringWithFormat:@"%lld B", self.file.fileSize];
        }
        
        [self.imageContent setImage:[kIMAGE_IN_BUNDLE_NAMED(@"icon_msg_file") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        [self setupConstraints];
    }
}

//- (CGFloat)heightForMessage:(TIMOMessage *)message inConversation:(TIMOConversation *)conversation sender:(id<TIMOConversationParticipant>)sender{
//    [self refreshWithMessage:message inConversation:conversation sender:sender];
//    
//    return CGRectGetMaxY(self.imageContent.frame) + 16;
//}

- (void)setupConstraints{
    [super setupConstraints];
    
    if (self.message.msgType ==     BIM_MESSAGE_TYPE_FILE) {
        CGFloat margin = [self margin];
        CGFloat fileImageWH = 60;
        if (self.isSelfMsg) {
            [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.portrait.mas_left).offset(-margin*2);
                if (self.referMessageLabel.text.length) {
                    make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
                }else{
                    make.top.equalTo(self.portrait).offset(margin);
                }
                make.width.height.mas_equalTo(fileImageWH);
            }];
            
            [self.fileNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.imageContent.mas_left).offset(-8);
                make.top.equalTo(self.imageContent);
                make.width.mas_lessThanOrEqualTo(160);
            }];
            [self.fileSizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(118);
                make.right.equalTo(self.fileNameLabel);
            }];
        }else{
            [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.portrait.mas_right).offset(margin*2);
                if (self.referMessageLabel.text.length) {
                    make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
                }else{
                    make.top.equalTo(self.nameLabel.mas_bottom).offset(margin*2);
                }
                make.width.height.mas_equalTo(fileImageWH);
            }];
            
            [self.fileNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageContent.mas_right).offset(8);
                make.top.equalTo(self.imageContent);
                make.width.mas_lessThanOrEqualTo(160);
            }];
            [self.fileSizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(118);
                make.left.equalTo(self.fileNameLabel);
            }];
        }
    }
}

@end
