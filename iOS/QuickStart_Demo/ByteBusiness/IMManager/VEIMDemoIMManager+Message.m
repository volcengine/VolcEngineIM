//
//  VEIMDemoIMManager+Message.m
//  ByteBusiness
//
//  Created by Weibai on 2022/11/25.
//  Copyright © 2022 loulan. All rights reserved.
//

#import "VEIMDemoIMManager+Message.h"
#import "BIMToastView.h"
#import "VEIMDemoDefine.h"
#import <imsdk-tob/BIMSDK.h>
#import <imsdk-tob/BIMClient+String.h>
#import <im-uikit-tob/BIMUIClient.h>

@implementation VEIMDemoIMManager (Message)

- (void)sendSystemMessage:(NSString *)msg convId:(NSString *)convId completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (!kValidStr(msg) || !kValidStr(convId)) {
        return;
    }
    [[BIMClient sharedInstance] sendMessage:[[BIMClient sharedInstance] createCustomMessage:@{@"text":msg, @"type":@(kBIMMessageTypeSystem)}] conversationId:convId saved:nil progress:nil completion:^(BIMMessage * _Nonnull message, BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"发送系统消息失败：%@",error.localizedDescription]];
        }
        if(completion){
            completion(error);
        }
    }];
}

- (void)sendLocalSystemMessage:(NSString *)msg convId:(NSString *)convId completion:(void (^ _Nullable)(NSError * _Nullable))completion{
    if (!kValidStr(msg) || !kValidStr(convId)) {
        return;
    }
    [[BIMClient sharedInstance] addLocalMessage:[[BIMClient sharedInstance] createCustomMessage:@{@"text":msg, @"type":@(kBIMMessageTypeSystem)}] conversationId:convId saved:^(BIMMessage * _Nullable message, BIMError * _Nullable error) {
        if (error) {
            [BIMToastView toast:[NSString stringWithFormat:@"储存系统消息失败：%@",error.localizedDescription]];
        }
        if(completion){
            completion(error);
        }
    }];
}

- (NSString *)contentWithMessage:(BIMMessage *)message{
    BIMTextElement *element = message.element;
    NSString *str = element.text;
    if (kValidStr(str)) {
        //兼容web格式
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSError *err;
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            if (!err && [jsonDic isKindOfClass:[NSDictionary class]] && jsonDic.count) {
                NSString *innerText = [jsonDic objectForKey:@"innerText"];
                if (kValidStr(innerText)) {
                    str = innerText;
                }
            }
        }
    }
    return str;
}

@end
