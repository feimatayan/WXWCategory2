//
// Created by 石恒智 on 2017/12/20.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDWebViewProtocol.h"
#import "WDWebViewDefine.h"
#import "WDWebViewConfigureProtocol.h"

@protocol WDWebViewPluginProtocol;

@interface WDWebView : UIView <WDWebViewProtocol>

@property(nonatomic, weak) id <WDNWebViewDelegate> delegate;

@property(nonatomic, strong) NSArray<NSObject <WDWebViewPluginProtocol> *> *pluginsArray;

/**
 获取该H5页面的Title，可以通过KVO的方式监听，也可以通过实现WebView代理的方式获取新的Title
 */
@property(nonatomic, strong) NSString *title;
@end

@interface WDWebView (Creation)

/**
 * 初始化一个适合当前环境的WebView内核的WDWebView，并指定frame值
 * 实际是一个 WKWebView
 * 不受[WDWebViewConfig sharedInstance].defaultWebViewType参数干预
 * @param frame View的Frame
 * @return 合适内核的WDWebView
 */
+ (instancetype)defaultWebViewWithFrame:(CGRect)frame;

/**
* 初始化一个内核为WKWebView的WDWebView，并指定frame值
* @param frame View的Frame
* @return 以WKWebView为内核的WDWebView
*/
+ (instancetype)wkWebViewWithFrame:(CGRect)frame;


/// 初始化一个内核为WKWebView的WDWebView，并指定frame值
/// @param frame View的Frame
/// @param disableMenu 禁用长按上下文菜单
/// @param disablePreview 禁用长按预览
+ (instancetype)wkWebViewWithFrame:(CGRect)frame disableMenu:(BOOL)disableMenu disablePreviw:(BOOL)disablePreview;

/**
 * 当开启WKWebView白名单控制时，传入需要加载的URL初始化Webview,如果url为空则只会返回UIWebView内核的WDWebView
 * @param frame frame
 * @param url 本 Webview 需要加载的URL
 * @return 合适内核的WDWebView
 */
+ (instancetype)defaultWebViewWithFrame:(CGRect)frame
                                withURL:(NSURL *)url;


/**
* 初始化一个适合当前环境的WebView内核的WDWebView,frame为CGRectZero.
 * 实际是一个 WKWebView
 * 不受[WDWebViewConfig sharedInstance].defaultWebViewType参数干预
* @return 合适内核的WDWebView
*/
+ (instancetype)defaultWebView __attribute__((deprecated("Use defaultWebViewWithFrame: instead.")));

/**
* 初始化一个内核为WKWebView的WDWebView,frame为CGRectZero.
* @return 以WKWebView为内核的WDWebView
*/
+ (instancetype)wkWebView __attribute__((deprecated("Use wkWebViewWithFrame: instead.")));

@end

@interface WDWebView (plugins)


/**
 向WebView中注册插件，先注册的插件优先级越高
 高优先级插件实现的协议方法将优先被调用

 @param plugin 插件实例
 @return 是否注册成功，YES注册成功，NO注册失败
 */
- (BOOL)registerPlugin:(id <WDWebViewPluginProtocol>)plugin;

- (BOOL)unRegisterPlugin:(id <WDWebViewPluginProtocol>)plugin;

- (void)unRegisterAllPlugins;

@end

@interface WDWebView (Extension)

- (VDWebViewType)webViewType;

- (Class)webViewClass;

@end

@interface WDWebView (Setup)

/**
 WDWebView环境的初始化，主要用于UserAgent和环境的初始化

 @param appName app的简称
 @param appId appIdentifier
 @param envType 环境
 */
+ (void)setupWithAppName:(NSString *)appName
                   appId:(NSString *)appId
                     env:(WDWebViewEnvType)envType;

@end

@interface WDWebView (UserAgent)
/**
 增加UserAgent字段，多个UserAgent请调用多次该方法，不可一次性添加

 @param userAgent 需要添加的字段，不可含有空格符
 */
+ (void)appendUserAgent:(NSString *)userAgent;

/**
 删除UserAgent字段，多个UserAgent请调用多次该方法，不可一次性删除

 @param userAgent 需要删除的字段，不可含有空格符
 */
+ (void)removeUserAgent:(NSString *)userAgent;

/**
 保存整个UserAgent字段

 @param userAgent userAgent 完整的UserAgent
 */
+ (void)saveUserAgent:(NSString *)userAgent;

/**
 获取当前UserAgent
 */
+ (NSString *)currentUserAgent;

@end

@interface WDWebView (WK)

/**
 注册自定义schema的处理类
 iOS11以上系统有效
 @param className 类名
 @param schema 自定义的schema
 */
+ (BOOL)registerClass:(NSString *)className forSchema:(NSString *)schema API_AVAILABLE(macosx(10.13), ios(11.0));

/**
 注销自定义schema处理类
 iOS11以上系统有效
 @param schema 自定义的schema
 */
+ (BOOL)unregisterClassForSchema:(NSString *)schema API_AVAILABLE(macosx(10.13), ios(11.0));

/**
 注销所有自定义schema处理
 iOS11以上系统有效
 */
+ (void)unregisterAllClasses API_AVAILABLE(macosx(10.13), ios(11.0));

@end
