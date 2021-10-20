//
//  WDJSBridgeApiUtils.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/14.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApiUtils.h"

@implementation WDJSBridgeApiUtils

+ (UIViewController *)jsbridge_topViewController {
	
	UIViewController *topViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	
	while (1) {
		if (topViewController.presentedViewController) {
			topViewController = topViewController.presentedViewController;
		} else if ([topViewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *nav = (UINavigationController *)topViewController;
			topViewController = nav.topViewController;
		} else if ([topViewController isKindOfClass:[UITabBarController class]]) {
			UITabBarController *tab = (UITabBarController *)topViewController;
			topViewController = tab.selectedViewController;
		} else {
			break;
		}
	}
	
	return topViewController;
}

+ (BOOL)jsbridge_isNullStr:(NSString *)str {
	return !str || str.length <= 0;
}

@end
