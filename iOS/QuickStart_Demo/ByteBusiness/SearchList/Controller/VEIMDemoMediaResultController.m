//
//  VEIMDemoMediaResultController.m
//  ByteBusiness
//
//  Created by Ding Jinyan on 2024/5/22.
//  Copyright © 2024 loulan. All rights reserved.
//

#import "VEIMDemoMediaResultController.h"
#import "VEIMDemoMediaCollectionViewCell.h"
#import "VEIMDemoSearchMessageListResultModel.h"
#import <Masonry/Masonry.h>
#import <OneKit/BTDMacros.h>
#import <imsdk-tob/BIMSDK.h>
#import <im-uikit-tob/BIMScanImage.h>
#import <im-uikit-tob/BIMUIDefine.h>
#import <im-uikit-tob/BIMToastView.h>
#import "NSArray+BTDAdditions.h"

#import <AVFoundation/AVPlayer.h>
#import <AVKit/AVPlayerViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageError.h>

@interface VEIMDemoMediaResultController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionResult;
@property (nonatomic, strong) UILabel *emptyLabel;

// 每行cell数量
@property (nonatomic, assign) NSInteger numberOfRow;

// 通用拉取方向
@property (nonatomic, assign) BIMPullDirection direction;

// 消息数据源
@property (nonatomic, strong) NSArray<BIMSearchMsgInfo *> *arrMessageResult;

// 分页锚点信息
@property (nonatomic, strong) VEIMDemoSearchMessageListResultModel *anchorMessage;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) NSInteger limit;

@end

@implementation VEIMDemoMediaResultController

- (instancetype)initWithConversationID:(NSString *)conversationID convtype:(BIMConversationType)convType msgType:(BIMMessageType)msgType direction:(BIMPullDirection)direction
{
    self = [super init];
    if (self) {
        _conversationID = conversationID;
        _convType = convType;
        _msgType = msgType;
        _numberOfRow = 4;
        _limit = _numberOfRow * 8;
        _direction = direction;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupMsgs];
}

- (void)setupViews
{
    [self.view addSubview:self.collectionResult];
    [self.view addSubview:self.emptyLabel];
}

- (void)setupUIElements
{
    self.collectionResult.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerPulled)];
}


- (void)setupMsgs
{
    
    BIMGetMessageByTypeOption *option = [self createOptionWithAnchorMessage:nil limit:self.limit messageTypeList:@[@(self.msgType)] direction:self.direction];
    @weakify(self);
    [[BIMClient sharedInstance] getLocalMessageListByType:self.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            [BIMToastView toast:error.localizedDescription];
            return;
        }
        
        BIMSearchMsgInfo *anchorInfo = [BIMSearchMsgInfo new];
        anchorInfo.message = anchorMessage;
        
        NSMutableArray<BIMSearchMsgInfo *> *searchInfoList = [NSMutableArray new];
        for (BIMMessage *msg in messages) {
            BIMSearchMsgInfo *msgInfo = [BIMSearchMsgInfo new];
            msgInfo.message = msg;
            [searchInfoList btd_addObject:msgInfo];
        }
        
        self.anchorMessage = [[VEIMDemoSearchMessageListResultModel alloc] initWithAnchorMessage:anchorInfo hasMore:hasMore searchInfoList:searchInfoList.copy];
        self.arrMessageResult = searchInfoList.copy;
        self.emptyLabel.hidden = searchInfoList.count;
        
        self.collectionResult.mj_footer.hidden = !searchInfoList.count;
        
        [self reloadCollection];
    }];
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    [self updateConstraints];
}

- (void)updateConstraints
{
    [self.collectionResult mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.safeAreaInsets.top).offset(10);
        make.bottom.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    [self.emptyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.safeAreaInsets.top).offset(190);
        make.left.right.equalTo(self.view);
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)reloadCollection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionResult reloadData];
    });
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrMessageResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VEIMDemoMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VEIMDemoMediaCollectionViewCell class]) forIndexPath:indexPath];
    BIMMessage *msg = [self.arrMessageResult btd_objectAtIndex:indexPath.item].message;
    
    if (self.msgType == BIM_MESSAGE_TYPE_IMAGE) {
        BIMImageElement *imageElement = BTD_DYNAMIC_CAST(BIMImageElement, msg.element);
        BOOL hasLocalImage = [[NSFileManager defaultManager] fileExistsAtPath:imageElement.localPath];
        if (hasLocalImage) {
            NSString *localStr = imageElement.localPath;
            NSString *str = [localStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            NSString *str2 = [str stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            if ([[NSFileManager defaultManager] fileExistsAtPath:str2]) {
                UIImage *image = [UIImage imageWithContentsOfFile:str2];
                if (image) {
                    cell.imageContent.image = image;
                }
            }
        } else {
            if (imageElement.isExpired) {
                [self refreshMediaMessage:msg completion:^(BIMError * _Nullable error) {
                    if (error) {
                        [BIMToastView toast:error.localizedDescription];
                    } else {
                        [cell.imageContent sd_setImageWithURL:[NSURL URLWithString:imageElement.originImg.url] placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if (error) {
                                [BIMToastView toast:error.localizedDescription];
                            }
                        }];
                    }
                }];
            } else {
                [cell.imageContent sd_setImageWithURL:[NSURL URLWithString:imageElement.originImg.url] placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error.code == SDWebImageErrorInvalidDownloadStatusCode) {
                        [self refreshMediaMessage:msg completion:^(BIMError * _Nullable error) {
                            if (error) {
                                [BIMToastView toast:error.localizedDescription];
                            } else {
                                BIMImageElement *imageElementV2 = BTD_DYNAMIC_CAST(BIMImageElement, msg.element);
                                [cell.imageContent sd_setImageWithURL:[NSURL URLWithString:imageElementV2.originImg.url] placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                    if (error) {
                                        [BIMToastView toast:error.localizedDescription];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
        }
    } else {
        BIMVideoElement *videoElement = BTD_DYNAMIC_CAST(BIMVideoElement, msg.element);
        cell.playBtn.hidden = NO;
        
        UIImage *img;
        if (videoElement.localPath) {
            img = [self thumbnailImageForVideo:[NSURL fileURLWithPath:videoElement.localPath] atTime:1];
        }
        
        if (img) {
            cell.imageContent.image = img;
        } else {
            [cell.imageContent sd_setImageWithURL:[NSURL URLWithString:videoElement.coverImg.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error && error.code != SDWebImageErrorInvalidURL) {
                    [BIMToastView toast:error.localizedDescription];
                }
            }];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat collectionViewWidth = collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
    CGFloat cellWidth = (collectionViewWidth - (self.numberOfRow - 1) * flowLayout.minimumInteritemSpacing) / 4.0;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BIMSearchMsgInfo *msgInfo = [self.arrMessageResult btd_objectAtIndex:indexPath.item];
    BIMMessage *message = msgInfo.message;
    VEIMDemoMediaCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (message.msgType == BIM_MESSAGE_TYPE_VIDEO) {
            [self playVideoWithMessage:message];
        } else if (message.msgType == BIM_MESSAGE_TYPE_IMAGE) {
            BIMImageElement *imageElement = BTD_DYNAMIC_CAST(BIMImageElement, message.element);
            NSURL *url = [NSURL URLWithString:imageElement.originImg.url];
            if (![NSURL URLWithString:imageElement.originImg.url]) {
                [BIMToastView toast:@"图片URL为空"];
            }
            
            BOOL hasLocalImage = [[NSFileManager defaultManager] fileExistsAtPath:imageElement.localPath];
            if (hasLocalImage && cell.imageContent.image) {
                [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:cell.imageContent.image];
            } else {
                @weakify(self);
                [BIMScanImage scanBigImageWithImageView:cell.imageContent originImage:imageElement.originImg.url secretKey:nil completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    @strongify(self);
                    if (error) {
                        [self refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
                            if (error) {
                                [BIMToastView toast:[NSString stringWithFormat:@"加载图片失败：%@",error.localizedDescription]];
                            } else {
                                [BIMScanImage scanBigImageRefreshWithImageUrl:imageElement.originImg.url completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                    if (error) {
                                        [BIMToastView toast:[NSString stringWithFormat:@"加载图片失败：%@",error.localizedDescription]];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
        }
    });
}

- (AVPlayerItem *)playItemWithFile:(BIMVideoElement *)file{
    NSURL *playURL = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:file.localPath]) {
        playURL = [NSURL fileURLWithPath:file.localPath];
    } else {
        playURL = [NSURL URLWithString:file.url];
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:playURL];
    
    return playerItem;
}

- (void)playElementWithMessage:(BIMMessage *)message
{
    AVPlayerItem *playItem = [self playItemWithFile:(BIMVideoElement *)message.element];
    if (!playItem) {
        [BIMToastView toast:@"播放链接错误，无法播放"];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:playItem];
        [self.player play];
    }
}

- (void)playVideoWithMessage:(BIMMessage *)message
{
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = self.player;
    [self presentViewController:playerVC animated:YES completion:nil];
    
    BIMVideoElement *element = BTD_DYNAMIC_CAST(BIMVideoElement, message.element);
    if (element.isExpired) {
        @weakify(self);
        [self refreshMediaMessage:message completion:^(BIMError * _Nullable error) {
            @strongify(self);
            if (error) {
                [BIMToastView toast:@"播放链接错误，无法播放"];
            } else {
                [self playElementWithMessage:message];
            }
        }];
    } else {
        [self playElementWithMessage:message];
    }
}

- (void)refreshMediaMessage:(BIMMessage *)message completion:(BIMCompletion)completion
{
    if (self.convType == BIM_CONVERSATION_TYPE_LIVE_GROUP) {
        [[BIMClient sharedInstance] refreshLiveGroupMediaMessage:message completion:completion];
    } else {
        [[BIMClient sharedInstance] refreshMediaMessage:message completion:completion];
    }
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

# pragma mark - footer refresh
- (void)footerPulled
{
    [self loadMoreMessages];
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionResult
{
    if (!_collectionResult) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        // 布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = 1.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);

        UICollectionView *collectionResult = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        collectionResult.delegate = self;
        collectionResult.dataSource = self;
        [collectionResult registerClass:[VEIMDemoMediaCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(VEIMDemoMediaCollectionViewCell.class)];
                
        _collectionResult = collectionResult;
    }
    
    return _collectionResult;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        UILabel *label = [UILabel new];
        label.text = @"无结果";
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        _emptyLabel = label;
    }
    return _emptyLabel;
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

#pragma mark - 拉消息
- (void)loadMoreMessages
{
    if (!self.anchorMessage.hasMore) {
        [self.collectionResult.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    BIMGetMessageByTypeOption *option = [self createOptionWithAnchorMessage:self.anchorMessage.anchorMessage.message limit:self.limit messageTypeList:@[@(self.msgType)] direction:self.direction];
    @weakify(self);
    [[BIMClient sharedInstance] getLocalMessageListByType:self.conversationID option:option completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
        @strongify(self);
        if (error) {
            /// TODO: error发生时的弹窗
            
            return;
        }
        
        BIMSearchMsgInfo *anchorInfo = [BIMSearchMsgInfo new];
        anchorInfo.message = anchorMessage;
        
        NSMutableArray<BIMSearchMsgInfo *> *searchInfoList = [NSMutableArray new];
        for (BIMMessage *msg in messages) {
            BIMSearchMsgInfo *msgInfo = [BIMSearchMsgInfo new];
            msgInfo.message = msg;
            [searchInfoList btd_addObject:msgInfo];
        }
        
        self.anchorMessage = [[VEIMDemoSearchMessageListResultModel alloc] initWithAnchorMessage:anchorInfo hasMore:hasMore searchInfoList:searchInfoList.copy];
        self.arrMessageResult = [self.arrMessageResult btd_arrayByAddingObjectsFromArray:searchInfoList.copy];
        
        [self reloadCollection];
    }];
    
    [self.collectionResult.mj_footer endRefreshing];
}

#pragma mark -

- (BIMGetMessageByTypeOption *)createOptionWithAnchorMessage:(BIMMessage *)message limit:(NSInteger)limit messageTypeList:(NSArray<NSNumber *> *)messageTypeList direction:(BIMPullDirection)direction
{
    BIMGetMessageByTypeOption *option = [[BIMGetMessageByTypeOption alloc] init];
    option.anchorMessage = message;
    option.limit = limit;
    option.messageTypeList = messageTypeList;
    option.direction = direction;
    
    return option;
}


@end


