//
//  WDJSBridgeApi_WDJSBridge_QRCode.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/24.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getCuid.h"
#import <WDUT/WDUT.h>

@implementation WDJSBridgeApi_WDJSBridge_getCuid

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
    NSString *cuid = [WDUT getCuid];
    if (![cuid length]) {
        cuid = @"";
    }
    if (callback) {
        if(cuid.length == 0){
            callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey:@"cuid is nil", kWDJSBridgeErrCodeKey: @(WDJSBridgeErrorNilCUID)});
        } else {
            NSDictionary *result = @{@"cuid": cuid};
            callback(WDJSBridgeHandlerResponseCodeSuccess, result);
        }
    }
}

@end
