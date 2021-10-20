//
//  GLUIKitUtils.h
//  GLUIKit
//
//  Created by Kevin on 15/10/9.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define GLUIKIT_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define GLUIKIT_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define GLUIKIT_SCREEN_SCALE   [UIScreen mainScreen].scale
/// Font
#define FONTSYS(size) ([UIFont systemFontOfSize:(size)])
/// Bold Font
#define FONTBOLDSYS(size) ([UIFont boldSystemFontOfSize:(size)])
/// image
#define GL_IMAGE(name) [UIImage imageNamed:(name)]

#define GL_HEIGHT_LINE    (([UIScreen mainScreen].scale == 1.0) ? 1.0f :([UIScreen mainScreen].scale == 3.0)? 0.35f: 0.5f)



#define GLUIKIT_COLOR_BG_DEFAULT    UIColorFromRGB(0xe8eaea)

#define GLUIKIT_COLOR_DISABLED_BUTTON_TEXT [UIColor colorWithRed:243.0/255.0 green:71.0/255.0  blue:73.0/255.0  alpha:1.0]

#define GLUIKit_COLOR_NAVBAR        UIColorFromRGB(0xc60a1e)

#define GLUIKIT_IS_IPHONE (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? YES : NO)

#define GLUIKIT_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]



/**
 *
 *  ******************************************* 硬件设备iPhone4...、iPad *******************************************
 *
 */
#pragma mark - 硬件设备iPhone4...、iPad

#define GL_DEVICE_IPHONE                        ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? YES : NO)
#define GL_DEVICE_IPAD                          ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)   ? YES : NO)


#define GL_DEVICE_IPHONE_X                       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone6Plus 标准模式
#define GL_DEVICE_IPHONE_6_Plus                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone6Plus 放大模式
#define GL_DEVICE_IPHONE_6_Plus_Scale           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

/// 包含（iPhone6Plus和 放大模式）
#define GL_DEVICE_IPHONE_6_Plus_Or_Scale        (IS_DEVICE_IPHONE_6_Plus_Scale || IS_DEVICE_IPHONE_6_Plus)

/// iPhone6 的手机
#define GL_DEVICE_IPHONE_6                      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone5 的手机
#define GL_DEVICE_IPHONE_5                      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhone4 的手机
#define GL_DEVICE_IPHONE_4                      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


/**
 *
 *  ******************************************* 系统版本 *******************************************
 *
 */
#pragma mark - 系统版本

#define GL_SYSTEM_IOS9                          ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define GL_SYSTEM_IOS8                          ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define GL_SYSTEM_IOS7                          ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define GL_SYSTEM_IOS6                          ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)



#define GL_WEAK(_instance_)            __weak typeof(_instance_) weak_##_instance_ = _instance_;

@interface GLUIKitUtils : NSObject


+ (UIFont *)transferToiOSFontSize:(CGFloat)oriFontSize;

+ (UIBarButtonItem *)leftBarButtonItemWithTarget:(id)target
                                        selector:(SEL)selector
                                        andTitle:(NSString*)title;

+ (UIBarButtonItem *)rightBarButtonItemWithTarget:(id)target
                                         selector:(SEL)selector
                                            image:(id)image
                                         andTitle:(NSString *)title;

+ (UINavigationController*)currentNavigationController;





@end
