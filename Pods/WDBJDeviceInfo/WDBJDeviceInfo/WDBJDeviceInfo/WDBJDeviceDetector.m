//
//  WDBJDeviceMacroUtil.m
//  WDBJDeviceInfo
//
//  Created by JL on 2017/3/13.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import "WDBJDeviceDetector.h"

// These notifications are sent out after the equivalent delegate message is called
//UIKIT_EXTERN NSNotificationName const UIApplicationDidEnterBackgroundNotification       NS_AVAILABLE_IOS(4_0);
//UIKIT_EXTERN NSNotificationName const UIApplicationWillEnterForegroundNotification      NS_AVAILABLE_IOS(4_0);
//UIKIT_EXTERN NSNotificationName const UIApplicationDidBecomeActiveNotification;
//UIKIT_EXTERN NSNotificationName const UIApplicationWillResignActiveNotification;

//获取当前进程的状态
static WDUIApplicationState appState = WDUIApplicationStateInactive;
@implementation WDBJDeviceDetector

////////////////////////////////////////////////
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static WDBJDeviceDetector *singleInstance;
        singleInstance = [WDBJDeviceDetector new];
        [[NSNotificationCenter defaultCenter] addObserver:singleInstance selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:singleInstance selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:singleInstance selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:singleInstance selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
}
#pragma mark 进入后台
- (void)appDidEnterBackground:(NSNotification*)note
{
    appState = WDUIApplicationStateBackground;
#ifdef DEBUG
    NSLog(@"\n %s \n", __FUNCTION__);
#endif
}
#pragma mark 进入前台
- (void)appWillEnterForeground:(NSNotification*)note
{
    appState = WDUIApplicationStateActive;
#ifdef DEBUG
    NSLog(@"\n %s \n", __FUNCTION__);
#endif
}
#pragma mark 从活动状态进入非活动状态
- (void)appwillResignActive:(NSNotification *)note
{
    appState = WDUIApplicationStateInactive;
#ifdef DEBUG
    NSLog(@"\n %s \n", __FUNCTION__);
#endif
}

#pragma mark 程序从后台激活
- (void)appBecomeActive:(NSNotification *)note
{
    appState = WDUIApplicationStateActive;
#ifdef DEBUG
    NSLog(@"\n %s \n", __FUNCTION__);
#endif
}
/**
 获取当前进程的状态
 @return 当前进程的状态
 */
+ (WDUIApplicationState)applicationState {
    return appState;
}
////////////////////////////////////////////////

+ (BOOL)isIPhoneDevice{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? YES : NO);
}

+ (BOOL)isIPadDevice{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)   ? YES : NO);
}

+ (BOOL)isDeviceIPhone4{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isDeviceIPhone5{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isDeviceIPhone6{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isDeviceIPhone6P{
    return ([self isDeviceIPhone6PNormalMode] || [self isDeviceIPhone6PScaleMode]);
}

+ (BOOL)isDeviceIPhone6PNormalMode{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isDeviceIPhone6PScaleMode{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isSystemVersionIOS6{
    return ([self isIOSVersionOrLater:6.0] && ![self isIOSVersionOrLater:7.0])  ;
}

+ (BOOL)isSystemVersionIOS7{
    return ([self isIOSVersionOrLater:7.0] && ![self isIOSVersionOrLater:8.0]);
}

+ (BOOL)isSystemVersionIOS8{
    return ([self isIOSVersionOrLater:8.0] && ![self isIOSVersionOrLater:9.0]);
}

+ (BOOL)isSystemVersionIOS9{
    return ([self isIOSVersionOrLater:9.0] && ![self isIOSVersionOrLater:10.0]);
}

+ (BOOL)isSystemVersionIOS10{
    return ([self isIOSVersionOrLater:10.0] && ![self isIOSVersionOrLater:11.0]);
}

+ (BOOL)isIOSVersionOrEarlier:(CGFloat)version{
    return  ([[UIDevice currentDevice].systemVersion floatValue] <= version);
}

+ (BOOL)isIOSVersionOrLater:(CGFloat)version{
    return  ([[UIDevice currentDevice].systemVersion floatValue] >= version);
}

+ (CGFloat)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (BOOL)screenIncheEquals35{
    return ([self screenHeight] == 480);
}

+ (BOOL)screenIncheEquals40{
    return ([self screenHeight] == 568);
}

+ (BOOL)screenIncheLessThan40{
    return ([self screenHeight] < 568);
}

+ (BOOL)screenIncheLargerThan40{
    return ([self screenHeight] > 568);
}

+ (BOOL)screenIncheEquals47{
    return ([self screenHeight] == 667);
}

+ (BOOL)screenIncheLessThan47{
    return ([self screenHeight] < 667);
}

+ (BOOL)screenIncheLargerThan47{
    return ([self screenHeight] > 667);
}

+ (BOOL)screenIncheEquals55{
    return ([self screenHeight] == 736);
}

+ (BOOL)screenIncheLessThan55{
    return ([self screenHeight] < 736);
}

+ (BOOL)screenIncheLargerThan55{
    return ([self screenHeight] > 736);
}

+ (CGFloat)defaultSeparatorLineHeight{
    return 1.0 / [UIScreen mainScreen].scale;
}

@end
