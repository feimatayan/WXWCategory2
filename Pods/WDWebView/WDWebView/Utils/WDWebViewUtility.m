//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebViewUtility.h"
#import <UIKit/UIKit.h>
#import "WDWebViewDef.h"
#import <WebKit/WebKit.h>

@interface WDWebViewUtility ()

@property (nonatomic, nullable, strong)  WKWebView* webView;

@end



@implementation WDWebViewUtility

static WDWebViewUtility *_tmpUtility = nil;

+ (NSString *)defaultUserAgent {
    _tmpUtility = [WDWebViewUtility new];
    __block NSString *userAgent = nil;
    
    // 先通过 KVC  获取
    dispatch_main_sync_safe(^{
        userAgent = [_tmpUtility.webView valueForKey:@"userAgent"];
    });
    if(userAgent.length > 0) {
        _tmpUtility.webView = nil;
        _tmpUtility = nil;
        return userAgent;
    }

    // 如果 KVC 取不到，再通过执行 JS 去取
    dispatch_main_sync_safe(^{
        [_tmpUtility.webView loadHTMLString:@"<html></html>" baseURL:nil];
        [_tmpUtility.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"result is = %@",result);
            _tmpUtility.webView = nil;
            _tmpUtility= nil;
            userAgent = result;
            // 退出runloop，由于是主线程，runloop退出后，又会自动加入
            CFRunLoopStop(CFRunLoopGetCurrent());
        }];
    });
    // CFRunLoopRun() 本质是个 do-while, 这时候下面的代码执行在 RunLoop 退出前不执行以下代码
    CFRunLoopRun();
    return userAgent;
    
}

+ (UIViewController *)hostViewControllerFromView:(UIView *)view {
    UIResponder *responder = view;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *) responder;
}

+ (BOOL)url:(NSURL *)url isMatchPattern:(NSString *)pattern {
    if ([[url absoluteString] length] <= 0) {
        return NO;
    }
    if (![pattern length]) {
        //当正则表达式为空字符串是，可匹配任意URL
        return YES;
    }
    NSString *wdURLPattern = pattern;
    NSError *error;
    NSRegularExpression *wdDomainExpression = [NSRegularExpression regularExpressionWithPattern:wdURLPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [wdDomainExpression matchesInString:url.absoluteString options:NSMatchingReportProgress range:NSMakeRange(0, url.absoluteString.length)];
    
    return (matches && matches.count > 0);
}

+ (BOOL)openURL:(NSURL *)url responder:(UIResponder *)responder {
    if (!url || !responder || ![responder isKindOfClass:[UIResponder class]]) {
        return NO;
    }
    while (responder) {
        if (![responder isKindOfClass:[UIApplication class]]) {
            responder = responder.nextResponder;
            continue;
        }
        UIApplication *application = (UIApplication *) responder;
        if([application respondsToSelector:@selector(openURL:)]){
            [application performSelector:@selector(openURL:) withObject:url];
            return YES;
        }
    }
    return NO;
}

-(WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    return _webView;
}



@end
