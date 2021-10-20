//
//  GLViewController.h
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLViewController : UIViewController



- (UIBarButtonItem *)glLeftItem;

// 设置 glLeftItem 后的回调，默认只返回
- (void)glGoBack;


/**
 显示 loading view
 */
- (void)showLoadingToast;

/**
 隐藏 loading view
 */
- (void)hideLoadingToast;

/**
 *  在指定的view中显示淡入淡出的tip view
 *
 *  @param tip      tip内容
 *  @param duration 持续时间
 */
- (void)showFadeInOutTipView:(NSString *)tip withDuration:(CGFloat)duration;

@end
