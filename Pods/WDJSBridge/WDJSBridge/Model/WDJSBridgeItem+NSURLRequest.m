//
//  WDJSBridgeItem+NSURLRequest.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeItem+NSURLRequest.h"

@implementation WDJSBridgeItem (NSURLRequest)

+ (instancetype)itemWithRequest:(NSURLRequest *)request;
{
	WDJSBridgeItem *item = [[self alloc] init];
	[item setValue:request forKey:@"request"];
	return item;
}

+ (instancetype)itemWithURL:(NSURL *)url
{
	WDJSBridgeItem *item = [[self alloc] init];
	[item setValue:url forKey:@"url"];
	return item;
}


@end
