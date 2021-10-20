//
//  WDJSBridgeBundleUtil.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBundleUtil.h"

static NSString *resouceBundleString_ = nil;
@implementation WDJSBridgeBundleUtil

+ (void)initialize
{
	NSURL *resourceBundleURL = [[NSBundle mainBundle] URLForResource:@"WDJSBridge" withExtension:@"bundle"];
	if (resourceBundleURL) {
		resouceBundleString_ = [[NSBundle bundleWithURL:resourceBundleURL] resourcePath];
	}
}

+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;
{
	if (![imageName isKindOfClass:[NSString class]] || !imageName.length) {
		return nil;
	}
	
	if (resouceBundleString_) {
		NSString *imagePath = [resouceBundleString_ stringByAppendingPathComponent:imageName];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		return image;
	}
	
	return nil;
}

@end
