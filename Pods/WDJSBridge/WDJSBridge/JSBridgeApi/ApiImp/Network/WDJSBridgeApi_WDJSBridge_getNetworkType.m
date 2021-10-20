//
//  WDJSBridgeApi_WDJSBridge_getNetworkType.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getNetworkType.h"
#import <RealReachability/RealReachability.h>

@implementation WDJSBridgeApi_WDJSBridge_getNetworkType

- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback {

    NSString *networkStatus = @"";
    switch ([RealReachability sharedInstance].currentReachabilityStatus) {

        case RealStatusUnknown: {
            networkStatus = @"UNKNOWN";
            break;
        }
        case RealStatusNotReachable: {
            networkStatus = @"NONE";
            break;
        }
        case RealStatusViaWWAN: {
            switch ([RealReachability sharedInstance].currentWWANtype) {
                case WWANTypeUnknown: {
                    networkStatus = @"UNKNOWN";
                    break;
                }
                case WWANType4G: {
                    networkStatus = @"4G";
                    break;
                }
                case WWANType3G: {
                    networkStatus = @"3G";
                    break;
                }
                case WWANType2G: {
                    networkStatus = @"2G";
                    break;
                }
            }
            break;
        }
        case RealStatusViaWiFi: {
            networkStatus = @"WIFI";
            break;
        }
    }

    callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"networkType": networkStatus});
}

@end
