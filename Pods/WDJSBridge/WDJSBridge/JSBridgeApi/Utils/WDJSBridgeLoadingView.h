//
//  WDJSBridgeLoadingView.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDJSBridgeLoadingView : UIView

/**
 显示Loading层
 
 @param view 指定页面
 */
+ (void) showInView:(UIView *)view withText:(NSString *)text;

/**
 隐藏指定页面的Loading层
 
 @param view 待移除的页面
 */
+ (void) hideInView:(UIView *)view;

@end
