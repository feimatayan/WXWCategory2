//
//  NSDictionary+WDJSBridge.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "NSDictionary+WDJSBridge.h"
#import "WDJSBridgeLogger.h"

@implementation NSDictionary (WDJSBridge)

- (NSString *)jsbridge_jsonString;
{
	NSError *error = nil;
	NSData *data = nil;
	
	@try {
		data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
	}
	@catch (NSException *exception) {
		WDJSBridgeLog(@"JSON Parsing Exception: %@", exception.reason);
	}
	
	if (!data)
	{
		return nil;
	}
	
	NSString *mediaContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return mediaContent;
}


@end
