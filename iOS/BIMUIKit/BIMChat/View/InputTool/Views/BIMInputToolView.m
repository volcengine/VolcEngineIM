//
//  IMDemoInputToolView.m
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/17.
//  Copyright © 2020 loulan. All rights reserved.
//

#import "BIMInputToolView.h"
#import "BIMInputMoreMenuView.h"
#import "BIMStickerKeyboard.h"
#import "BIMAudioRecorder.h"
#import "BIMUIDefine.h"
#import "BIMToastView.h"
#import "BIMUIClient.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <OneKit/ByteDanceKit.h>
#import <Masonry/Masonry.h>

#import <imsdk-tob/BIMSDK.h>

#define kMinHei 40
#define kMaxHei 88

typedef NS_ENUM(NSInteger, IMInputToolType) {
    IMInputToolTypeTextAudio = 0,
    IMInputToolTypeEmoji,
    IMInputToolTypeMore,
};

typedef NS_ENUM(NSInteger, IMTextAudioType) {
    IMTextAudioTypeText = 0,
    IMTextAudioTypeAudio,
};


@interface BIMInputToolView () <UITextViewDelegate, BIMInputMoreMenuViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TIMStickerKeyboardDelegate, BIMAudioRecorderDelegate, UIDocumentPickerDelegate>

@property (nonatomic, strong) UIView *toolBgView;
@property (nonatomic, strong) UIButton *textAudioBtn;
@property (nonatomic, strong) UIView *referBg;
@property (nonatomic, strong) UIButton *referCleanBtn;
@property (nonatomic, strong) UILabel *referMessageLabel;
@property (nonatomic, strong) UITextView *tempTextView;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) BIMInputMoreMenuView *moreMenuView;
@property (nonatomic, strong) BIMStickerKeyboard *stickerKeyboard;

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) IMInputToolType itType;
@property (nonatomic, assign) IMTextAudioType taType;

@property (nonatomic, strong) NSMutableArray *menuMAry;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *mentionUsers;
@property (nonatomic, strong) NSMutableArray <NSString *> *mentionUserRanges;

@property (nonatomic, strong) BIMAudioRecorder *audioRecorder;

@property (nonatomic, assign) BIMConversationType convType;

@end


@implementation BIMInputToolView


#pragma mark - Action

- (void)textAudioBtnChangeAction:(UIButton *)btn
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];

    if (btn && authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if(granted){
                [self switchActionMode:btn!=nil];
            }else{
                [BIMToastView toast:@"无法发送语音消息，请前往系统设置中开启麦克风权限"];
                return;
            }
         }];
    }else{
        [self switchActionMode:btn!=nil];
    }
}

- (void)switchActionMode: (BOOL)checkAuth{
    dispatch_async(dispatch_get_main_queue(), ^{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusDenied) {
            [BIMToastView toast:@"无法发送语音消息，请前往系统设置中开启麦克风权限"];
            return;
        }
        self.itType = IMInputToolTypeTextAudio;
        
        self.moreMenuView.hidden = YES;
        [self.moreMenuView removeFromSuperview];
        
        self.stickerKeyboard.hidden = YES;
        [self.stickerKeyboard removeFromSuperview];
        
        if (self.taType == IMTextAudioTypeText) {
            self.taType = IMTextAudioTypeAudio;
            
            [self.textAudioBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_text") forState:UIControlStateNormal];
            
            self.tempTextView.hidden = YES;
            self.recordBtn.hidden = NO;
            
            [self.tempTextView resignFirstResponder];
            [self makeSubViewsConstraints];
        } else if (self.taType == IMTextAudioTypeAudio) {
            self.taType = IMTextAudioTypeText;
            
            [self.textAudioBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_voice") forState:UIControlStateNormal];
            
            self.tempTextView.hidden = NO;
            self.recordBtn.hidden = YES;
            
            [self.tempTextView becomeFirstResponder];
        }
    });
    
}

- (void)showEmojiAction:(UIButton *)btn
{
    self.taType = IMTextAudioTypeText;

    [self.textAudioBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_voice") forState:UIControlStateNormal];

    self.tempTextView.hidden = NO;
    self.recordBtn.hidden = YES;

    [self.tempTextView resignFirstResponder];

    self.itType = IMInputToolTypeEmoji;

    self.moreMenuView.hidden = YES;
    [self.moreMenuView removeFromSuperview];

    self.stickerKeyboard.hidden = NO;
    [self addSubview:self.stickerKeyboard];

    [self makeSubViewsConstraints];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewDidChange:keyboardFrame:)]) {
        [self.delegate inputToolViewDidChange:self.frame keyboardFrame:self.keyboardFrame];
    }
}

- (void)showMoreMenuAction:(UIButton *)btn
{
    [self.tempTextView resignFirstResponder];

    self.itType = IMInputToolTypeMore;

    self.stickerKeyboard.hidden = YES;
    [self.stickerKeyboard removeFromSuperview];

    self.moreMenuView.hidden = NO;
    [self addSubview:self.moreMenuView];

    [self makeSubViewsConstraints];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewDidChange:keyboardFrame:)]) {
        [self.delegate inputToolViewDidChange:self.frame keyboardFrame:self.keyboardFrame];
    }
}

- (void)revertToTheOriginalType
{
    self.itType = IMInputToolTypeTextAudio;
    [self.tempTextView resignFirstResponder];

    self.stickerKeyboard.hidden = YES;
    [self.stickerKeyboard removeFromSuperview];

    [self makeSubViewsConstraints];
}

- (void)setDraft:(NSString *)draft{
    self.tempTextView.text = draft;
}

- (NSString *)currentText{
    return self.tempTextView.text;
}

/// 触发@功能
- (void)showMentionedAction
{
    if (self.isBroadCast) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(inputToolDidTriggerMention)]) {
        [self.delegate inputToolDidTriggerMention];
    }
}

- (void)addMentionUser:(NSNumber *)userID{
    NSString *name = [BIMUIClient sharedInstance].userProvider(userID.longLongValue).nickName;
    if (userID.longLongValue > 0 && name.length) {
        NSMutableString *str = [self.tempTextView.text mutableCopy];
        NSInteger location = str.length+1;
        NSString *addingName = [NSString stringWithFormat:@"@%@",name];
        NSInteger length = addingName.length;
        NSRange range = NSMakeRange(location, length);
        NSString *rangeStr = NSStringFromRange(range);
        if (kValidStr(rangeStr)) {
            [str appendString:[NSString stringWithFormat:@" %@ ",addingName]];
            self.tempTextView.text = str;
            [self.mentionUsers addObject:userID];
            [self.mentionUserRanges addObject:rangeStr];
        }
    }
}

- (void)checkDeletingMentionedUsers: (NSRange)range{
    if (self.mentionUsers.count) {
        NSMutableArray *deleteUsers = [NSMutableArray array];
        for (int i = self.mentionUsers.count-1; i>=0; i--) {
            NSString *rangeStr = self.mentionUserRanges[i];
            NSRange emRange = NSRangeFromString(rangeStr);
            NSInteger deletingLeft = range.location;
            NSInteger deletingRight = range.location + range.length - 1;
            
            NSInteger emLeft = emRange.location;
            NSInteger emRight = emRange.location + emRange.length - 1;
            if (deletingLeft < emLeft) {
                if (deletingRight < emLeft) {
                    //这个range需要把location减掉对应的length
                    emRange.location -= range.length;
                    NSString *newRangeStr = NSStringFromRange(emRange);
                    [self.mentionUserRanges replaceObjectAtIndex:i withObject:newRangeStr];
                }else{//删除范围涵盖了这个range
                    [deleteUsers addObject:@(i)];
                }
            }else{
                if (deletingLeft > emRight) {//删除范围在遍历范围右边，可以不用继续遍历了
                    break;
                }else{
                    [deleteUsers addObject:@(i)];
                }
                
            }
        }
        
        for (NSNumber *nI in deleteUsers) {
            int removeIndex = nI.intValue;
            if (removeIndex>=0 && removeIndex < self.mentionUsers.count) {
                [self.mentionUsers removeObjectAtIndex:removeIndex];
                [self.mentionUserRanges removeObjectAtIndex:removeIndex];
            }
        }
    }
}

- (void)isAddingMentionUsers: (NSRange)range{
    for (int i = self.mentionUsers.count-1; i>=0; i--) {
        NSString *rangeStr = self.mentionUserRanges[i];
        NSRange emRange = NSRangeFromString(rangeStr);
        NSInteger emLeft = emRange.location;
        NSInteger emRight = emRange.location + emRange.length - 1;
        if (range.location > emRight) {
            break;
        }
        if (range.location-1>=emLeft && range.location-1 <= emRight) {
            if (i>=0 && i < self.mentionUsers.count) {
                [self.mentionUsers removeObjectAtIndex:i];
                [self.mentionUserRanges removeObjectAtIndex:i];
            }
            break;
        }else{
            if (range.length == 0) {
                emRange.location += 1;
            }else{
                emRange.location += range.length;
            }
            NSString *newRange = NSStringFromRange(emRange);
            [self.mentionUserRanges replaceObjectAtIndex:i withObject:newRange];
        }
    }
}

- (void)inputText:(NSString *)text{
    NSMutableString *mStr = [self.tempTextView.text mutableCopy];
    [mStr insertString:text atIndex:self.tempTextView.selectedRange.location];
    NSRange range = self.tempTextView.selectedRange;
    self.tempTextView.text = mStr;
    [self.tempTextView setSelectedRange:NSMakeRange(range.location + text.length, range.length)];
}


- (NSMutableArray<NSNumber *> *)mentionUsers{
    if (!_mentionUsers) {
        _mentionUsers = [NSMutableArray array];
    }
    return _mentionUsers;
}

- (NSMutableArray <NSString *>*)mentionUserRanges{
    if (!_mentionUserRanges) {
        _mentionUserRanges = [NSMutableArray array];
    }
    return _mentionUserRanges;
}

- (void)setReferMessage:(BIMMessage *)referMessage
{
    _referMessage = referMessage;
    
    NSMutableString *hint = [NSMutableString string];
    NSString *userName = [BIMUIClient sharedInstance].userProvider(referMessage.senderUID).nickName;
    [hint appendFormat:@"%@: ",userName];
    if (referMessage.isRecalled) {
        [hint appendString:@"该消息已撤回"];
    }else{
        switch (referMessage.msgType) {
            case BIM_MESSAGE_TYPE_TEXT: {
                BIMTextElement *element = (BIMTextElement *)referMessage.element;
                [hint appendString:element.text?: @"[文本]"];
            } break;
            case BIM_MESSAGE_TYPE_IMAGE: {
                [hint appendString:@"[图片]"];
            } break;
            case BIM_MESSAGE_TYPE_VIDEO: {
                [hint appendString:@"[视频]"];
            } break;
            case BIM_MESSAGE_TYPE_AUDIO: {
                [hint appendString:@"[语音]"];
            } break;
            case BIM_MESSAGE_TYPE_FILE: {
                [hint appendString:@"[文件]"];
            } break;
            case BIM_MESSAGE_TYPE_CUSTOM: {
                [hint appendString:@"[自定义消息]"];
            } break;
            default: {
                [hint appendString:@"[其它]"];
            } break;
        }
    }

    self.referMessageHint = hint;
    
    [self refreshUI];
    [self.tempTextView becomeFirstResponder];
}

- (void)refreshUI
{
    if (self.taType == IMTextAudioTypeText) {
        self.referBg.hidden = !self.referMessage;
        self.referMessageLabel.text = self.referMessageHint;
    } else {
        self.referBg.hidden = YES;
    }
    [self makeSubViewsConstraints:self.tempTextView.btd_height isNormal:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewDidChange:keyboardFrame:)]) {
        [self.delegate inputToolViewDidChange:self.frame keyboardFrame:self.keyboardFrame];
    }
}

- (void)enableInput
{
    self.textAudioBtn.userInteractionEnabled = YES;
    self.textAudioBtn.alpha = 1;

    self.tempTextView.userInteractionEnabled = YES;
    self.tempTextView.text = @"";
    self.tempTextView.alpha = 1;

    self.emojiBtn.userInteractionEnabled = YES;
    self.emojiBtn.alpha = 1;
    self.addBtn.userInteractionEnabled = YES;
    self.addBtn.alpha = 1;
    self.recordBtn.userInteractionEnabled = YES;
    self.recordBtn.alpha = 1;
    self.stickerKeyboard.userInteractionEnabled = YES;
    self.stickerKeyboard.alpha = 1;
}

- (void)disableInputWithReason:(NSString *)reason
{
    self.textAudioBtn.userInteractionEnabled = NO;
    self.textAudioBtn.alpha = 0.5;

    self.tempTextView.userInteractionEnabled = NO;
    self.tempTextView.text = reason;
    self.tempTextView.alpha = 0.5;

    self.emojiBtn.userInteractionEnabled = NO;
    self.emojiBtn.alpha = 0.5;
    self.addBtn.userInteractionEnabled = NO;
    self.addBtn.alpha = 0.5;
    self.recordBtn.userInteractionEnabled = NO;
    self.recordBtn.alpha = 0.5;
    self.stickerKeyboard.userInteractionEnabled = NO;
    self.stickerKeyboard.alpha = 0.5;
}

- (void)referCleanClicked: (id)sender{
    [self setReferMessage:nil];
}

#pragma mark - KVO

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self removeObserver];
}


#pragma mark - 键盘的通知方法

static CGFloat textHei = 0;

- (void)keyboardWillShow:(NSNotification *)notify
{
    self.taType = IMTextAudioTypeText;
//    [self textAudioBtnChangeAction:nil];
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    CGRect textViewFrame = self.tempTextView.frame;
    CGSize textSize = [self.tempTextView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), CGFLOAT_MAX)];
    textHei = MAX(kMinHei, MIN(kMaxHei, textSize.height));

    self.keyboardFrame = CGRectZero;
    [self textViewDidChange:self.tempTextView];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify
{
    self.itType = IMInputToolTypeTextAudio;

    self.moreMenuView.hidden = YES;
    [self.moreMenuView removeFromSuperview];

    self.stickerKeyboard.hidden = YES;
    [self.stickerKeyboard removeFromSuperview];


    self.keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self textViewDidChange:self.tempTextView];
}


#pragma mark - Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect textViewFrame = self.tempTextView.frame;
    CGSize textSize = [self.tempTextView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), CGFLOAT_MAX)];

    CGFloat hei = MAX(kMinHei, MIN(kMaxHei, textSize.height));

    [self makeSubViewsConstraints:hei isNormal:NO];

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewDidChange:keyboardFrame:)]) {
        [self.delegate inputToolViewDidChange:self.frame keyboardFrame:self.keyboardFrame];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (([text isEqualToString:@"\n"] && self.tempTextView.text.length)) {
        [self sendTextMessage];

        return NO;
    }

    if ([text isEqualToString:@"@"]) {
        [self.tempTextView resignFirstResponder];
        [self showMentionedAction];
        return NO;
    }
    
    if ([text isEqualToString:@""] && range.length != 0) {//删除
        [self checkDeletingMentionedUsers:range];
    }else{
        [self isAddingMentionUsers:range];
    }

    return YES;
}

- (void)becomeFirstResponder{
    [self.tempTextView becomeFirstResponder];
}


#pragma mark - BIMInputMoreMenuViewDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BIMInputMenuModel *model = self.menuMAry[indexPath.row];

    switch (model.type) {
        case BIMInputMenuTypeAlbum: {
            PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];

            if ((photoStatus == PHAuthorizationStatusRestricted || photoStatus == PHAuthorizationStatusDenied)) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self showPhotoLibraraOrCamera:NO];
                    } else {
                        [BIMToastView toast:@"无法拍摄照片并发送出去，请前往系统设置中开启相机权限"];
                    }
                }];
            } else {
                [self showPhotoLibraraOrCamera:NO];
            }
        } break;

        case BIMInputMenuTypeCamera: {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]; //读取设备授权状态

            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            [self showPhotoLibraraOrCamera:YES];
                        } else {
                            [BIMToastView toast:@"无法拍摄照片并发送出去，请前往系统设置中开启相机权限"];
                        }
                    });
                }];
            } else {
                [self showPhotoLibraraOrCamera:YES];
            }
        } break;


        case BIMInputMenuTypeFile: {
            //TODO: file
            UIDocumentPickerViewController *pickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[ @"public.data" ] inMode:UIDocumentPickerModeOpen];
            pickerVC.delegate = self;
            pickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.btd_viewController presentViewController:pickerVC animated:YES completion:nil];
        } break;

        case BIMInputMenuTypeCustomMessage: {
            NSDictionary *content = @{
                @"type" : @1,
                @"link" : @"https://www.volcengine.com/",
                @"text" : @"欢迎体验即时通讯IM demo"
            };
            BIMMessage *sendMsg = [[BIMClient sharedInstance] createCustomMessage:content];
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewSendMessage:)]) {
                [self.delegate inputToolViewSendMessage:sendMsg];
            }
        } break;

        default:
            break;
    }
}

- (void)sendLocationMessage
{

}

- (void)showPhotoLibraraOrCamera:(BOOL)isCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    picker.allowsEditing = NO;
    picker.edgesForExtendedLayout = UIRectEdgeNone;


    if (isCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (self.isBroadCast) {
                picker.mediaTypes = @[ (NSString *)kUTTypeImage ];
            } else {
                picker.mediaTypes = @[ (NSString *)kUTTypeMovie, (NSString *)kUTTypeImage ];
            }
        }
    }

    [[BTDResponder topViewController] presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    BIMMessage *sendMsg = nil;
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        sendMsg = [[BIMClient sharedInstance] createVideoMessage:url.absoluteString];
    } else {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", (int)([[NSDate date] timeIntervalSince1970] * 1000)]];
        [UIImageJPEGRepresentation(image, 1) writeToFile:path atomically:YES];
        sendMsg = [[BIMClient sharedInstance] createImageMessage:path];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewSendMessage:)]) {
        [self.delegate inputToolViewSendMessage:sendMsg];
    }
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(nonnull NSArray<NSURL *> *)urls
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self sendMessageFileWithUrl:urls.firstObject];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self sendMessageFileWithUrl:url];
}

- (void)sendMessageFileWithUrl:(NSURL *)originUrl
{
    BOOL authozied = [originUrl startAccessingSecurityScopedResource];
    if (!authozied) {
        return;
    }

    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    [fileCoordinator coordinateReadingItemAtURL:originUrl options:0 error:nil byAccessor:^(NSURL *_Nonnull urlCoordinator) {
        NSString *strUrl = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID, urlCoordinator.pathExtension]];
        [NSFileManager.defaultManager removeItemAtPath:strUrl error:nil];
        NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet]];

        BOOL ret = [NSFileManager.defaultManager copyItemAtPath:urlCoordinator.path toPath:strUrl error:nil];
        if (!ret) {
            return;
        }

        BIMMessage *sendMsg = [[BIMClient sharedInstance] createFileMessage:url.absoluteString fileName:urlCoordinator.lastPathComponent];
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewSendMessage:)]) {
            [self.delegate inputToolViewSendMessage:sendMsg];
        }
    }];
}

#pragma mark - TIMStickerKeyboardDelegate

- (void)stickerKeyboard:(BIMStickerKeyboard *)stickerKeyboard didClickEmoji:(BIMEmoji *)emoji
{
    if (!emoji) {
        return;
    }

    UIImage *emojiImage = [UIImage imageNamed:[@"TIMOEmoji.bundle" stringByAppendingPathComponent:emoji.imageName]];
    if (!emojiImage) {
        return;
    }

    NSRange selectedRange = self.tempTextView.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"%@", emoji.emojiDes];
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];
    [emojiAttributedString addAttributes:@{NSFontAttributeName : self.tempTextView.font} range:NSMakeRange(0, emojiAttributedString.string.length)];

#warning mark !!! 如果在输入框中显示表情，需要在发送的时候转换成文字，之后做
    //    [[TIMStickerDataManager sharedInstance] replaceEmojiForAttributedString:emojiAttributedString font:self.tempTextView.font];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.tempTextView.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.tempTextView.attributedText = attributedText;
    self.tempTextView.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);
    [self isAddingMentionUsers:NSMakeRange(selectedRange.location, emojiAttributedString.length)];
}

- (void)stickerKeyboardDidClickDeleteButton:(BIMStickerKeyboard *)stickerKeyboard
{
    NSRange selectedRange = self.tempTextView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.tempTextView.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.tempTextView.attributedText = attributedText;
        self.tempTextView.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        NSUInteger deleteCharactersCount = 1;

        // 下面这段正则匹配是用来匹配文本中的所有系统自带的 emoji 表情。
        NSString *emojiPattern1 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900-\\U0001F9FF]";
        NSString *emojiPattern2 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF]\\uFE0F";
        NSString *emojiPattern3 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF][\\U0001F3FB-\\U0001F3FF]";
        NSString *emojiPattern4 = @"[\\rU0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]";
        NSString *pattern = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@", emojiPattern4, emojiPattern3, emojiPattern2, emojiPattern1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:attributedText.string options:kNilOptions range:NSMakeRange(0, attributedText.string.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.range.location + match.range.length == selectedRange.location) {
                deleteCharactersCount = match.range.length;
                break;
            }
        }

        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - deleteCharactersCount, deleteCharactersCount)];
        self.tempTextView.attributedText = attributedText;
        self.tempTextView.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
    }
}

- (void)stickerKeyboardDidClickSendButton:(BIMStickerKeyboard *)stickerKeyboard
{
    NSString *content = [self currentlyComposedMessageText];
    if (content.length > 0) {
        [self sendTextMessage];
    }
}

- (NSString *)currentlyComposedMessageText
{
    //  auto-accept any auto-correct suggestions
    [self.tempTextView.inputDelegate selectionWillChange:self.tempTextView];
    [self.tempTextView.inputDelegate selectionDidChange:self.tempTextView];

    return [self.tempTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)sendTextMessage
{
    NSMutableArray *mentionUids;
    if (self.mentionUsers.count) {
        mentionUids = [NSMutableArray array];
        for (NSNumber *userID in self.mentionUsers) {
            [mentionUids addObject:userID];
        }
    }
    
   BIMMessage *sendMsg = [[BIMClient sharedInstance] createTextAtMessage:self.tempTextView.text atUserList:mentionUids refMessage:self.referMessage hint:self.referMessageHint];

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewSendMessage:)]) {
        [self.delegate inputToolViewSendMessage:sendMsg];
    }

    self.tempTextView.text = @"";
    self.referMessage = nil;
    self.referMessageHint = nil;

    CGRect textViewFrame = self.tempTextView.frame;
    CGSize textSize = [self.tempTextView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), CGFLOAT_MAX)];

    CGFloat hei = MAX(kMinHei, MIN(kMaxHei, textSize.height));

    [self makeSubViewsConstraints:hei isNormal:NO];
}


#pragma mark - 录音

- (void)onRecordStart
{
    NSLog(@"onRecordStart");
    [self.recordBtn setTitle:@"正在录音，手指上移取消" forState:UIControlStateNormal];

    [self.audioRecorder startRecord];
}

- (void)onRecordStop
{
    NSLog(@"onRecordStop");
    [self.audioRecorder stopRecord];
    [self.recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
}

- (void)onRecordPreCancel
{
    NSLog(@"onRecordPreCancel");
    [self.recordBtn setTitle:@"松手取消" forState:UIControlStateNormal];
}

- (void)onRecordBack
{
    NSLog(@"onRecordBack");
    [self.recordBtn setTitle:@"正在录音，手指上移取消" forState:UIControlStateNormal];
}

- (void)onRecordCancel
{
    NSLog(@"onRecordCancel");
    [BIMToastView toast:@"已取消"];
    [self.recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];

    [self.audioRecorder cancelRecord];
}


#pragma mark - BIMAudioRecorderDelegate

- (void)failRecord
{
    [BIMToastView toast:@"录音时间太短，录音失败"];
}

- (void)successRecord
{
    [BIMToastView toast:@"录音成功"];
}

- (void)beginConvert
{
    NSLog(@"开始录音");
}

- (void)audioRecorderDidFinishRecordingWithPath:(NSString *)fileName recordTime:(NSInteger)recordTime
{
    NSLog(@"录制完成---%@, 时长---%ld", fileName, (long)recordTime);
    
    BIMMessage *sendMsg = [[BIMClient sharedInstance] createAudioMessage:fileName];

    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolViewSendMessage:)]) {
        [self.delegate inputToolViewSendMessage:sendMsg];
    }
}


- (NSMutableArray *)menuMAry
{
    if (!_menuMAry) {
        _menuMAry = [NSMutableArray array];
        
        // 直播群只保留“自定义消息”
        if (self.convType != BIM_CONVERSATION_TYPE_LIVE_GROUP) {
            BIMInputMenuModel *phoneModel = [[BIMInputMenuModel alloc] init];
            phoneModel.titleStr = @"照片";
            phoneModel.iconStr = @"icon_photo";
            phoneModel.type = BIMInputMenuTypeAlbum;
            [_menuMAry btd_addObject:phoneModel];
            
            BIMInputMenuModel *cameraModel = [[BIMInputMenuModel alloc] init];
            cameraModel.titleStr = @"拍摄";
            cameraModel.iconStr = @"icon_camera";
            cameraModel.type = BIMInputMenuTypeCamera;
            [_menuMAry btd_addObject:cameraModel];
            
            BIMInputMenuModel *fileModel = [[BIMInputMenuModel alloc] init];
            fileModel.titleStr = @"文件";
            fileModel.iconStr = @"icon_send_file";
            fileModel.type = BIMInputMenuTypeFile;
            [_menuMAry btd_addObject:fileModel];
        }
        BIMInputMenuModel *customCoverModel = [[BIMInputMenuModel alloc] init];
        customCoverModel.titleStr = @"自定义消息";
        customCoverModel.iconStr = @"icon_photo";
        customCoverModel.type = BIMInputMenuTypeCustomMessage;
        [_menuMAry btd_addObject:customCoverModel];
    }

    return _menuMAry;
}


- (void)setIsBroadCast:(BOOL)isBroadCast
{
    _isBroadCast = isBroadCast;

    [self.menuMAry removeLastObject];
    self.moreMenuView.listMAry = [NSMutableArray arrayWithArray:self.menuMAry];
}


#pragma mark - LifeCycle

- (instancetype)initWithConvType:(BIMConversationType)type
{
    if (self = [super init]) {
        self.convType = type;
        [self addSubview:self.toolBgView];
        [self addSubview:self.referBg];
        [self.referBg addSubview:self.referCleanBtn];
        [self.referBg addSubview:self.referMessageLabel];
        [self.toolBgView addSubview:self.textAudioBtn];
        [self.toolBgView addSubview:self.tempTextView];
        [self.toolBgView addSubview:self.emojiBtn];
        [self.toolBgView addSubview:self.addBtn];
        [self.toolBgView addSubview:self.recordBtn];
        [self addSubview:self.moreMenuView];
        [self addSubview:self.stickerKeyboard];

        self.moreMenuView.listMAry = [NSMutableArray arrayWithArray:self.menuMAry];

        [self makeSubViewsConstraints];

        [self addObserver];
    }

    return self;
}


#pragma mark - Getter And Setter

- (UIView *)toolBgView
{
    if (!_toolBgView) {
        _toolBgView = [[UIView alloc] init];
        _toolBgView.backgroundColor = [UIColor whiteColor];
    }

    return _toolBgView;
}

- (UIView *)referBg{
    if (!_referBg) {
        _referBg = [UIView new];
        _referBg.hidden = YES;
        _referBg.backgroundColor = kIM_View_Background_Color;
    }
    return _referBg;
}

- (UIButton *)referCleanBtn{
    if (!_referCleanBtn) {
        _referCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_referCleanBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_close") forState:UIControlStateNormal];
        [_referCleanBtn addTarget:self action:@selector(referCleanClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _referCleanBtn;
}

- (UIButton *)textAudioBtn
{
    if (!_textAudioBtn) {
        _textAudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.textAudioBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_voice") forState:UIControlStateNormal];
        [_textAudioBtn addTarget:self action:@selector(textAudioBtnChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _textAudioBtn;
}

- (UITextView *)tempTextView
{
    if (!_tempTextView) {
        _tempTextView = [[UITextView alloc] init];
        _tempTextView.textColor = kIM_Main_Color;
        _tempTextView.font = kFont(16);
        _tempTextView.backgroundColor = kIM_View_Background_Color;
        _tempTextView.delegate = self;
        _tempTextView.scrollEnabled = YES;
        _tempTextView.returnKeyType = UIReturnKeySend;

        kViewBorderRadius(_tempTextView, 4, 1, kIM_View_Background_Color);
    }

    return _tempTextView;
}

- (UILabel *)referMessageLabel
{
    if (!_referMessageLabel) {
        _referMessageLabel = [[UILabel alloc] init];
        _referMessageLabel.textColor = [UIColor btd_colorWithRGB:0x999999];
        _referMessageLabel.font = kFont(12);
        _referMessageLabel.backgroundColor = kIM_View_Background_Color;
    }

    return _referMessageLabel;
}

- (UIButton *)emojiBtn
{
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setImage:kIMAGE_IN_BUNDLE_NAMED(@"icon_emoji") forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(showEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _emojiBtn;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:kIMAGE_IN_BUNDLE_NAMED(self.convType == BIM_CONVERSATION_TYPE_LIVE_GROUP ? @"icon_huoshan" : @"icon_add") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(showMoreMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _addBtn;
}

- (UIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:kIM_Main_Color forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = kBoldFont(16);
        _recordBtn.hidden = YES;

        [_recordBtn addTarget:self action:@selector(onRecordStart) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(onRecordStop) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(onRecordCancel) forControlEvents:UIControlEventTouchUpOutside];
        [_recordBtn addTarget:self action:@selector(onRecordPreCancel) forControlEvents:UIControlEventTouchDragExit];
        [_recordBtn addTarget:self action:@selector(onRecordBack) forControlEvents:UIControlEventTouchDragEnter];

        kViewBorderRadius(_recordBtn, 4, 0.5, kIM_Line_Color);
    }

    return _recordBtn;
}

- (BIMInputMoreMenuView *)moreMenuView
{
    if (!_moreMenuView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowlayout.itemSize = CGSizeMake(64, 84);
        flowlayout.minimumInteritemSpacing = 12;
        flowlayout.minimumLineSpacing = 20;
        flowlayout.sectionInset = UIEdgeInsetsMake(20, 24, 0, 24);

        _moreMenuView = [[BIMInputMoreMenuView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50) collectionViewLayout:flowlayout];
        _moreMenuView.hidden = YES;
        _moreMenuView.menuDelegate = self;
    }

    return _moreMenuView;
}

- (BIMStickerKeyboard *)stickerKeyboard
{
    if (!_stickerKeyboard) {
        _stickerKeyboard = [[BIMStickerKeyboard alloc] init];
        _stickerKeyboard.delegate = self;
        _stickerKeyboard.hidden = YES;
    }
    return _stickerKeyboard;
}

- (BIMAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        _audioRecorder = [[BIMAudioRecorder alloc] initWithDelegate:self];
    }

    return _audioRecorder;
}


#pragma mark - 约束布局

- (void)makeSubViewsConstraints
{
    [self makeSubViewsConstraints:kMinHei isNormal:YES];
}

- (void)makeSubViewsConstraints:(CGFloat)textViewHei isNormal:(BOOL)isNormal
{
    [self.referBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textAudioBtn.mas_right).offset(12);
        make.right.mas_equalTo(self.tempTextView);
        make.top.mas_equalTo(8);
    }];
    [self.referMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.referCleanBtn.mas_right).offset(16);
        make.top.mas_equalTo(8);
        make.right.mas_lessThanOrEqualTo(-8);
        make.bottom.mas_equalTo(-8);
    }];
    [self.referCleanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(12);
    }];

    [self.toolBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (self.referBg.hidden) {
            make.top.mas_equalTo(0);
        } else {
            make.top.equalTo(self.referBg.mas_bottom);
        }
        if (self.itType == IMInputToolTypeMore) {
            make.bottom.equalTo(self.moreMenuView.mas_top);
        } else if (self.itType == IMInputToolTypeEmoji) {
            make.bottom.equalTo(self.stickerKeyboard.mas_top);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];

    [self.textAudioBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.width.height.mas_equalTo(self.convType == BIM_CONVERSATION_TYPE_LIVE_GROUP ? 0 : 24);
        make.bottom.mas_equalTo(-16);
    }];

    if (self.taType == IMTextAudioTypeText) {
        [self.tempTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textAudioBtn.mas_right).offset(12);
            make.bottom.mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(textViewHei);
            make.right.equalTo(self.emojiBtn.mas_left).offset(-8);
        }];
    } else if (self.taType == IMTextAudioTypeAudio) {
        [self.recordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textAudioBtn.mas_right).offset(12);
            make.bottom.mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(kMinHei);
            make.right.equalTo(self.emojiBtn.mas_left).offset(-16);
        }];
    }

    [self.emojiBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.taType == IMTextAudioTypeText) {
            make.left.equalTo(self.tempTextView.mas_right).offset(12);
        } else if (self.taType == IMTextAudioTypeAudio) {
            make.left.equalTo(self.recordBtn.mas_right).offset(12);
        }

        make.width.height.mas_equalTo(24);
        make.bottom.mas_equalTo(-16);
    }];

    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emojiBtn.mas_right).offset(16);
        make.width.height.mas_equalTo(24);
        make.bottom.mas_equalTo(-16);
        make.right.mas_equalTo(-16);
    }];

    if (self.itType == IMInputToolTypeMore) {
        [self.moreMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolBgView.mas_bottom);
            make.height.mas_equalTo(self.moreMenuView.contentSize.height + 10);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    } else if (self.itType == IMInputToolTypeEmoji) {
        [self.stickerKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolBgView.mas_bottom);
            make.height.mas_equalTo([self.stickerKeyboard heightThatFits]);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [self layoutIfNeeded];
    
}

@end
