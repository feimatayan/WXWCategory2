//
// Created by yangxin02 on 2018/11/23.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDTNNetworkConfig.h"
#import "WDTNNetwrokConfig.h"
#import "WDTNThorSecurityItem.h"


@implementation WDTNNetworkConfig

+ (void)registerSecurityItem:(WDTNThorSecurityItem *)item key:(NSString *)key {
    if (key.length == 0 || !item) {
        return ;
    }

    [WDTNNetwrokConfig sharedInstance].thorSecurityItems[key] = item;

    @synchronized ([WDTNNetworkConfig class]) {
        NSString *watchKey = [WDTNNetwrokConfig sharedInstance].watchConfigType;
        if (watchKey.length > 0 && [watchKey isEqual:key]) {
            if ([WDTNNetwrokConfig sharedInstance].watchCallback) {
                [WDTNNetwrokConfig sharedInstance].watchCallback();
            }

            [WDTNNetwrokConfig sharedInstance].watchConfigType = nil;
            [WDTNNetwrokConfig sharedInstance].watchCallback = nil;
        }
    }
}

+ (WDTNThorSecurityItem *)querySecurityItem:(NSString *)key {
    if (key.length == 0) {
        return nil;
    }

    return [WDTNNetwrokConfig sharedInstance].thorSecurityItems[key];
}

+ (void)watchSecurityItem:(NSString *)key callback:(void(^)(void))callback {
    if (key.length == 0 || !callback) {
        return ;
    }

    @synchronized ([WDTNNetworkConfig class]) {
        [WDTNNetwrokConfig sharedInstance].watchConfigType = key;
        [WDTNNetwrokConfig sharedInstance].watchCallback = callback;
    }
}

@end
