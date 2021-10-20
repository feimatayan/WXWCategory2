//
// Created by yangxin02 on 2018/11/23.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WDTNThorSecurityItem;

@interface WDTNNetworkConfig : NSObject

+ (void)registerSecurityItem:(WDTNThorSecurityItem *)item key:(NSString *)key;

+ (WDTNThorSecurityItem *)querySecurityItem:(NSString *)key;

+ (void)watchSecurityItem:(NSString *)key callback:(void(^)(void))callback;

@end