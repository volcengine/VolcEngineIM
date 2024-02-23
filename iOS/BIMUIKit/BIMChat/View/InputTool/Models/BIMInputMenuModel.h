//
//InputMenuModel.h
//  ByteBusiness
//
//  Created by 楼澜 on 2020/4/18.
//  Copyright © 2020 loulan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BIMInputMenuType) {
    BIMInputMenuTypeAlbum = 0,
    BIMInputMenuTypeCamera,
    BIMInputMenuTypeVideoCall,
    BIMInputMenuTypeFile,
    BIMInputMenuTypeLive,
    BIMInputMenuTypeLocation,
    BIMInputMenuTypeVideoCover,
    BIMInputMenuTypeCustomMessage,
    BIMInputMenuTypeCoupon,
};


@interface BIMInputMenuModel : NSObject
@property (nonatomic, assign) BIMInputMenuType type;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *iconStr;

@end
