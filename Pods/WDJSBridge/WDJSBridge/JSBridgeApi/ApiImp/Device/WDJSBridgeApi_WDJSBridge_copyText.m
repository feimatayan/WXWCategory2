//
//  WDJSBridgeApi_WDJSBridge_copyText.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/26.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_copyText.h"

@implementation WDJSBridgeApi_WDJSBridge_copyText

- (void)callApiWithContextInfo:(NSDictionary<NSString *,id> *)info callback:(WDJSBridgeHandlerCallback)callback {
	
    if(![self.content isKindOfClass:NSString.class]) {
        callback(WDJSBridgeHandlerResponseCodeFailure, nil);
        return;
    }
    
	// 清空粘贴板内容
	[UIPasteboard generalPasteboard].strings = nil;
	[UIPasteboard generalPasteboard].string = self.content;
	
	callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"result":@"0"});
}

@end
