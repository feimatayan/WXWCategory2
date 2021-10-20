//
//  WDJSBridgeApi_WDJSBridge_getNetworkStatus.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getNetworkStatus.h"
#import <RealReachability/RealReachability.h>

@implementation WDJSBridgeApi_WDJSBridge_getNetworkStatus

- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback {

    NSInteger networkStatus = 0;
    switch ([RealReachability sharedInstance].currentReachabilityStatus) {

        case RealStatusUnknown: {
            networkStatus = 0;
            break;
        }
        case RealStatusNotReachable: {
            networkStatus = -1;
            break;
        }
        case RealStatusViaWWAN: {
            switch ([RealReachability sharedInstance].currentWWANtype) {
                case WWANTypeUnknown: {
                    networkStatus = 0;
                    break;
                }
                case WWANType4G: {
                    networkStatus = 5;
                    break;
                }
                case WWANType3G: {
                    networkStatus = 4;
                    break;
                }
                case WWANType2G: {
                    networkStatus = 3;
                    break;
                }
            }
            break;
        }

        case RealStatusViaWiFi: {
            networkStatus = 2;
            break;
        }
    }
    callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"network": @(networkStatus)});
}

@end
