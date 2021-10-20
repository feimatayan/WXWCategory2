//
//  WDTNThorResponseProcessor.m
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/28.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import "WDTNThorResponseProcessor.h"
#import "WDTNNetwrokErrorDefine.h"
#import "WDTNThorProtocolImp.h"
#import "WDTNNetwrokConfig.h"
#import "WDTNLog.h"
#import "WDTNUtils.h"
#import "WDTNRequestConfig.h"
#import "WDTNThorSecurityItem.h"


@implementation WDTNThorResponseProcessor

// response payload:
//
// result = {};
// status =     {
//     code = 7;
//     description = "";
//     message = "Remote Invoke Error";
// };
+ (NSDictionary *)parseForResponse:(NSHTTPURLResponse *)httpResponse data:(NSData *)data config:(WDTNRequestConfig *)config error:(NSError **)error {
    NSInteger httpStatusCode = [httpResponse statusCode];
    
    if (200 == httpStatusCode) {
        NSDictionary* headerFields = [httpResponse allHeaderFields];
        
        // appConfig需要header
        id <WDTNAppConfigDelegate> aDelegate = config.appConfigDelegate;
        if (aDelegate && [aDelegate respondsToSelector:@selector(thorResponse:)]) {
            [aDelegate thorResponse:headerFields];
        }

        WDTNThorSecurityItem* item = [WDTNNetwrokConfig sharedInstance].thorSecurityItems[config.configType];
        if (item) {
            return [WDTNUtils jsonParse:[WDTNThorProtocolImp thorDecrypt:data
                                                              withAESKey:item.thorAesKey
                                                              andOptions:headerFields]];
        } else {
//            NSAssert(item != nil, @"Can not find Thor security config item for config type %@", config.configType);
            
            *error = [NSError errorWithDomain:WDTNError_Decryption_failed_domain code:WDTNError_Decryption_failed userInfo:nil];
            
            return nil;
        }

    } else {
        // http error
        NSString* domainName = [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
        domainName = [NSString stringWithFormat:@"httpResponse statusCode failed, %ld-%@-%@", (long)[httpResponse statusCode], domainName, [httpResponse allHeaderFields]];
        if (error != NULL) {
            *error = [NSError errorWithDomain:domainName code:WDTNError_HttpStatusCode_illegal userInfo:nil];
        }

        return nil;
    }
}

@end
