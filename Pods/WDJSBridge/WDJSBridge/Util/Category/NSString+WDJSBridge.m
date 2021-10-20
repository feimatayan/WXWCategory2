//
//  NSString+WDJSBridge.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "NSString+WDJSBridge.h"
#import "WDJSBridgeLogger.h"

@implementation NSString (WDJSBridge)

- (NSString *)jsbridge_urlEncode
{
	NSString * srtD = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8));
	
	return srtD;
}

- (NSString *)jsbridge_urlDecode
{
	NSString * srtD = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)[self mutableCopy], CFSTR(""), kCFStringEncodingUTF8));
	
	return srtD;
}

- (id)jsbridge_jsonObjectParse
{
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	NSDictionary * info = nil;
	
	@try {
		info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
	}
	@catch (NSException *exception) {
		WDJSBridgeLog(@"JSON Parsing Exception: %@", exception.reason);
	}
	
	if (!error && [info isKindOfClass:[NSDictionary class]])
	{
		return info;
	}
	
	return nil;
}


@end
