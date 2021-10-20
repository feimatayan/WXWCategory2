//
//  WDJSBridgeApi_WDJSBridge_setClipboardData.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/12.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_setClipboardData.h"

@implementation WDJSBridgeApi_WDJSBridge_setClipboardData

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	// 清空粘贴板内容
    [UIPasteboard generalPasteboard].strings = nil;
    if( [self.data isKindOfClass:NSString.class] && self.data.length > 0) {
        [UIPasteboard generalPasteboard].string = self.data;
        callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"result":@"0"});
    } else {
        callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"空数据或者无效的数据类型",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorInvalidateData)});
    }
}

@end
