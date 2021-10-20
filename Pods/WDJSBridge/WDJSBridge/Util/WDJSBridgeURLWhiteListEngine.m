//
// Created by 石恒智 on 2018/6/4.
// Copyright (c) 2018 weidian. All rights reserved.
//

#import "WDJSBridgeURLWhiteListEngine.h"

NSString const *kWDJSBridgeDefaultURLPattern = @"^(http|https)://([^/\\?#]+\\.)*((vdian|weidian|koudai|youshop|geilicdn|qq|ruyu|alipay|91ruyu|bibikan|duiba|duibapre|fangxin|ynet|youshop01|youshop02|youshop03|youshop04|youshop05|youshop06|youshop07|youshop08|youshop09|youshop10|kou6ai|xihuan)\\.(com|net|cn|com.cn))([\\?|#|/|:].*)?$";

@implementation WDJSBridgeURLWhiteListEngine

+ (BOOL)isURLTrusted:(NSURL *)url withURLPattern:(NSString *)urlPattern {
    if ([url.absoluteString length]) {
        NSString *wdURLPattern = urlPattern;
        if (![wdURLPattern length]) {
            wdURLPattern = [kWDJSBridgeDefaultURLPattern copy];
        }
        
        //http://www.weidian.com:w@www.weibo.com 以下代码避免这样的url越过校验
        NSString *host = url.host;
        NSString *scheme = url.scheme;
        
        NSURLComponents *urlComponents = [NSURLComponents new];
        urlComponents.scheme = scheme;
        urlComponents.host = host;
        NSURL *realURL = urlComponents.URL;
        
        NSError *error;
        NSRegularExpression *wdDomainExpression = [NSRegularExpression regularExpressionWithPattern:wdURLPattern options:NSRegularExpressionCaseInsensitive error:&error];

        NSArray *matches = [wdDomainExpression matchesInString:realURL.absoluteString
                                                       options:NSMatchingReportProgress
                                                         range:NSMakeRange(0, realURL.absoluteString.length)];

        if (matches && matches.count > 0) {
            return YES;
        }
        return NO;
    } else{
        //    return NO;
        //暂时对调用域的控制放宽一点，避免误伤。等上线后通过埋点数据观察，如果不存在误伤，则收紧调用域的监测，即域名为空时不允许调用jsbridge。
        //具体为空的原因见文档:http://docs.vdian.net/pages/viewpage.action?pageId=61383354
        return YES;
    }
}

@end
