//
//  WDJSBridgeLogger.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeLogger.h"
#import "WDJSBridgeConfig.h"

@implementation WDJSBridgeLogger


void WDJSBridgeLog(NSString *format, ...) {
	if ([WDJSBridgeConfig sharedConfig].showLog) {
		va_list argumentList;
		
		va_start(argumentList, format);
		NSString *log = [@"----WDJSBridge---->: " stringByAppendingString:format];
		NSLogv(log, argumentList);
		va_end(argumentList);
	}
}

@end
