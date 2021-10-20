//
//  WDJSBridgeApi_WDJSBridge_goBack.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/29.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_goBack.h"

@implementation WDJSBridgeApi_WDJSBridge_goBack

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {

	// 暂未实现
    callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"暂未实现",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorNotYetRealized)});
//	if (info && info[@"webView"]) {
//		UIView<WDWebViewProtocol> *webview = info[@"webView"];
//		if([webview respondsToSelector:@selector(goBack)]) {
//			[webview goBack];
//		}
//	}
}

@end
