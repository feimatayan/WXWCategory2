//
// Created by 石恒智 on 2017/12/20.
// Copyright (c) 2017 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#import "WDWebView.h"
#import "WDWebViewPluginProtocol.h"
#import "WDWebViewConfigure.h"

@implementation WDWebView (plugins)

- (BOOL)registerPlugin:(id <WDWebViewPluginProtocol>)plugin {
    if (!plugin) {return NO;}
    if ([self.pluginsArray containsObject:plugin]) {
        return YES;
    }
    NSMutableArray *tempArrayM = self.pluginsArray.mutableCopy;
    [tempArrayM addObject:plugin];
    self.pluginsArray = tempArrayM.copy;

    if ([plugin respondsToSelector:@selector(registerPlugin:toWebView:withConfigure:)]) {
        [plugin registerPlugin:plugin
                     toWebView:self
                 withConfigure:[WDWebViewConfigure new]];
    }
    return YES;
}

- (BOOL)unRegisterPlugin:(id <WDWebViewPluginProtocol>)plugin {
    if (!plugin) {return NO;}
    if (![self.pluginsArray containsObject:plugin]) {
        return YES;
    }
    NSMutableArray *tempArrayM = self.pluginsArray.mutableCopy;
    [tempArrayM removeObject:plugin];
    self.pluginsArray = tempArrayM.copy;
    if ([plugin respondsToSelector:@selector(unregisterPlugin:toWebView:withConfigure:)]) {
        [plugin unregisterPlugin:plugin
                       toWebView:self
                   withConfigure:[WDWebViewConfigure new]];
    }
    return YES;
}

- (void)unRegisterAllPlugins {
    while ([self.pluginsArray count]) {
        id <WDWebViewPluginProtocol> plugin = [self.pluginsArray lastObject];
        [self unRegisterPlugin:plugin];
    }
}

@end