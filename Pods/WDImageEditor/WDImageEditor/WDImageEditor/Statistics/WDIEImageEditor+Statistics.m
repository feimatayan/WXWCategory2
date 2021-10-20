//
//  WDIEImageEditor+Interface.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/6/25.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEImageEditor+Statistics.h"
#import "WDIEStatisticsManager.h"

@implementation WDIEImageEditor (Statistics)

+ (void)setStatisticsDelegate:(id<WDIEStatisticsDelegate>)delegate
{
	[WDIEStatisticsManager sharedManager].delegate = delegate;
}

@end
