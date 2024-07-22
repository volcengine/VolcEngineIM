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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [[BIMMessageProgressManager sharedInstance] addDelegate:self];
    }
    
    return self;
}

- (void)setupUIElemets{
    [super setupUIElemets];
    
//    self.imageBg = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:self.imageBg];
//    self.imageBg.layer.cornerRadius = 8;
//    self.imageBg.backgroundColor = [UIColor whiteColor];
    
    self.imageContent = [UIImageView new];
    [self.contentView addSubview:self.imageContent];
    
    self.progressView = [[BIMProgressView alloc] initWithTrackWidth:2];
    self.progressView.circleColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self.progressView setProgress:0];
    [self.contentView addSubview:self.progressView];
    self.progressView.hidden = YES;
    
    self.cancelBtn = [UIButton new];
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_close") forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.hidden = YES;
    
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
    self.file = (BIMFileElement *)message.element;
    
    self.cancelBtn.hidden = message.msgStatus != BIM_MESSAGE_STATUS_SENDING_FILE_PARTS;
    self.progressView.hidden = self.cancelBtn.hidden;
    if (!self.progressView.hidden) {
        self.progressView.progress = (CGFloat)self.file.progress / 100.0;
    }
    
    if (self.file.localPath.length > 0) {
        NSString *localStr = self.file.localPath;
        NSString *str = [localStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        NSString *str2 = [str stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        if ([[NSFileManager defaultManager] fileExistsAtPath:str2]) {
            if (![self.localFilePath isEqualToString:str2]) {
                self.imageContent.image = nil;
                self.localFilePath = str2;
            }
        } else {
            self.localFilePath = nil;
            self.imageContent.image = nil;
        }
    }

    if (message.msgType == BIM_MESSAGE_TYPE_FILE) {
        self.fileNameLabel.text = self.file.fileName;
        self.fileSizeLabel.text = [self convertByteSize:self.file.fileSize];
        
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
    
    if (self.message.msgType == BIM_MESSAGE_TYPE_FILE) {
        CGFloat margin = [self margin];
        CGFloat fileImageWH = 60;
        if (self.isSelfMsg) {
            [self.imageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.portrait.mas_left).offset(-margin*2);
                if (self.referMessageLabel.text.length) {
                    make.top.equalTo(self.referMessageLabel.mas_bottom).offset(margin);
                } else {
                    make.top.equalTo(self.portrait).offset(margin);
                }
                make.width.height.mas_equalTo(fileImageWH);
            }];
            
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(30);
                make.right.equalTo(self.chatBg.mas_left).offset(-8);
                make.centerY.mas_equalTo(self.chatBg);
            }];
            
            [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(20);
                make.centerY.mas_equalTo(self.progressView);
                make.centerX.mas_equalTo(self.progressView);
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
        } else {
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

- (NSString *)fileSize
{
    if (!_fileSize) {
        NSString *fileSize = [self convertByteSize:self.file.fileSize];
        _fileSize = fileSize;
    }
    
    return _fileSize;
}

- (NSString *)convertByteSize:(unsigned long long)byteSize
{
    CGFloat mbSize = byteSize/1000.0/1000.0;
    CGFloat kbSize = byteSize/1000.0;
    
    NSString *formattedFileSize;
    if (mbSize > 1){
        formattedFileSize = [NSString stringWithFormat:@"%.2f MB",mbSize];
    } else if (kbSize > 1) {
        formattedFileSize = [NSString stringWithFormat:@"%.2f KB",kbSize];
    } else {
        formattedFileSize = [NSString stringWithFormat:@"%llu B", byteSize];
    }
    
    return formattedFileSize;
}

- (void)cancelBtnDidClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cell:didClickCancelBtnWithMessage:)]) {
        [self.delegate cell:self didClickCancelBtnWithMessage:self.message];
    }
}

#pragma mark - BIMMessageProgressManagerDelegate
- (void)onUploadProgress:(NSString *)msgID progress:(int)progress
{
    if ([msgID isEqualToString:self.message.uuid]) {
        [self refreshWithMessage:self.message inConversation:self.converstaion sender:self.sender];
    }
}

@end
