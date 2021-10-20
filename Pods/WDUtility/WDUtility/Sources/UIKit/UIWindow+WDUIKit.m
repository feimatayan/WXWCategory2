//
// Created by reeceran on 16/8/10.
// Copyright (c) 2016 Henson. All rights reserved.
//

#import "UIWindow+WDUIKit.h"


@implementation UIWindow (WDUIKit)

+ (UIWindow *)wd_keyWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!CGRectEqualToRect(keyWindow.bounds, [UIScreen mainScreen].bounds)) {
        id delegate = [UIApplication sharedApplication].delegate;
        if ([delegate respondsToSelector:@selector(window)]) {
            return [delegate window];
        }
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *win in windows) {
            if (CGRectEqualToRect(win.bounds, [UIScreen mainScreen].bounds)) {
                return win;
            }
        }
    }
    return keyWindow;
}

@end