//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebViewConfigure.h"
#import "WDWebViewConfig.h"
#import "WDWebViewConfigureProtocol.h"

@interface WDWebViewConfigure ()
@end

@implementation WDWebViewConfigure
+ (NSString *)appName {
    return [WDWebViewConfig sharedInstance].appName;
}

+ (NSString *)appId {
    return [WDWebViewConfig sharedInstance].appId;
}

+ (NSString *)defaultUserAgent {
    return [WDWebViewConfig sharedInstance].defaultUserAgent;
}

+ (NSString *)currentUserAgent {
    return [WDWebViewConfig sharedInstance].currentUserAgent;
}

+ (NSTimeInterval)timeoutInterval {
    return [WDWebViewConfig sharedInstance].timeoutInterval;
}

+ (NSURLRequestCachePolicy)cachePolicy {
    return [WDWebViewConfig sharedInstance].cachePolicy;
}

+ (WDWebViewEnvType)envType {
    return [WDWebViewConfig sharedInstance].envType;
}


+ (void)appendUserAgent:(NSString *)subUserAgent {
    NSString *__subUserAgent = [subUserAgent copy];
    if (![__subUserAgent length]) {
        return;
    }

    NSString *currentUserAgent = [self currentUserAgent];
    NSArray *addUserAgentArray = [self splitUserAgent:subUserAgent];
    NSArray *uaArray = [self splitUserAgent:currentUserAgent];

    __block NSMutableArray *tempArrayM = uaArray.mutableCopy;
    [addUserAgentArray enumerateObjectsUsingBlock:^(NSString *addUserAgent, NSUInteger idx, BOOL *stop) {
        if(![tempArrayM containsObject:addUserAgent]){
            [tempArrayM addObject:addUserAgent];
        }
    }];
    NSString *newUserAgent = [tempArrayM componentsJoinedByString:@" "];
    NSDictionary *dictionary = @{@"UserAgent": newUserAgent};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [WDWebViewConfig sharedInstance].currentUserAgent = newUserAgent;
}


+ (void)removeUserAgent:(NSString *)subUserAgent {
    NSString *__subUserAgent = [subUserAgent copy];
    if (![__subUserAgent length]) {
        return;
    }
    NSString *currentUserAgent = [self currentUserAgent];

    NSArray *deleteUserAgentArray = [self splitUserAgent:subUserAgent];
    NSArray *uaArray = [self splitUserAgent:currentUserAgent];
    __block NSMutableArray *tempArrayM = uaArray.mutableCopy;
    [deleteUserAgentArray enumerateObjectsUsingBlock:^(NSString *deleteUserAgent, NSUInteger idx, BOOL *stop) {
        [tempArrayM removeObject:deleteUserAgent];
    }];

    NSString *newUserAgent = [tempArrayM componentsJoinedByString:@" "];
    NSDictionary *dictionary = @{@"UserAgent": newUserAgent};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [WDWebViewConfig sharedInstance].currentUserAgent = newUserAgent;
}

+ (NSArray<NSString *> *)splitUserAgent:(NSString *)currentUserAgent {
    NSString *currentUserAgentCopy = [currentUserAgent copy];
    NSError *error;
    NSString *regularExpressionString = @"(\\([^\\)]+\\))";//匹配 (*)
    NSString *tempString = [NSString stringWithFormat:@"%c", 22];//不可见字符
    NSString *splitString = @" ";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpressionString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:currentUserAgentCopy
                                                options:0
                                                  range:NSMakeRange(0, [currentUserAgentCopy length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        currentUserAgentCopy = [currentUserAgentCopy stringByReplacingOccurrencesOfString:splitString
                                                                               withString:tempString
                                                                                  options:NSCaseInsensitiveSearch
                                                                                    range:match.range];
    }

    NSArray<NSString *> *subUserAgentArray = [currentUserAgentCopy componentsSeparatedByString:@" "];
    NSMutableArray<NSString *> *resArrayM = @[].mutableCopy;
    for (NSString *string in subUserAgentArray) {
        NSString *res = [string stringByReplacingOccurrencesOfString:tempString
                                                          withString:splitString];
        [resArrayM addObject:res ?: @""];
    }

    return resArrayM.copy;
}

+ (void)saveUserAgent:(NSString *)userAgent {
    if (!userAgent || userAgent.length <= 0) {
        return;
    }

    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [WDWebViewConfig sharedInstance].currentUserAgent = userAgent;
}

//TODO: 超时时间和缓存策略这个也需要确定下使用场景和方案
+ (void)setTimeoutInterval:(NSTimeInterval)interval {
    [WDWebViewConfig sharedInstance].timeoutInterval = interval;
}

+ (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
    [WDWebViewConfig sharedInstance].cachePolicy = cachePolicy;
}

+ (void)setDefaultWebViewType:(WDBWebViewConfigDefaultWebViewType)defaultWebViewType {
    [WDWebViewConfig sharedInstance].defaultWebViewType = (WDWebViewConfigDefaultWebViewType) defaultWebViewType;
}

+ (void)setEnableWKHTTPCookieManage:(BOOL)enable {
    [WDWebViewConfig sharedInstance].enableWKHTTPCookieManage = enable;
}

+ (void)setEnableWKWebViewWhitListControl:(BOOL)enable {
    [WDWebViewConfig sharedInstance].enableWKWebViewWhitListControl = enable;
}

+ (void)setWKWebViewWhiteListPattern:(NSString *)whiteListPattern {
    [WDWebViewConfig sharedInstance].wkwebViewWhiteListPattern = whiteListPattern;
}

@end
