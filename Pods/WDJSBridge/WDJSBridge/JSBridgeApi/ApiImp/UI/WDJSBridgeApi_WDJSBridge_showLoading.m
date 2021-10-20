//
//  WDJSBridgeApi_WDJSBridge_showLoading.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_showLoading.h"
#import "WDJSBridgeApiUtils.h"
#import "WDJSBridgeLoadingView.h"

@implementation WDJSBridgeApi_WDJSBridge_showLoading

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	UIViewController *topVC = [WDJSBridgeApiUtils jsbridge_topViewController];
	if(!topVC) {
		callback(WDJSBridgeHandlerResponseCodeFailure, nil);
		return;
	}

	[WDJSBridgeLoadingView showInView:topVC.view withText:self.content];
	callback(WDJSBridgeHandlerResponseCodeSuccess, nil);
}

@end
