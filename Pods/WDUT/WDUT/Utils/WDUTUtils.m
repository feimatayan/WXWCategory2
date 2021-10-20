//
//  WDUTUtils.m
//  WDUT
//
//  Created by WeiDian on 15/12/25.
//  Copyright © 2018 WeiDian All rights reserved.
//

#import "WDUTUtils.h"
#import <objc/runtime.h>
#import <Security/SecItem.h>
#import <CommonCrypto/CommonDigest.h>
#import "WDUTConfig.h"

@implementation WDUTUtils

+ (NSString *)wdutToJSONString:(NSDictionary *)dic {
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        return @"";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];

    if (!jsonData) {
        return @"";
    }

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)numberToString:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld", (long) number];
}

+ (NSString *)addQuery:(NSDictionary *)query withURL:(NSString *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:url];
    
    if (query.count == 0) {
        return urlComponents.URL.absoluteString;
    }
    
    if (!urlComponents.queryItems) {
        urlComponents.queryItems = @[];
    }
    [query enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *value;
        if ([obj isKindOfClass:NSNumber.class]) {
            value = [(NSNumber *) obj stringValue];
        } else if ([obj isKindOfClass:NSString.class]) {
            value = obj;
        }
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
        urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObject:item];
    }];
    return urlComponents.URL.absoluteString;
}

#pragma mark - viewController
+ (UIViewController *)topViewController {
    if (IsAppExtension()) {
        return nil;
    }
    if ([NSThread isMainThread]) {
        UIViewController *rootViewController = [WDUTSharedApplication().delegate window].rootViewController;
        return [self topViewControllerWithRootViewController:rootViewController];
    } else {
        __block UIViewController *viewController = nil;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *rootViewController = [WDUTSharedApplication().delegate window].rootViewController;
            viewController = [self topViewControllerWithRootViewController:rootViewController];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t) 10 * NSEC_PER_MSEC));
        return viewController;
    }

}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *) rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }

    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }

    if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }

    return rootViewController;
}

/// 可以走接口配置
+ (BOOL)isFilteredPage:(UIViewController *)controller {
    for (NSString *filterClassString in [WDUTConfig instance].filteredPageList) {
        if ([NSStringFromClass([controller class]) isEqualToString:filterClassString] || [controller isKindOfClass:NSClassFromString(filterClassString)]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - version

+ (NSString *)getAppVersion {
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (versionString.length == 0) {
        versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *) kCFBundleVersionKey];
    }

    return versionString;
}

BOOL IsAppExtension() {
    static BOOL isAppExtension = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIApplication");
        if(!cls || ![cls respondsToSelector:@selector(sharedApplication)]) isAppExtension = YES;
        if ([[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]) isAppExtension = YES;
    });
    return isAppExtension;
}

UIApplication *WDUTSharedApplication() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return IsAppExtension() ? nil : [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
}

@end
