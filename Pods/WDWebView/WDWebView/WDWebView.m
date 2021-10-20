//
// Created by 石恒智 on 2017/12/20.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebView.h"
#import "__WDWKWebView.h"
#import "WDWebViewDef.h"
#import "WDWebViewPluginProtocol.h"
#import "WDWebViewConfig.h"
#import "WDWebViewUtility.h"

@interface WDWebView ()
@end

@implementation WDWebView

- (void)dealloc {
    [self unRegisterAllPlugins];
    WDWebViewLog(@"dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        self.allowsBackForwardNavigationGestures = YES;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (id)loadRequest:(NSURLRequest *)request {
    return nil;
}

- (void)reload {

}

- (void)stopLoading {

}

- (void)goBack {

}

- (void)goForward {

}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *error))completionHandler {

}

- (void)allowsBackForwardNavigationGestures:(BOOL)allowsGestures {

}

- (UIScrollView *)scrollView {
    return nil;
}

- (NSURL *)URL {
    return nil;
}

- (BOOL)canGoBack {
    return NO;
}

- (BOOL)canGoForward {
    return NO;
}

- (BOOL)isLoading {
    return NO;
}

#pragma mark -- Getter

- (NSArray *)pluginsArray {
    if (!_pluginsArray) {
        _pluginsArray = [NSArray new];
    }
    return _pluginsArray;
}

- (NSURL *)loadingURL {
    return nil;
}
@synthesize allowsBackForwardNavigationGestures;

@synthesize realWebView;

@end

@implementation WDWebView (Extension)
- (VDWebViewType)webViewType {
    if ([self isKindOfClass:[__WDWKWebView class]]) {
        return VDWebViewTypeWK;
    }
    return VDWebViewTypeUI;
}

- (Class)webViewClass {
    if (!self.realWebView) {
        return nil;
    }
    return [self.realWebView class];
}

@end

@implementation WDWebView (Creation)

+ (instancetype)defaultWebView {
	return [WDWebView defaultWebViewWithFrame:CGRectZero];
}

+ (instancetype)wkWebView {
	return [WDWebView wkWebViewWithFrame:CGRectZero];
}

+ (instancetype)defaultWebViewWithFrame:(CGRect)frame {
    return [self defaultWebViewWithFrame:frame
                        enableUrlPattern:NO
                                 withURL:nil];
}

+ (instancetype)defaultWebViewWithFrame:(CGRect)frame
								withURL:(NSURL*)url{
	return [self defaultWebViewWithFrame:frame
                        enableUrlPattern:YES
                                 withURL:url];
}

+ (instancetype)defaultWebViewWithFrame:(CGRect)frame
                       enableUrlPattern:(BOOL)enableUrlPattern
                                withURL:(NSURL*)url{
    
    WDWebView *webView = [self wkWebViewWithFrame:frame];
    return webView;
}

+ (instancetype)wkWebViewWithFrame:(CGRect)frame {
	return [self wkWebViewWithFrame:frame disableMenu:NO disablePreviw:NO];
}

+ (instancetype)wkWebViewWithFrame:(CGRect)frame disableMenu:(BOOL)disableMenu disablePreviw:(BOOL)disablePreview {
    __WDWKWebView *webView = [[__WDWKWebView alloc] initWithFrame:frame disableMenu:disableMenu disablePreviw:disablePreview];
    return webView;
}

+ (BOOL)canUseWKWebViewWithURL:(NSURL *)url{
	if(![WDWebViewConfig sharedInstance].enableWKWebViewWhitListControl){
		return YES;
	}
	if([[WDWebViewConfig sharedInstance].wkwebViewWhiteListPattern length] == 0){
		return YES;
	}
	if(!url){
		return NO;
	}
	return [WDWebViewUtility url:url isMatchPattern:[WDWebViewConfig sharedInstance].wkwebViewWhiteListPattern];
}

@end

@implementation WDWebView (WK)

+ (BOOL)registerClass:(NSString *)className forSchema:(NSString *)schema
{
	if (!className || className.length <= 0) {
		return NO;
	}

	if (!schema || schema.length <= 0) {
		return NO;
	}

	[[WDWKWebViewManager instance].schmaHandlerClasses setObject:className forKey:schema];

	return YES;
}

+ (BOOL)unregisterClassForSchema:(NSString *)schema
{
	if (!schema || schema.length <= 0) {
		return NO;
	}

	[[WDWKWebViewManager instance].schmaHandlerClasses removeObjectForKey:schema];

	return YES;
}

+ (void)unregisterAllClasses
{
	[[WDWKWebViewManager instance].schmaHandlerClasses removeAllObjects];
}

@end
