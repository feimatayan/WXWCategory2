//
//  ViewController.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/2/10.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLIMNavigationBar.h"

/*
 viewWillAppear 中包含数据修复指令的检测
 指令来源于信谱系统 线上主动修改NSUserDefault中的值
 */
#define GLIM_NEED_REPAIR_DB @"GLIM_NEED_REPAIR_DB"
@interface GLIMBaseViewController : UIViewController

- (void)leftBarButtonPress:(id)sender;
- (void)checkImLimits;

/// 是否支持使用自定义导航栏，默认为YES，可外部控制
@property (nonatomic, assign) BOOL supportCustomNavigationBar;

/// 自定义导航栏视图
@property (nonatomic, strong) GLIMNavigationBar *customNavigationBar;

/// 控制系统导航栏的显示隐藏，NO:显示 YES:隐藏，仅限非定制导航栏时使用，默认为NO
@property (nonatomic, assign) BOOL imNavigationBarHidden;

@end

@interface GLIMBaseViewController (Network)

/**
 检查网络是否可用

 @return NO: 弹出Toast提示，YES: 不做任何处理
 */
- (BOOL)isNetworkReachable;

/**
 显示请求视图，需要手动隐藏

 @param string 请求提示语
 */
- (void)showLoadingViewWithString:(NSString *)string;
- (void)showLoadingView;

/**
 隐藏请求视图，与showLoadingView对应
 */
- (void)hideLoadingView;

/**
 显示Toast视图，显示时长1秒

 @param string toast提示语
 */
- (void)showToastView:(NSString *)string;

/**
 请求失败，显示重试视图
 */
- (void)showRetryView;
- (void)hideRetryView;

/**
 点击重试视图
 */
- (void)clickedRetryView;

/// 检查IM连接情况，需要的时候使用
- (void)checkImConnectionStatus;

/// 离线提示
- (void)showOfflinePrompt;

- (BOOL)forceShowOfflinePrompt;

@end

@interface GLIMBaseViewController (NavigationBar)

/// 计算导航栏高度
- (CGFloat)navigationBarHeight;
/// 内容视图的偏移值，自定义导航栏时使用
- (CGFloat)contentViewYOffset;
/// 是否使用自定义导航栏，默认为NO
- (BOOL)usingCustomNavigationBar;

/// 是否使用自定义导航栏按钮，默认为NO
- (BOOL)usingCustomNavigationBarRightItems;

@end
