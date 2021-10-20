//
//  WDJSBridgeApi_WDJSBridge_getAppName.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getAppName.h"

@implementation WDJSBridgeApi_WDJSBridge_getAppName

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
	if(!appName){
		appName = @"";
	}
	callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"appName": appName});
}

@end
