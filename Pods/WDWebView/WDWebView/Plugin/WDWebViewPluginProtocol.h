//
// Created by 石恒智 on 2017/12/19.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDWebViewProtocol.h"

@protocol WDWebViewConfigureProtocol;

@protocol WDWebViewPluginProtocol <NSObject>

@optional

/**
 当该插件被注册进WebView后会调用该方法，可以在该方法中完成一些初始化操作

 @param plugin 插件实例
 @param webView 注册该插件的WebView
 @param configuration 可通过该Configure对WebView进行配置
 */
- (void)registerPlugin:(id <WDWebViewPluginProtocol>)plugin
             toWebView:(UIView <WDWebViewProtocol> *)webView
         withConfigure:(id <WDWebViewConfigureProtocol>)configuration;

- (void)unregisterPlugin:(id <WDWebViewPluginProtocol>)plugin
               toWebView:(UIView <WDWebViewProtocol> *)webView
           withConfigure:(id<WDWebViewConfigureProtocol>)configuration;


/**
 判断是否加载该request，可以通过这个方法终止请求的加载
 当返回YES时请求会继续加载，当返回NO时请求将终止加载
 当请求终止后，其它实现该方法的插件或代理将不会调用

 @param webView 加载页面的WebView
 @param request 请求参数
 @param navigationType 加载类型
 @return YES加载继续，NO加载终止
 */
- (BOOL)        wdpWebView:(UIView <WDWebViewProtocol> *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(WDNWebViewNavigationType)navigationType;

- (void)wdpWebViewDidStartLoad:(UIView <WDWebViewProtocol> *)webView;

- (void)wdpWebViewDidFinishLoad:(UIView <WDWebViewProtocol> *)webView;

- (void)  wdpWebView:(UIView <WDWebViewProtocol> *)webView
didFailLoadWithError:(NSError *)error;
//TODO:加入回调，让插件可操作性更加丰富
@end
