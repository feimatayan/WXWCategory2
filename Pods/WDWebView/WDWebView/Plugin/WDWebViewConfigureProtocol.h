//
// Created by 石恒智 on 2018/3/1.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WDWebViewEnvType) {
    WDWebViewEnvTypeDaily = 1,
    WDWebViewEnvTypePreRelease,
    WDWebViewEnvTypeRelease,
};

typedef NS_ENUM(NSUInteger, WDBWebViewConfigDefaultWebViewType){
    WDBWebViewConfigDefaultWebViewTypeDefualt = 1,
    WDBWebViewConfigDefaultWebViewTypeWK,
    WDBWebViewConfigDefaultWebViewTypeUI,
};

@protocol WDWebViewConfigureProtocol <NSObject>
+ (NSString *)appName;

+ (NSString *)appId;

+ (NSString *)defaultUserAgent;

+ (NSString *)currentUserAgent;

+ (NSTimeInterval)timeoutInterval;

+ (NSURLRequestCachePolicy)cachePolicy;

+ (WDWebViewEnvType)envType;

+ (void)appendUserAgent:(NSString *)subUserAgent;

+ (void)removeUserAgent:(NSString *)subUserAgent;

+ (void)saveUserAgent:(NSString *)userAgent;

+ (void)setTimeoutInterval:(NSTimeInterval)interval;

+ (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy;

+ (void)setDefaultWebViewType:(WDBWebViewConfigDefaultWebViewType)defaultWebViewType;

/**
 * 是否进行WKWebView相关的Cookie操作，默认为YES
 * 不建议操作该值，可能导致WKWebView的Cookie不同步的问题，但可强制不走WKWebView Cookie设置的相关逻辑，便于降级。稳定记个版本后考虑关闭该设置入口
 */
+ (void)setEnableWKHTTPCookieManage:(BOOL)enable;

+ (void)setEnableWKWebViewWhitListControl:(BOOL)enable;

+ (void)setWKWebViewWhiteListPattern:(NSString *)whiteListPattern;

@end
