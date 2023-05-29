//
//FileChatCell.h
//
//
//  Created by Weibai on 2022/11/10.
//

#import "BIMBaseChatCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BIMFileChatCell, BIMFileElement;

@protocol BIMFileChatCellDelegate <BIMBaseChatCellDelegate>

- (void)cell:(BIMFileChatCell *)cell didClickImageContent: (BIMMessage *)message;

@end

@interface BIMFileChatCell : BIMBaseChatCell

@property (nonatomic, assign) id <BIMFileChatCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageContent;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;

@property (nonatomic, strong) NSString *localFilePath;



@end

NS_ASSUME_NONNULL_END
