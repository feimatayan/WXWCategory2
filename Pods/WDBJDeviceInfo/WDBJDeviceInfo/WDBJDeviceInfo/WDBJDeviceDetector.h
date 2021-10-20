//
//  WDBJDeviceMacroUtil.h
//  WDBJDeviceInfo
//
//  Created by JL on 2017/3/13.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, WDUIApplicationState) {
    WDUIApplicationStateActive,//same to UIApplicationStateActive,
    WDUIApplicationStateInactive,//same to UIApplicationStateInactive,
    WDUIApplicationStateBackground//same to UIApplicationStateBackground
} NS_ENUM_AVAILABLE_IOS(4_0);

@interface WDBJDeviceDetector : NSObject


/**
 判断设备是否是iPhone

 @return 是否为iPhone
 */
+ (BOOL)isIPhoneDevice;


/**
 判断设备是否为iPad

 @return 是否为iPad
 */
+ (BOOL)isIPadDevice;

/**
 判断是否为iPhone4

 @return 是否为iPhone4
 */
+ (BOOL)isDeviceIPhone4;

/**
 判断是否为iPhone5
 
 @return 是否为iPhone5
 */
+ (BOOL)isDeviceIPhone5;

/**
 判断是否为iPhone6
 
 @return 是否为iPhone6
 */
+ (BOOL)isDeviceIPhone6;

/**
 判断是否为iPhone6P
 
 @return 是否为iPhone6P
 */
+ (BOOL)isDeviceIPhone6P;

/**
 判断是否为iPhone6P普通模式
 
 @return 是否为iPhone6P普通模式
 */
+ (BOOL)isDeviceIPhone6PNormalMode;

/**
 判断是否为iPhone6P
 
 @return 是否为iPhone6P放大模式
 */
+ (BOOL)isDeviceIPhone6PScaleMode;

/**
 系统是否为iOS6

 @return 是否为iOS6系统
 */
+ (BOOL)isSystemVersionIOS6;

/**
 系统是否为iOS7
 
 @return 是否为iOS7系统
 */
+ (BOOL)isSystemVersionIOS7;

/**
 系统是否为iOS8
 
 @return 是否为iOS8系统
 */
+ (BOOL)isSystemVersionIOS8;

/**
 系统是否为iOS9
 
 @return 是否为iOS9系统
 */
+ (BOOL)isSystemVersionIOS9;

/**
 系统是否为iOS10
 
 @return 是否为iOS10系统
 */
+ (BOOL)isSystemVersionIOS10;

/**
 屏幕宽度

 @return 屏幕宽度
 */
+ (CGFloat)screenWidth;

/**
 屏幕高度

 @return 屏幕高度
 */
+ (CGFloat)screenHeight;

/**
 是否为3.5英寸设备

 @return 是否为3.5英寸设备
 */
+ (BOOL)screenIncheEquals35;

/**
 是否为4.0英寸设备

 @return 是否为4.0英寸设备
 */
+ (BOOL)screenIncheEquals40;

/**
 设备大小是否小于4.0英寸
 
 @return 设备大小是否小于4.0英寸
 */
+ (BOOL)screenIncheLessThan40;

/**
 设备大小是否大于4.0英寸
 
 @return 设备大小是否大于4.0英寸
 */
+ (BOOL)screenIncheLargerThan40;

/**
 是否为4.7英寸设备
 
 @return 是否为4.7英寸设备
 */
+ (BOOL)screenIncheEquals47;

/**
 设备大小是否小于4.7英寸
 
 @return 设备大小是否小于4.7英寸
 */
+ (BOOL)screenIncheLessThan47;

/**
 设备大小是否大于4.7英寸
 
 @return 设备大小是否大于4.7英寸
 */
+ (BOOL)screenIncheLargerThan47;

/**
 是否为5.5英寸设备
 
 @return 是否为5.5英寸设备
 */
+ (BOOL)screenIncheEquals55;

/**
 设备大小是否小于5.5英寸
 
 @return 设备大小是否小于5.5英寸
 */
+ (BOOL)screenIncheLessThan55;

/**
 设备大小是否大于5.5英寸
 
 @return 设备大小是否大于5.5英寸
 */
+ (BOOL)screenIncheLargerThan55;

/**
 默认1px分割线的高度

 @return 不同设备上1px分割线的高度
 */
+ (CGFloat)defaultSeparatorLineHeight;

/**
 iOS系统版本是否小于或者等于传入的版本号
 
 @param version 传入指定的系统版本号
 @return 版本是否小于或者等于当前版本
 */
+ (BOOL)isIOSVersionOrEarlier:(CGFloat)version;

/**
 iOS系统版本是否大于或者等于传入的版本号

 @param version 传入指定的系统版本号
 @return 版本是否大于或者等于当前版本
 */
+ (BOOL)isIOSVersionOrLater:(CGFloat)version;

/**
 获取当前进程的状态
 @return 当前进程的状态
 */
+ (WDUIApplicationState)applicationState;

@end
