//
//  BIMUIDefine.h
//  ByteBusiness
//
//  Created by zhanjiang on 2023/2/22.
//  Copyright © 2023 loulan. All rights reserved.
//

#ifndef BIMUIDefine_h
#define BIMUIDefine_h

// 获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenScale [UIScreen mainScreen].scale

// safeAre
#define kViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets; })
#define kDevice_Is_iPhoneX (kAppWindow.safeAreaInsets.bottom > 0)
#define kDevice_iPhoneStatusBarHei (kDevice_Is_iPhoneX ? 44.f : 20.f)
#define kDevice_iPhoneNavBarHei 44.f
#define kDevice_iPhoneNavBarAndStatusBarHei (kDevice_iPhoneStatusBarHei + kDevice_iPhoneNavBarHei)

// tabbar安全区域
#define kDevice_TabbarSafeBottomMargin (kDevice_Is_iPhoneX ? 34.f : 0.f)
#define kDevice_iPhoneTabBarHei (kDevice_TabbarSafeBottomMargin + 49.f)

///Color
#define kRGBCOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define kIM_Main_Color kRGBCOLOR(34, 34, 34, 1)
#define kIM_Main_Color_30 kRGBCOLOR(34, 34, 34, 0.3)
#define kIM_Sub_Color kRGBCOLOR(123, 129, 141, 1)
#define kIM_Line_Color kRGBCOLOR(232, 232, 232, 1)
#define kIM_Red_Color kRGBCOLOR(248, 89, 89, 1)
#define kIM_View_Background_Color kRGBCOLOR(248, 248, 248, 1)
#define kIM_Blue_Color kRGBCOLOR(212, 226, 252, 1)
#define kWhiteColor [UIColor whiteColor]
#define kClearColor [UIColor clearColor]

//字体
#define kFont(size) [UIFont systemFontOfSize:size]
#define kBoldFont(size) [UIFont boldSystemFontOfSize:size]

//图片
#define kIMAGE_IN_BUNDLE_NAMED(name)   [UIImage imageNamed:[@"BIMUIKit.bundle" stringByAppendingPathComponent:name]]
// View圆角和加边框
#define kViewBorderRadius(View, Radius, Width, Color) \
                                                      \
    [View.layer setCornerRadius:Radius];              \
    [View.layer setMasksToBounds:YES];                \
    [View.layer setBorderWidth:(Width)];              \
    [View.layer setBorderColor:[Color CGColor]];

//数据校验
#define kValidStr(f) (f != nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define kSafeStr(f) (kValidStr(f) ? f : @"")
#define kHasString(f, rangeStr) ([str rangeOfString:rangeStr].location != NSNotFound)
#define kValidDict(f) (f != nil && [f isKindOfClass:[NSDictionary class]])
#define kValidArray(f) (f != nil && [f isKindOfClass:[NSArray class]] && [f count] > 0)
#define kValidNum(f) (f != nil && [f isKindOfClass:[NSNumber class]])
#define kValidClass(f, cls) (f != nil && [f isKindOfClass:[cls class]])
#define kValidData(f) (f != nil && [f isKindOfClass:[NSData class]])

#define kSafeArrayIndex(array, index) ((index >= 0 && index < array.count) ? array[index] : nil)

//window
#ifdef __IPHONE_13_0
#define kAppWindow [UIApplication sharedApplication].windows.firstObject
#else
#define kAppWindow [UIApplication sharedApplication].delegate.window
#endif

// account
#define kUserDidLoginNotification  @"kUserDidLoginNotification"
#define kUserDidLogoutNotification  @"kUserDidLogoutNotification"

#define kWeakSelf(type) __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//msg
#define kBIMMessageTypeSystem 2


#endif /* BIMUIDefine_h */
