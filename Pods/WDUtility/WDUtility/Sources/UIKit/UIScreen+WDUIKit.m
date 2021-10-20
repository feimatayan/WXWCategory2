//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import "UIScreen+WDUIKit.h"

@implementation UIScreen (WDUIKit)

+ (CGFloat)wd_screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)wd_screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)wd_titleBarHeight {
    CGFloat navBarHeight;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (window.rootViewController.navigationController == nil) {
        window = UIApplication.sharedApplication.keyWindow;
    }
    
    navBarHeight = window.rootViewController.navigationController.navigationBar.frame.size.height;
    if (navBarHeight == 0) {
        navBarHeight = 44.0;
    }
    
    return [self wd_statusBarHeight] + navBarHeight;
}

+ (CGFloat)wd_statusBarHeight {
    CGFloat statusBarHeight = 20;
    if (@available(iOS 13.0,*)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    
    return statusBarHeight;
}

+ (CGFloat)wd_homeBarHeight {
    if (@available(iOS 11.0,*)) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        if (window == nil) {
            window = UIApplication.sharedApplication.keyWindow;
        }
        
        return window.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

@end
