//
//  UIViewController+TopVC.h
//  WDUtility
//
//  Created by Fnoz on 2016/11/1.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (WDTopVC)

+ (UIViewController *)wd_topViewController;
+ (UIViewController *)wd_topViewControllerWithRootViewController:(UIViewController *)rootViewController;

@end
