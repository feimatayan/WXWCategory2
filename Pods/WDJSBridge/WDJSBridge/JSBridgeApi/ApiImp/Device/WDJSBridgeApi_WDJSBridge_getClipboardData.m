//
//  WDJSBridgeApi_WDJSBridge_getClipboardData.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_getClipboardData.h"

@implementation WDJSBridgeApi_WDJSBridge_getClipboardData

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	NSString *string = [UIPasteboard generalPasteboard].string;
	if (!string) {
		string = @"";
	}
	
	callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"data": string});
}

@end
