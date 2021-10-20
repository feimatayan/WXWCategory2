//
//  WDJSBridgeConfig.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeConfig.h"

@implementation WDJSBridgeConfig

- (instancetype)init
{
	if(self = [super init]) {
		_bridgeScheme = @"kdbridge";
	}
	
	return self;
}

+ (instancetype)sharedConfig;
{
	static dispatch_once_t onceToken;
	static WDJSBridgeConfig *instance;
	dispatch_once(&onceToken, ^{
		instance = [[WDJSBridgeConfig alloc] init];
	});
	
	return instance;
}

@end
