//
// Created by 石恒智 on 2017/12/20.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebView.h"
#import "WDWebViewConfig.h"

@implementation WDWebView (Setup)
+ (void)setupWithAppName:(NSString *)appName
                   appId:(NSString *)appId
                     env:(WDWebViewEnvType)envType {
    WDWebViewConfig *config = [WDWebViewConfig sharedInstance];
    config.appName = appName;
    config.appId = appId;
    config.envType = envType;

    [config registerUserAgent];
}

@end