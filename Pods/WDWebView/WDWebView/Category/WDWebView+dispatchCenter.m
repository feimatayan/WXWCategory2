//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebView+dispatchCenter.h"
#import "WDWebViewPluginProtocol.h"

@implementation WDWebView (dispatchCenter)

- (BOOL)   dispatchWebView:(UIView <WDWebViewProtocol> *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(WDNWebViewNavigationType)navigationType {
    __block BOOL result = YES;
    [self.pluginsArray enumerateObjectsUsingBlock:^(id <WDWebViewPluginProtocol> obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(wdpWebView:shouldStartLoadWithRequest:navigationType:)]) {
            result = [obj wdpWebView:webView
          shouldStartLoadWithRequest:request
                      navigationType:navigationType];
            if (!result) {
                *stop = YES;
            }
        }
    }];

    if (result && self.delegate && [self.delegate respondsToSelector:@selector(wdWebView:shouldStartLoadWithRequest:navigationType:)]) {
        result = [self.delegate wdWebView:webView
               shouldStartLoadWithRequest:request
                           navigationType:navigationType];
    }
    return result;
}

- (void)dispatchWebViewDidStartLoad:(UIView <WDWebViewProtocol> *)webView {
    [self.pluginsArray enumerateObjectsUsingBlock:^(id <WDWebViewPluginProtocol> obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(wdpWebViewDidStartLoad:)]) {
            [obj wdpWebViewDidStartLoad:webView];
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wdWebViewDidStartLoad:)]) {
        [self.delegate wdWebViewDidStartLoad:self];
    }
}

- (void)dispatchWebViewDidFinishLoad:(UIView <WDWebViewProtocol> *)webView {
    [self.pluginsArray enumerateObjectsUsingBlock:^(id <WDWebViewPluginProtocol> obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(wdpWebViewDidFinishLoad:)]) {
            [obj wdpWebViewDidFinishLoad:webView];
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wdWebViewDidFinishLoad:)]) {
        [self.delegate wdWebViewDidFinishLoad:self];
    }
}

- (void)dispatchWebView:(UIView <WDWebViewProtocol> *)webView
   didFailLoadWithError:(NSError *)error {
    [self.pluginsArray enumerateObjectsUsingBlock:^(id <WDWebViewPluginProtocol> obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(wdpWebView:didFailLoadWithError:)]) {
            [obj wdpWebView:webView didFailLoadWithError:error];
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wdWebView:didFailLoadWithError:)]) {
        [self.delegate wdWebView:self didFailLoadWithError:error];
    }
}
@end