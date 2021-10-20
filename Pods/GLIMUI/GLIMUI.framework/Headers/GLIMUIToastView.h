//
//  FXXToastView.h
//  Fangxinxuan
//
//  Created by ZephyrHan on 16/12/15.
//  Copyright © 2016年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * _Nullable kDefaultToastText = @"正在加载...";
static CGFloat              kDefalutHudLastTime = 2.0f;

/**
 通用Toast
 */
@interface GLIMUIToastView : UIView

#pragma mark - 静态方法

/**
 在指定时间段，显示固定指定消息
 如果time不为0，则只显示消息内容，在指定时间后自动隐藏toast，适用于显示错误消息
 如果time等于0，则显示消息内容和读取指示器，需要自己调用hideToast，适用于时间不定的加载过程，例如网络加载

 @param msg  消息
 @param time 时间
 */
+ (void)toastMessage:(nullable NSString*)msg forTime:(float)time;


/**
 在指定时间段，显示固定指定消息，指定结束回调
 如果time不为0，则只显示消息内容，在指定时间后自动隐藏toast，适用于显示错误消息
 如果time等于0，则显示消息内容和读取指示器，需要自己调用hideToast，适用于时间不定的加载过程，例如网络加载
 
 @param msg               消息
 @param time              时间
 @param completionHandler 回调
 */
+ (void)toastMessage:(nullable NSString*)msg forTime:(float)time withCompletionHandler:(nullable void(^)())completionHandler;


/**
 在指定视图，指定时间段，显示固定指定消息
 如果time不为0，则只显示消息内容，在指定时间后自动隐藏toast，适用于显示错误消息
 如果time等于0，则显示消息内容和读取指示器，需要自己调用hideToast，适用于时间不定的加载过程，例如网络加载
 
 @param msg  消息
 @param view 视图
 @param time 时间
 */
+ (void)toastMessage:(nullable NSString*)msg inView:(nonnull UIView*)view forTime:(float)time;


/**
 在指定视图，指定时间段，显示固定指定消息，指定结束回调
 如果time不为0，则只显示消息内容，在指定时间后自动隐藏toast，适用于显示错误消息
 如果time等于0，则显示消息内容和读取指示器，需要自己调用hideToast，适用于时间不定的加载过程，例如网络加载
 
 @param msg               消息
 @param view              视图
 @param time              时间
 @param completionHandler 回调
 */
+ (void)toastMessage:(nullable NSString*)msg inView:(nonnull UIView*)view
             forTime:(float)time withCompletionHandler:(nullable void(^)())completionHandler;


/**
 隐藏Toast
 */
+ (void)hideToast;


#pragma mark - 对象方法

/**
 结束回调
 */
@property (strong, nonatomic, nullable) void(^completionHandler)(void);

/**
 在指定视图，指定时间段，显示固定指定消息，指定结束回调
 如果time不为0，则只显示消息内容，在指定时间后自动隐藏toast，适用于显示错误消息
 如果time等于0，则显示消息内容和读取指示器，需要自己调用hideToast，适用于时间不定的加载过程，例如网络加载

 @param view              视图
 @param msg               消息
 @param time              时间
 @param completionHandler 回调
 */
- (void)showToastInView:(nonnull UIView*)view withMessage:(nullable  NSString*)msg
                 inTime:(float)time withCompletionHandler:(nullable void(^)())completionHandler;

/**
 隐藏Toast
 */
- (void)hideToast;

@end
