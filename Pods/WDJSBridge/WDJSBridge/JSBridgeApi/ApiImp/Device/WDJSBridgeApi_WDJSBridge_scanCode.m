//
//  WDJSBridgeApi_WDJSBridge_scanCode.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_scanCode.h"

@implementation WDJSBridgeApi_WDJSBridge_scanCode

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	// 暂未实现
	callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"暂未实现",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorNotYetRealized)});
}

@end
