//
//  WDJSBridgeBundleUtil.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDJSBridgeBundleUtil : NSObject

/**
 从资源bundle获取图片
 
 @param imageName 图片名
 @return 如果为nil 表示没有该资源图片
 */
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;

@end
