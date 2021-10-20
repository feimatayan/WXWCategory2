//
//  UIViewController+TopVC.m
//  WDUtility
//
//  Created by Fnoz on 2016/11/1.
//
//

#import "UIViewController+WDTopVC.h"

@implementation UIViewController (WDTopVC)

+ (UIViewController *)wd_topViewController
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [self wd_topViewControllerWithRootViewController:rootViewController];
}

+ (UIViewController *)wd_topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self wd_topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self wd_topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    
    if (rootViewController.presentedViewController)
    {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self wd_topViewControllerWithRootViewController:presentedViewController];
    }
    
    return rootViewController;
}

@end
