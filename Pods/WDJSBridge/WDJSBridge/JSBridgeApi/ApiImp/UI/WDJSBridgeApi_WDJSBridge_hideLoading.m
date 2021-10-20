//
//  WDJSBridgeApi_WDJSBridge_hideLoading.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_hideLoading.h"
#import "WDJSBridgeApiUtils.h"
#import "WDJSBridgeLoadingView.h"

@implementation WDJSBridgeApi_WDJSBridge_hideLoading

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	UIViewController *topVC = [WDJSBridgeApiUtils jsbridge_topViewController];
	if(!topVC) {
		callback(WDJSBridgeHandlerResponseCodeFailure, nil);
		return;
	}
	
	[WDJSBridgeLoadingView hideInView:topVC.view];
	callback(WDJSBridgeHandlerResponseCodeSuccess, nil);
}

@end
