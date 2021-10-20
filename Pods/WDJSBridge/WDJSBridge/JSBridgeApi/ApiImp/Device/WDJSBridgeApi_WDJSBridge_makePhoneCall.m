//
//  WDJSBridgeApi_WDJSBridge_makePhoneCall.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_makePhoneCall.h"

@implementation WDJSBridgeApi_WDJSBridge_makePhoneCall

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {

	if (!self.phoneNumber || self.phoneNumber.length <= 0) {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"invalid phone number"});
		return;
	}
	
	NSString *urlStr = [NSString stringWithFormat:@"tel://%@", _phoneNumber];
	NSURL *callURL = [NSURL URLWithString:urlStr];
	if ([[UIApplication sharedApplication] canOpenURL:callURL]) {
        [[UIApplication sharedApplication] openURL:callURL options:@{} completionHandler:nil];
        
		callback(WDJSBridgeHandlerResponseCodeSuccess, nil);
	} else {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"can not call"});
	}
}

@end
