//
//  WDTNParameterProcessor.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


//状态
typedef NS_ENUM(NSInteger, WDNThorStatus) {
    ///Direct match with Apple networkStatus, just a force type convert.
    WDNThorStatusUnknown = -1,
    WDNThorStatusNotReachable = 0,
    WDNThorStatus2G = 1,
    WDNThorStatus3G = 2,
    WDNThorStatus4G = 3,
    WDNThorStatusWIFI = 4,
    WDNThorStatusUserMaybeNotAllowUseNetwork = 5,
    WDNThorStatusMobile = 6,
};

typedef NS_ENUM(NSInteger, WDNThorAccessType) {
    WDNThorAccessTypeUnknown = -1, /// maybe iOS6
    WDNThorAccessType4G = 0,
    WDNThorAccessType3G = 1,
    WDNThorAccessType2G = 3
};

@class WDTNPerformTask;
@class WDTNRequestConfig;

@interface WDTNParameterProcessor : NSObject

+ (NSDictionary *)HTTPHeaderFields:(WDTNRequestConfig *)config;

+ (NSData *)HTTPBody:(NSDictionary *)customParams
                task:(WDTNPerformTask *)task
               error:(NSError **)error;

+ (NSString *)currentRadioAccessTechnology;

+ (WDNThorStatus)currentLocalNetworkStatus;

@end
