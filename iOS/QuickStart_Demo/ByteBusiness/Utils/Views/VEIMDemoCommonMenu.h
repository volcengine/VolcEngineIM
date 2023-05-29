//
//  IM_ListView.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/7.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VEIMDemoSelectHandler)(NSInteger index);


@interface VEIMDemoCommonMenuItemModel : NSObject

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *imgStr;

@end


@interface VEIMDemoCommonMenu : UIView

- (instancetype)initWithListArray:(NSArray<VEIMDemoCommonMenuItemModel *> *)listAry selectBlock:(VEIMDemoSelectHandler)selectBlock;

- (void)show;

@end
