//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDWebView.h"

@interface WDWebView (dispatchCenter)
- (BOOL)dispatchWebView:(UIView <WDWebViewProtocol> *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(WDNWebViewNavigationType)navigationType;

- (void)dispatchWebViewDidStartLoad:(UIView <WDWebViewProtocol> *)webView;

- (void)dispatchWebViewDidFinishLoad:(UIView <WDWebViewProtocol> *)webView;

- (void)dispatchWebView:(UIView <WDWebViewProtocol> *)webView didFailLoadWithError:(NSError *)error;
@end