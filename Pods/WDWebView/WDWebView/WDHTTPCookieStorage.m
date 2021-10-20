//
// Created by 石恒智 on 2018/4/13.
//

#import "WDHTTPCookieStorage.h"
#import <WebKit/WebKit.h>
#import "WDWebViewDef.h"
#import "WDWebView.h"
#import "WDWWeakTimer.h"
#import "WDWebViewConfig.h"

@interface WDHTTPCookieStorage () <WKHTTPCookieStoreObserver>
@property(nonatomic, strong) WDWebView *webview;
@property(nonatomic, strong) WDWWeakTimer *setCookieDelayTimer;
@property(nonatomic, strong) WDWWeakTimer *deleteCookieDelayTimer;
@end

@implementation WDHTTPCookieStorage

+ (instancetype)defaultCookieStorage {
    static WDHTTPCookieStorage *singletonObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[WDHTTPCookieStorage alloc] init];
    });
    return singletonObject;
}

- (void)getAllCookies:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler {
    [self getAllCookiesByType:WDHTTPCookieStorageTypeNSHTTPCookieStore
              completionBlock:completionHandler];
}

- (void)getAllCookiesByType:(WDHTTPCookieStorageType)cookieStoreType
            completionBlock:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler {
    void (^tempCompletionHandler)(NSArray<NSHTTPCookie *> *) = [completionHandler copy];

    switch (cookieStoreType) {
        case WDHTTPCookieStorageTypeNSHTTPCookieStore: {
            NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
            if (tempCompletionHandler) {
                tempCompletionHandler(cookies);
            }
            break;
        }
        case WDHTTPCookieStorageTypeWKHTTPCookieStore: {
            if ([self isWKCookieManageEnable]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WKHTTPCookieStore *wkHttpCookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
                    [wkHttpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *array) {
                        if (tempCompletionHandler) {
                            tempCompletionHandler(array);
                        }
                    }];
                });
            } else {
                // iOS 10 直接返回之前存储的 Cookie
                NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
                if (tempCompletionHandler) {
                    tempCompletionHandler(cookies);
                }
            }
            break;
        }
    }
}

- (void)setCookie:(NSHTTPCookie *)cookie completionHandler:(nullable void (^)(BOOL isSuccess))completionHandler {

    void (^completionHandlerLocal)(BOOL isSuccess) = [completionHandler copy];
    if (![cookie isKindOfClass:[NSHTTPCookie class]]) {
        if (completionHandlerLocal) {
            completionHandlerLocal(NO);
        }
        return;
    }

    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

    if ([self isWKCookieManageEnable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WKHTTPCookieStore *wkHttpCookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
            [wkHttpCookieStore setCookie:cookie
                       completionHandler:^{
                           if (completionHandlerLocal) {
                               completionHandlerLocal(YES);
                           }
                       }];
            [self delayLoadWebViewWhenSetCookie];
        });

        return;
    }
    if (completionHandlerLocal) {
        completionHandlerLocal(YES);
    }
}

- (void)deleteCookie:(NSHTTPCookie *)cookie completionHandler:(nullable void (^)(BOOL isSuccess))completionHandler {
    void (^completionHandlerLocal)(BOOL isSuccess) = [completionHandler copy];
    if (![cookie isKindOfClass:[NSHTTPCookie class]]) {
        if (completionHandlerLocal) {
            completionHandlerLocal(NO);
        }
        return;
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];

    if ([self isWKCookieManageEnable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WKHTTPCookieStore *wkHttpCookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
            [wkHttpCookieStore deleteCookie:cookie
                          completionHandler:^{
                              if (completionHandlerLocal) {
                                  completionHandlerLocal(YES);
                              }
                          }];
            [self delayLoadWebViewWhenDeleteCookie];
        });
        return;
    }
    if (completionHandlerLocal) {
        completionHandlerLocal(YES);
    }
}

- (void)clearAllCookie:(nullable void (^)(void))completionHandler {
    void (^completionHandlerLocal)(void) = [completionHandler copy];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = cookieStorage.cookies;
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }

    if ([self isWKCookieManageEnable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WKHTTPCookieStore *wkHttpCookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
            [wkHttpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *array) {
                for (NSHTTPCookie *cookie in array) {
                    dispatch_main_async_safe(^{
                        [wkHttpCookieStore deleteCookie:cookie
                                      completionHandler:^{
                                          if (completionHandlerLocal) {
                                              completionHandlerLocal();
                                          }
                                      }];
                    });
                }
            }];
        });
        [self delayLoadWebViewWhenDeleteCookie];
        return;
    }
    if (completionHandlerLocal) {
        completionHandlerLocal();
    }
}

- (BOOL)isWKCookieManageEnable {
    return [WDWebViewConfig sharedInstance].enableWKHTTPCookieManage && ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0);
}

#pragma mark -- Instance method

- (void)delayLoadWebViewWhenSetCookie {
    if (_setCookieDelayTimer) {
        [_setCookieDelayTimer invalidate];
        _setCookieDelayTimer = nil;
    }
    _setCookieDelayTimer = [WDWWeakTimer scheduledTimerWithTimeInterval:0.25
                                                                 target:self
                                                               selector:@selector(loadWebView)
                                                               userInfo:nil
                                                                repeats:NO
                                                          dispatchQueue:dispatch_get_main_queue()];
}

- (void)delayLoadWebViewWhenDeleteCookie {
    if (_deleteCookieDelayTimer) {
        [_deleteCookieDelayTimer invalidate];
        _deleteCookieDelayTimer = nil;
    }
    _deleteCookieDelayTimer = [WDWWeakTimer scheduledTimerWithTimeInterval:0.25
                                                                    target:self
                                                                  selector:@selector(loadWebView)
                                                                  userInfo:nil
                                                                   repeats:NO
                                                             dispatchQueue:dispatch_get_main_queue()];
}

+ (NSString *)jsCookieStringForCookies:(NSArray<NSHTTPCookie *> *)cookies{
    NSMutableString *result = [NSMutableString string];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    dateFormatter.dateFormat = @"EEE, d MMM yyyy HH:mm:ss zzz";
    
    for (NSHTTPCookie *cookie in cookies) {
        [result appendString:[NSString stringWithFormat:@"document.cookie=%@=%@; domain=%@; path=%@", cookie.name,cookie.value,cookie.domain,cookie.path]];
        if(cookie.expiresDate){
            [result appendString:[NSString stringWithFormat:@"; expires=%@",[dateFormatter stringFromDate:cookie.expiresDate]]];
        }
        if(cookie.secure){
            [result appendString: @"; secure"];
        }
        [result appendString:@"; "];
        
    }
    return result.copy;
}

- (void)loadWebView {
    [self.webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

#pragma mark -- Getter

- (WDWebView *)webview {
    if (!_webview) {
        _webview = [WDWebView wkWebViewWithFrame:CGRectZero];
    }
    return _webview;
}

@end
