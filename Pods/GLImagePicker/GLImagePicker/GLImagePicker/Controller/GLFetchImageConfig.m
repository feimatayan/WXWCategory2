//
//  GLFetchImageConfig.m
//  GLImagePicker
//
//  Created by WangYiqiao on 2018/6/13.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "GLFetchImageConfig.h"

@implementation GLFetchImageConfig

- (instancetype)init
{
	if (self = [super init]) {
		_gifLimitSize = 5 * 1024 * 1024;
	}
	
	return self;
}

@end
