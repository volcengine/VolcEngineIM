//
//  BDIMDebugDatabaseDebugMenuController.m
//  ByteBusiness
//
//  Created by Weibai on 2022/10/12.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "BDIMDebugDatabaseController.h"
#import "BDIMDebugBaseModel.h"
#import "BDIMDebugToast.h"
//#import <imsdk-tob/NSFileManager+TIMAppFileManager.h>
//
//#import <imsdk-tob/TIMCoreBridgeManager.h>
//#import <imsdk-tob/TIMOClient.h>

@interface BDIMDebugDatabaseController ()

@end

@implementation BDIMDebugDatabaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)prepareData{
    [super prepareData];
//    NSString *strCipherKey = TIM_SAFE_STR(TIMOClient.sharedInstance.storeCipherKey);
//    BOOL isEncrypted = NO;
//    if (strCipherKey.length) {
//        isEncrypted = YES;
//    }
//    long long aidi = [TIMOClient sharedInstance].currentUserID;
//
//        NSString *userFolder = [[NSFileManager defaultManager] tim_chatFileFolderForUser:aidi];
//        NSString *dbPath;
//        if (!isEncrypted) {
//            dbPath = [userFolder stringByAppendingPathComponent:@"db.sqlite"];
//        }else{
//            dbPath = [userFolder stringByAppendingPathComponent:@"db.encrypted.sqlite"];
//        }
//    
//    [self.models addObject:[BDIMDebugBaseModel modelWithTitle:[NSString stringWithFormat:@"数据库（%@）",isEncrypted?@"加密":@"未加密"] description:@"点击复制数据库地址" enable:YES click:^{
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = dbPath;
//        [BDIMDebugToast showToast:@"数据库地址已复制"];
//    }]];
    
    //数据库信息
    
//    [self.models addObject:[BDIMDebugBaseModel modelWithTitle:@"数据库信息" description:@"点击复制数据库地址" enable:YES click:^{
//
//        long long aidi = [TIMOClient sharedInstance].currentUserID;
//        if (aidi > 0) {
//            NSString *userFolder = [[NSFileManager defaultManager] tim_chatFileFolderForUser:aidi];
//            NSString *dbPath;
//            if (!isEncrypted) {
//                dbPath = [userFolder stringByAppendingPathComponent:@"db.sqlite"];
//            }else{
//                dbPath = [userFolder stringByAppendingPathComponent:@"db.encrypted.sqlite"];
//            }
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = dbPath;
//            [BDIMDebugToast showToast:@"数据库地址已复制"];
//        }
//    }]];
}

@end
