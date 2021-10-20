//
// Created by chunlin ran on 2017/12/5.
// Copyright (c) 2017 Weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WDNWebViewNavigationType) {
    WDNWebViewNavigationTypeLinkClicked,
    WDNWebViewNavigationTypeFormSubmitted,
    WDNWebViewNavigationTypeBackForward,
    WDNWebViewNavigationTypeReload,
    WDNWebViewNavigationTypeFormResubmitted,
    WDNWebViewNavigationTypeOther
};
@protocol WDWebViewProtocol;

@protocol WDNWebViewDelegate <NSObject>
@optional
- (BOOL)wdWebView:(UIView <WDWebViewProtocol> *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WDNWebViewNavigationType)navigationType;

- (void)wdWebViewDidStartLoad:(UIView <WDWebViewProtocol> *)webView;

- (void)wdWebViewDidFinishLoad:(UIView <WDWebViewProtocol> *)webView;

- (void)wdWebView:(UIView <WDWebViewProtocol> *)webView didFailLoadWithError:(NSError *)error;

- (void)wdWebView:(UIView <WDWebViewProtocol> *)webView updateTitle:(NSString *)title;

@end


@protocol WDWebViewProtocol <NSObject>

@property(nonatomic, weak) id <WDNWebViewDelegate> delegate;
@property(nonatomic, readonly, strong) UIScrollView *scrollView;
@property(nonatomic, readonly, strong) NSURL *URL;
@property(nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property(nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
@property(nonatomic, readonly, getter=isLoading) BOOL loading;
@property(nonatomic, readonly, strong) UIView *realWebView;
@property(nonatomic, readonly, strong) NSString *title;
@property(nonatomic, readonly, strong) NSURL *loadingURL;

/*! @abstract A Boolean value indicating whether horizontal swipe gestures
 will trigger backward list navigations.
 @discussion The default value is YES.
 */
@property(nonatomic) BOOL allowsBackForwardNavigationGestures;

- (id)loadRequest:(NSURLRequest *)request;

- (void)reload;

- (void)stopLoading;

- (void)goBack;

- (void)goForward;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *error))completionHandler;

@end

