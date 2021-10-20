//
//  WDIEDrawLineInfo.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEDrawLineInfo.h"

@implementation WDIEDrawLineInfo

- (instancetype)init {
	if (self=[super init]) {
		self.linePoints = [[NSMutableArray alloc] initWithCapacity:10];
	}
	
	return self;
}  

@end
