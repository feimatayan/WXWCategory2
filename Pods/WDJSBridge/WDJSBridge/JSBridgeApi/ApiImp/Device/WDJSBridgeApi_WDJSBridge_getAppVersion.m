//
//  WDJSBridgeApi_WDJSBridge_getAppVersion.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getAppVersion.h"

@implementation WDJSBridgeApi_WDJSBridge_getAppVersion

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	if(!appVersion) {
		appVersion = @"";
	}
	
	callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"appVersion": appVersion});
}

@end
