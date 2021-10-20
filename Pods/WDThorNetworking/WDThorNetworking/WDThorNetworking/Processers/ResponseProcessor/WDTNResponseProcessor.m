//
//  WDTNResponseProcessor.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNResponseProcessor.h"
#import "WDTNRequestConfig.h"
#import "WDTNNetwrokErrorDefine.h"


#pragma mark - NSDictionary + wdbjneResponse

@implementation NSDictionary (wdbjneResponse)

- (id)objectForInsensitiveKey:(id)akey {
    
    if ( [akey isKindOfClass:[NSString class]] ) {
        //字符串key值，不区分大小写读取value
        NSArray*keys = [self allKeys];
        for (NSString* tmpkey in keys) {
            if( NSOrderedSame == [tmpkey caseInsensitiveCompare:akey] ) {
                return [self objectForKey:tmpkey];
            }
        }
        return nil;
    } else {
        //非字符串类型，调用标准objectForKey
        return [self objectForKey:akey];
    }
}

@end


@implementation WDTNResponseProcessor

+ (NSDictionary *)parseForResponse:(NSHTTPURLResponse *)httpResponse data:(NSData *)data config:(WDTNRequestConfig *)config error:(NSError **)error {
    
    NSInteger httpStatusCode = [httpResponse statusCode];
    
    if (200 == httpStatusCode) {
        NSDictionary *headerFields = [httpResponse allHeaderFields];
        NSInteger decryptStatus = [[headerFields objectForInsensitiveKey:@"encryStatus"] integerValue];
        NSInteger gzipType = [[headerFields objectForInsensitiveKey:@"gzipType"] integerValue];

        // 获取管道，处理 data.
        WDTNDataPipeline *responsePipeline = [config.responseDelegate responsePipelineForConfig:config resEncryStatus:decryptStatus resGzipType:gzipType];
        NSDictionary *json = [responsePipeline processData:data error:error];
        return json;
    } else {
        NSString* domainName = [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
        domainName = [NSString stringWithFormat:@"httpResponse statusCode failed,%ld-%@-%@", (long)[httpResponse statusCode], domainName, [httpResponse allHeaderFields]];
        if (error != NULL) {
            *error = [NSError errorWithDomain:domainName code:WDTNError_HttpStatusCode_illegal userInfo:nil];
        }
        return nil;
    }
}

@end

