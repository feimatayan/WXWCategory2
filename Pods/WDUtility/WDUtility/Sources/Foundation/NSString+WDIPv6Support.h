//
//  NSString+WDIPv6Support.h
//  WDUtility
//
//  Created by shazhou on 16/5/16.
//  Copyright © 2016年 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WDIPv6Support)

//ipv4格式的地址，不需要http头，例192.0.2.1
+ (nullable NSString *)wd_ipAddress:(nullable NSString *)ipv4String;

+ (nullable NSString *)getDNSAddress;

@end
