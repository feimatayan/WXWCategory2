//
//  WDJSBridgeApi_WDJSBridge_isMethodExist.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_isMethodExist.h"
#import "WDJSBridgeApiFactory.h"
#import "WDJSBridgeApiUtils.h"

@implementation WDJSBridgeApi_WDJSBridge_isMethodExist

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
	if(!_module || _module.length <= 0) {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"module为空"});
		return;
	}
	
	if([WDJSBridgeApiUtils jsbridge_isNullStr:_identifier] && [WDJSBridgeApiUtils jsbridge_isNullStr:_method]) {
		callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"identifier和method必须有其一"});
		return;
	}
	
	NSString *identifier = [WDJSBridgeApiUtils jsbridge_isNullStr:_identifier] ? self.method : self.identifier;
	
	BOOL apiExists = [WDJSBridgeApiFactory apiExistsInModule:_module identifier:identifier];
	
	BOOL handlerExists = NO;
	if(info[@"jsbridge"]) {
		WDNJSBridge *jsbridge = info[@"jsbridge"];
		handlerExists = [jsbridge handlerExistsWithModule:_module identifier:identifier];
	}
	
	BOOL exists = apiExists || handlerExists;
	
	callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"exist": @(exists? 1:0)});
}

@end
