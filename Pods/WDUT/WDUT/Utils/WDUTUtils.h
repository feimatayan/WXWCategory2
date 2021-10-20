//
//  WDUTUtils.h
//  WDUT
//
//  Created by WeiDian on 15/12/25.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WDUTUtils : NSObject

+ (NSString *)wdutToJSONString:(NSDictionary *)dic;

+ (NSString *)numberToString:(NSInteger)number;

+ (NSString *)addQuery:(NSDictionary *)query withURL:(NSString *)url;

//线程安全
+ (UIViewController *)topViewController;

+ (BOOL)isFilteredPage:(UIViewController *)controller;

#pragma mark - version

+ (NSString *)getAppVersion;

UIApplication *WDUTSharedApplication();

BOOL IsAppExtension();

@end
