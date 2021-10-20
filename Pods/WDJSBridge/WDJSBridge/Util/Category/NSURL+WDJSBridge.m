//
//  NSURL+WDJSBridge.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "NSURL+WDJSBridge.h"
#import "NSString+WDJSBridge.h"

@implementation NSURL (WDJSBridge)

- (NSDictionary *)jsbridge_queryPairs
{
	//url query
	NSString* queryString = [self query];
	NSArray* queryArray = [queryString componentsSeparatedByString:@"&"];
	
	NSMutableDictionary* queryPairs = [NSMutableDictionary dictionaryWithCapacity:5];
	//遍历单个query，获取key, value键值对.重复的key值前面的会被覆写。
	for (NSString* aQuery in queryArray ) {
		NSArray* pair = [aQuery componentsSeparatedByString:@"="];
		if ([pair count] > 1) {
			NSString* key = [pair objectAtIndex:0];
			key = [key jsbridge_urlDecode];
			NSString* value = [pair objectAtIndex:1];
			value = [value jsbridge_urlDecode];
			[queryPairs setObject:value forKey:key];
		}
	}
	return queryPairs;
}


@end
