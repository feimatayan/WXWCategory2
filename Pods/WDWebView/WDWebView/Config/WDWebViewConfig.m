//
// Created by 石恒智 on 2017/12/25.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebViewConfig.h"
#import "WDWebViewUtility.h"
#import "WDWebViewConfigure.h"
#import "WDWebViewDef.h"

NSString *const kWDWebViewConfigDefaultUserAgent = @"kWDWebViewConfigDefaultUserAgent";

@interface WDWebViewConfig()
@property (nonatomic, copy) NSString *defaultUserAgentKey;
@end
@implementation WDWebViewConfig


+ (instancetype)sharedInstance {
    static WDWebViewConfig *singletonObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[WDWebViewConfig alloc] init];
    });
    return singletonObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeoutInterval = 60.0;
        _cachePolicy = NSURLRequestReloadIgnoringCacheData;
        _envType = WDWebViewEnvTypeRelease;
        _defaultWebViewType = WDWebViewConfigDefaultWebViewTypeDefault;
        _enableWKHTTPCookieManage = YES;
        _enableWKWebViewWhitListControl = NO;
        _wkwebViewWhiteListPattern = nil;
        [self loadDefaultUserAgent];
    }
    return self;
}


- (void)registerUserAgent {
    if (!_appName) {
        return;
    }
    dispatch_main_sync_safe(^{
        NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSString *newUserAgent = ([NSString stringWithFormat:@"WDAPP(%@/%@) appid/%@", _appName, appVersion, _appId]);
        [WDWebViewConfigure appendUserAgent:newUserAgent];
    });
}

- (void)loadDefaultUserAgent {
    _defaultUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:self.defaultUserAgentKey];
    if(![_defaultUserAgent length]){
        _defaultUserAgent = [WDWebViewUtility defaultUserAgent];
    }
    _currentUserAgent =[_defaultUserAgent copy];
    [[NSUserDefaults standardUserDefaults] setObject:_defaultUserAgent
                                              forKey:self.defaultUserAgentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)unregisterUserAgent {
    if (_defaultUserAgent) {
        NSDictionary *dictionnary = @{@"UserAgent": _defaultUserAgent};
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setDefaultWebViewType:(WDWebViewConfigDefaultWebViewType)defaultWebViewType {
    _defaultWebViewType = defaultWebViewType;
}

- (NSString *)defaultUserAgentKey {
    if (!_defaultUserAgentKey) {
        NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        _defaultUserAgentKey = [NSString stringWithFormat:@"%@_%@_%@", kWDWebViewConfigDefaultUserAgent, osVersion, appVersion];
    }
    return _defaultUserAgentKey;
}

@end
