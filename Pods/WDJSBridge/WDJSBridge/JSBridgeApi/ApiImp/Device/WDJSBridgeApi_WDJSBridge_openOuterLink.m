//
//  WDJSBridgeApi_WDJSBridge_openOuterLink.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/28.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_openOuterLink.h"

@implementation WDJSBridgeApi_WDJSBridge_openOuterLink

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	if (!_url || _url.length <= 0) {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-2"});
		return;
	}
	
	NSURL *linkURL = [NSURL URLWithString:_url];
	if (!linkURL) {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-2"});
		return;
	}
    
    [[UIApplication sharedApplication] openURL:linkURL options:@{} completionHandler:^(BOOL success) {
        if (callback) {
            if (success) {
                callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"result": @"0"});
            } else {
                callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": @"-1"});
            }
        }
    }];
}

@end
