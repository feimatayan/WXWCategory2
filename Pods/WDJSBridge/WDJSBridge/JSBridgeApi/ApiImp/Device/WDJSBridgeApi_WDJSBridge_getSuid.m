//
//  WDJSBridgeApi_WDJSBridge_QRCode.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/24.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getSuid.h"
#import <WDUT/WDUT.h>

@implementation WDJSBridgeApi_WDJSBridge_getSuid

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
    NSString *suid = [WDUT getSuid];
    if (![suid length]) {
        suid = @"";
    }
    if (callback) {
        NSDictionary *result = @{@"suid": suid};
        callback(WDJSBridgeHandlerResponseCodeSuccess, result);
    }
}

@end
