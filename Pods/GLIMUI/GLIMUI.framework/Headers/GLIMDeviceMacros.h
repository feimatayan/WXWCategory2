//
//  GLIMDeviceMacros.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMDeviceMacros_h
#define GLIMDeviceMacros_h

// 系统版本
#pragma mark - 系统版本

#define IS_SYSTEM_IOS10                             ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define IS_SYSTEM_IOS9                              ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define IS_SYSTEM_IOS8                              ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IS_SYSTEM_IOS7                              ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define IS_SYSTEM_IOS6                              ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)


// 屏幕大小
#pragma mark - 屏幕情况

#define SCREEN_WIDTH                                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                               [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE                                [UIScreen mainScreen].scale

/// 5.5寸屏幕
#define SCREEN_IS_INCHES_55                     (SCREEN_HEIGHT == 736)
/// 5.5寸以下屏幕
#define SCREEN_LESSTHAN_INCHES_55               (SCREEN_HEIGHT  < 736)
/// 5.5寸以上屏幕
#define SCREEN_LARGERTHAN_INCHES_55             (SCREEN_HEIGHT  > 736)

/// 4.7寸屏幕
#define SCREEN_EQUAL_INCHES_47                  (SCREEN_HEIGHT == 667)
/// 4.7寸以下屏幕
#define SCREEN_LESSTHAN_INCHES_47               (SCREEN_HEIGHT  < 667)
/// 4.7寸以上屏幕
#define SCREEN_LARGERTHAN_INCHES_47             (SCREEN_HEIGHT  > 667)

/// 4.0寸屏幕
#define SCREEN_EQUAL_INCHES_40                  (SCREEN_HEIGHT == 568)
/// 4.0寸以下屏幕
#define SCREEN_LESSTHAN_INCHES_40               (SCREEN_HEIGHT  < 568)
/// 4.0寸以上屏幕
#define SCREEN_LARGERTHAN_INCHES_40             (SCREEN_HEIGHT  > 568)

/// 3.5寸屏幕
#define SCREEN_EQUAL_INCHES_35                  (SCREEN_HEIGHT == 480)

// 设备
#pragma mark - 硬件设备iPhone4...、iPad

#define IS_DEVICE_IPHONE                        ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? YES : NO)
#define IS_DEVICE_IPAD                          ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)   ? YES : NO)

/// 判断屏幕尺寸是否等于指定尺寸
#define IM_IS_SCREENMODE_EQUAL_SIZE(w,h)        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(w, h), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhoneX 标准模式
//#define IS_DEVICE_IPHONE_X                      (IM_IS_DEVICE_IPHONE_X || IM_IS_DEVICE_IPHONE_XS_MAX || IM_IS_DEVICE_IPHONE_XR)
/// iPhoneX
#define IM_IS_DEVICE_IPHONE_X                   (IM_IS_SCREENMODE_EQUAL_SIZE(1125, 2436))
/// iPhoneXsMax 设置引导图后尺寸{1242, 2688}，未设置时为{1125, 2436}
#define IM_IS_DEVICE_IPHONE_XS_MAX              (IM_IS_SCREENMODE_EQUAL_SIZE(1242, 2688))
/// iPhoneXR 设置引导图后尺寸{828, 1792}，未设置时为{750, 1624}
#define IM_IS_DEVICE_IPHONE_XR                  (IM_IS_SCREENMODE_EQUAL_SIZE(750, 1624) || IM_IS_SCREENMODE_EQUAL_SIZE(828, 1792))




#define IS_DEVICE_IPHONE_X                      IM_IS_DEVICE_IsIPhoneX
#define IM_IS_DEVICE_IsIPhoneX          \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})



/// iPhoneX底部高度（安全区实际高度为34pt，当时以为是px，所以进行除2）
#define DEVICE_IPHON_X_BOTTOM_HEIGHT            (17)
/// iPhoneX底部实际高度
#define IM_DEVICE_IPHONE_X_BOTTOM_HEIGHT        (34)
/// iPhoneX底部聊天页面输入框留白（为避免用户聊天触碰到安全区，所以在底部又添加了25pt）
#define DEVICE_IPHONE_X_BOTTOM_INPUT_OFFSET     (25)

/// iPhone6Plus 标准模式
#define IS_DEVICE_IPHONE_6_Plus                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone6Plus 放大模式
#define IS_DEVICE_IPHONE_6_Plus_Scale           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

/// 包含（iPhone6Plus和 放大模式）
#define IS_DEVICE_IPHONE_6_Plus_Or_Scale        (IS_DEVICE_IPHONE_6_Plus_Scale || IS_DEVICE_IPHONE_6_Plus)

/// iPhone6 的手机
#define IS_DEVICE_IPHONE_6                      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone5 的手机
#define IS_DEVICE_IPHONE_5                      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone4 的手机
#define IS_DEVICE_IPHONE_4                      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* GLIMDeviceMacros_h */
