//
//  WDIEStatisticsManager.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/6/25.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEStatisticsManager.h"
#import "WDIEStatisticsDelegate.h"

@implementation WDIEStatisticsManager

+ (instancetype)sharedManager
{
	static dispatch_once_t onceToken;
	static WDIEStatisticsManager *manager = nil;
	dispatch_once(&onceToken, ^{
		manager = [[WDIEStatisticsManager alloc] init];
	});
	return manager;
}

- (void)logWithID:(NSString *)ID params:(NSDictionary *)params
{
	if (_delegate && [_delegate respondsToSelector:@selector(logWithID:params:)]) {
		[_delegate logWithID:ID params:params];
	}
}

@end
