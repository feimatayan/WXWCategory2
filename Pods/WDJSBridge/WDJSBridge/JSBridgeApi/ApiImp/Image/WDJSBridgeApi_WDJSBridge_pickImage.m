//
//  WDJSBridgeApi_WDJSBridge_pickImage.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/24.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_pickImage.h"

@implementation WDJSBridgeApi_WDJSBridge_pickImage

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	// 暂未实现
	callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"暂未实现",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorNotYetRealized)});
}

@end
