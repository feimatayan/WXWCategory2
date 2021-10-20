//
// Created by 石恒智 on 2017/12/20.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "__WDWKWebView.h"
#import "WDWebView+dispatchCenter.h"
#import "WDWebViewDef.h"
#import "WDWebViewConfig.h"
#import "WDWebViewUtility.h"
#import <WebKit/WebKit.h>
#import "WDHTTPCookieStorage.h"

@interface WDWKWebViewManager ()

@property(nonatomic, strong) WKProcessPool *processPool;

@end

@implementation WDWKWebViewManager

+ (WDWKWebViewManager *)instance {
    static WDWKWebViewManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _processPool = [[WKProcessPool alloc] init];
		_schmaHandlerClasses = [NSMutableDictionary dictionary];
    }

    return self;
}

@end

@interface __WDWKWebView () <WKNavigationDelegate, WKUIDelegate, WKHTTPCookieStoreObserver>
@property(nonatomic, weak) WKWebView *webView;
@property(nonatomic, weak) UIViewController *hostViewController;

@property (nonatomic, assign) BOOL disableMenu;
@end

@implementation __WDWKWebView
@synthesize loadingURL = _loadingURL;

- (void)dealloc {
//    [self deleteCookies];
    [self.webView removeObserver:self
                      forKeyPath:@"title"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame disableMenu:NO disablePreviw:NO];
}

-(instancetype)initWithFrame:(CGRect)frame disableMenu:(BOOL)disableMenu disablePreviw:(BOOL)disablePreview {
    self = [super initWithFrame:frame];
    if (self) {
        __block WKWebViewConfiguration *configuration = [self webViewConfig];
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        configuration.allowsInlineMediaPlayback = YES;
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];

        if (@available(iOS 11.0, *)) {
            [[WDWKWebViewManager instance].schmaHandlerClasses enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull schema, NSString * _Nonnull className, BOOL * _Nonnull stop) {
                Class cls = NSClassFromString(className);
                if (cls != nil) {
                    [configuration setURLSchemeHandler:[[cls alloc] init] forURLScheme:schema];
                }
            }];
        } else {
            // iOS 10 通过document.cookie设置Cookie解决后续页面(同域)Ajax、iframe请求的Cookie问题；
            WKUserScript *script = [[WKUserScript alloc] initWithSource:[WDHTTPCookieStorage jsCookieStringForCookies:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
                       [userContentController addUserScript:script];
        }
        
        if(disableMenu){
            WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:[self disableMenuJS] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            [userContentController addUserScript:noneSelectScript];
        }
        
        configuration.userContentController = userContentController;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame
                                                configuration:configuration];
        webView.allowsBackForwardNavigationGestures = YES;
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.allowsLinkPreview = !disablePreview;
        
        self.disableMenu = disableMenu;
        
        _webView = webView;
        [self addSubview:webView];
        if ([_webView.scrollView respondsToSelector:@selector(contentInsetAdjustmentBehavior)]) {
            [_webView.scrollView performSelector:@selector(setContentInsetAdjustmentBehavior:) withObject:@(2)];
        }

        [_webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _webView.frame = self.bounds;
}

- (id)loadRequest:(NSURLRequest *)request {
    if (@available(iOS 9.0, *)) {
        _webView.customUserAgent = [WDWebViewConfig sharedInstance].currentUserAgent;
    } else {
        // Fallback on earlier versions
    }
    
    if(UIDevice.currentDevice.systemVersion.floatValue < 11.0) {
        /// 首次请求带上 Cookie
        NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage.sharedHTTPCookieStorage cookiesForURL:request.URL];
        if(cookies.count == 0){
            // 如果已经有了就不加了
            cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies;
            NSDictionary<NSString *, NSString *> *headerFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            NSMutableURLRequest *webRequest = (NSMutableURLRequest *)request.mutableCopy;
            NSMutableDictionary *orginaleFileds = webRequest.allHTTPHeaderFields.mutableCopy;
            [orginaleFileds addEntriesFromDictionary:headerFields];
            webRequest.allHTTPHeaderFields = orginaleFileds.copy;
            return [_webView loadRequest:webRequest];
        }
        
    }
    
    return [_webView loadRequest:request];
}

- (void)reload {
    [_webView reload];
}

- (void)stopLoading {
    [_webView stopLoading];
}

- (void)goBack {
    [_webView goBack];
}

- (void)goForward {
    [_webView goForward];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *error))completionHandler {
    [_webView evaluateJavaScript:javaScriptString
               completionHandler:completionHandler];
}

- (UIScrollView *)scrollView {
    return _webView.scrollView;
}

- (NSURL *)URL {
    return _webView.URL;
}

- (BOOL)canGoBack {
    return _webView.canGoBack;
}

- (BOOL)canGoForward {
    return _webView.canGoForward;
}

- (BOOL)isLoading {
    return _webView.isLoading;
}

- (UIView *)realWebView {
    return _webView;
}

- (BOOL)allowsBackForwardNavigationGestures {
    return _webView.allowsBackForwardNavigationGestures;
}

- (UIViewController *)hostViewController {
    if (!_hostViewController) {
        _hostViewController = [WDWebViewUtility hostViewControllerFromView:self];
    }
    return _hostViewController;
}

- (NSURL *)loadingURL {
    return _loadingURL;
}

-(NSString *)disableMenuJS {
    NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
    // CSS选中样式取消
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    return javascript;
}

#pragma mark -- Setter

- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures {
    _webView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures;
}

#pragma mark -- WKNavigationDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
	if (!navigationAction.targetFrame.isMainFrame) {
		[webView loadRequest:navigationAction.request];
	}
	
	return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    BOOL result;
    result = [self dispatchWebView:self
        shouldStartLoadWithRequest:navigationAction.request
                    navigationType:(WDNWebViewNavigationType) navigationAction.navigationType];
    if (!result) {
        actionPolicy = WKNavigationActionPolicyCancel;
        decisionHandler(actionPolicy);
        return;
    }

    NSURL *url = navigationAction.request.URL;
    actionPolicy = [self acitonResultForJumpOthers:url];
    if(actionPolicy == WKNavigationActionPolicyAllow){
        _loadingURL = url;
    }
    
    NSArray<NSHTTPCookie *> *targetCookies = [NSHTTPCookieStorage.sharedHTTPCookieStorage cookiesForURL:navigationAction.request.URL];
    if(UIDevice.currentDevice.systemVersion.floatValue < 11.0 && targetCookies.count == 0) { //302，跨域等没有携带cookie的情况
        targetCookies = NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies;
        NSDictionary<NSString *, NSString *> *headerFields = [NSHTTPCookie requestHeaderFieldsWithCookies:targetCookies];
        NSMutableURLRequest *webRequest = (NSMutableURLRequest *)navigationAction.request.mutableCopy;
        NSMutableDictionary *orginaleFileds = webRequest.allHTTPHeaderFields.mutableCopy;
        [orginaleFileds addEntriesFromDictionary:headerFields];
        webRequest.allHTTPHeaderFields = orginaleFileds.copy;
    }

    decisionHandler(actionPolicy);
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [self dispatchWebViewDidStartLoad:self];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self dispatchWebViewDidFinishLoad:self];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error {
    [self dispatchWebView:self
     didFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	[self dispatchWebView:self
	 didFailLoadWithError:error];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

#pragma mark -- WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }]];
    // 判断 VC 是否可见 https://stackoverflow.com/a/2777460
    if(self.hostViewController.viewIfLoaded.window){
        [self.hostViewController presentViewController:alert animated:YES completion:nil];
    } else {
        completionHandler();
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }]];
    [self.hostViewController presentViewController:alert
                                          animated:YES
                                        completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *__nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:defaultText message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.textColor = [UIColor whiteColor];
    }];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];

    [self.hostViewController presentViewController:alert animated:YES completion:NULL];
}

- (void)setCookieForIOS11 {
    if (([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)) {
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        __block int count = cookieStorage.cookies.count;
//        WDWebViewLog(@"cookieStore %@", cookieStore);
//        WDWebViewLog(@"NSHTTPCookieStorage count:%d", count);
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            [cookieStore setCookie:cookie completionHandler:nil];
        }
    }
}

- (WKWebViewConfiguration *)webViewConfig {
    WKWebViewConfiguration *webViewConfig = [WKWebViewConfiguration new];
    webViewConfig.processPool = [WDWKWebViewManager instance].processPool;
    if (([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)) {
        webViewConfig.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    }

    return webViewConfig;
}

- (void)deleteCookies {
    if (([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)) {
        WKHTTPCookieStore *cookieStore = _webView.configuration.websiteDataStore.httpCookieStore;
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *array) {
//            __block NSInteger index = 0;
//            WDWebViewLog(@"Try to delete cookies with count:%d", array.count);
            for (NSHTTPCookie *cookie in array) {
                [cookieStore deleteCookie:cookie
                        completionHandler:^() {
//                            WDWebViewLog(@"delete cookie success with Index : %d", index++);
                        }];
            }
        }];
    }
}

- (WKNavigationActionPolicy)acitonResultForJumpOthers:(NSURL *)url {
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    if ([[url host] isEqualToString:@"itunes.apple.com"] && [WDWebViewUtility openURL:url responder:self]) {
        actionPolicy = WKNavigationActionPolicyCancel;
    }else if(url.absoluteString && [url.absoluteString hasPrefix:@"tel:"] && [WDWebViewUtility openURL:url responder:self]){
        actionPolicy = WKNavigationActionPolicyCancel;
    }else if(url.absoluteString && [url.absoluteString hasPrefix:@"kdweidian:"] && [WDWebViewUtility openURL:url responder:self]){
        actionPolicy = WKNavigationActionPolicyCancel;
    }
    return actionPolicy;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object != _webView) {
        return;
    }

    if ([keyPath isEqualToString:@"title"]) {
        self.title = _webView.title;
        if (self.delegate && [self.delegate respondsToSelector:@selector(wdWebView:updateTitle:)]) {
            [self.delegate wdWebView:self
                         updateTitle:self.title];
        }
        return;
    }
}

-(NSString *)encodeChineseString:(NSString *)targetString {
    NSString *result  = [targetString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return result;
}

@end
