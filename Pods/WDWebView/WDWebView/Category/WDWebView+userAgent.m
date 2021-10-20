//
// Created by 石恒智 on 2018/4/13.
//

#import "WDWebView.h"
#import "WDWebViewConfigure.h"

@implementation WDWebView (UserAgent)

+ (void)appendUserAgent:(NSString *)userAgent {
    if (![userAgent length]) {
        return;
    }

//    WDWebViewConfigure *configure = [WDWebViewConfigure new];
    [WDWebViewConfigure appendUserAgent:userAgent];
}

+ (void)removeUserAgent:(NSString *)userAgent {
    if (![userAgent length]) {
        return;
    }
//    WDWebViewConfigure *configure = [WDWebViewConfigure new];
    [WDWebViewConfigure removeUserAgent:userAgent];

}

+ (void)saveUserAgent:(NSString *)userAgent {
	[WDWebViewConfigure saveUserAgent:userAgent];
}

+ (NSString *)currentUserAgent {
    return [WDWebViewConfigure currentUserAgent];
}
@end
