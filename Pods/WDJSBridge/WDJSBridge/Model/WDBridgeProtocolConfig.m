//
//  WDBridgeProtocolConfig.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/5.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDBridgeProtocolConfig.h"

@implementation WDBridgeProtocolConfig

- (instancetype)init
{
	if (self = [super init]) {
		_useCustomCallbackMethod = NO;
		
		_needProtocolBridgeParam = YES;
	}
	
	return self;
}

@end
