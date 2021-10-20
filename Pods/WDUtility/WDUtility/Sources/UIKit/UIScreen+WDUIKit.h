//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WDScreenWidth       ([UIScreen wd_screenWidth])
#define WDScreenHeight      ([UIScreen wd_screenHeight])

#define WDIPhoneXHeight     (812)
#define WDIPhoneXROrXSMAXHeight (896)
#define WDTitleBarHeight    ([UIScreen wd_titleBarHeight])
#define WDStatusBarHeight   ([UIScreen wd_statusBarHeight])
#define WDHomeBarHeight     ([UIScreen wd_homeBarHeight])
#define WDIsIPhoneX          \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

@interface UIScreen (WDUIKit)

+ (CGFloat)wd_screenHeight;

+ (CGFloat)wd_screenWidth;

+ (CGFloat)wd_titleBarHeight;

+ (CGFloat)wd_statusBarHeight;

+ (CGFloat)wd_homeBarHeight;

@end
