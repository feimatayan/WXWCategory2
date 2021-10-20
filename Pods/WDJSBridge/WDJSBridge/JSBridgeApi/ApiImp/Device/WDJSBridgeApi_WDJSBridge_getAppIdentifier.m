//
//  WDJSBridgeApi_WDJSBridge_getAppIdentifier.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getAppIdentifier.h"

@implementation WDJSBridgeApi_WDJSBridge_getAppIdentifier

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	if(!identifier) {
		identifier = @"";
	}
	
	callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"appIdentifier": identifier});
}

@end
