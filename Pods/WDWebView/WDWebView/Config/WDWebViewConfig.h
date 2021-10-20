//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDWebViewDefine.h"
#import "WDWebViewConfigureProtocol.h"

typedef NS_ENUM(NSUInteger, WDWebViewConfigDefaultWebViewType){
    WDWebViewConfigDefaultWebViewTypeDefault = 1,
    WDWebViewConfigDefaultWebViewTypeWK,
    WDWebViewConfigDefaultWebViewTypeUI,
};

@interface WDWebViewConfig : NSObject

+ (instancetype)sharedInstance;

/// 当前app名称
@property(nonatomic, strong) NSString *appName;
// appId
@property(nonatomic, copy) NSString *appId;
/// 系统默认的UA
@property(nonatomic, strong) NSString *defaultUserAgent;
/// 修改之后的UA
@property(nonatomic, strong) NSString *currentUserAgent;
/// webView超时时间
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
/// webView缓存策略
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
/// 环境
@property(nonatomic, assign) WDWebViewEnvType envType;

@property(nonatomic, assign) WDWebViewConfigDefaultWebViewType defaultWebViewType;

/**
 * 是否进行WKWebView相关的Cookie操作，默认为YES
 * 不建议操作该值，可能导致WKWebView的Cookie不同步的问题
 */
@property(nonatomic, assign) BOOL enableWKHTTPCookieManage;

/**
 * WKWebView白名单控制开关，默认为关闭状态
 */
@property(nonatomic, assign) BOOL enableWKWebViewWhitListControl;

/**
 * WKWebView白名单控制的URL正则表达式，当白名单控制开关开启时，可通过传入URL由SDK决定是否使用WKWebView，仅对[WDWebView defaultWebView]有效。
 * 与@enableWKWebViewWhitListControl 搭配使用
 * 当enableWKWebViewWhitListControl为YES时，wkwebViewWhiteListPattern为空值，结果将与enableWKWebViewWhitListControl=NO 表现一致，即白名单不生效。
 */
@property(nonatomic, copy) NSString *wkwebViewWhiteListPattern;

- (void)registerUserAgent;
@end
