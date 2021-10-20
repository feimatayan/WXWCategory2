//
//  WDTNRequestProcessor.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNRequestProcessor.h"
#import "WDTNParameterProcessor.h"
#import "WDTNThorParameterProcessor.h"
#import "WDTNUtils.h"
#import "WDTNPerformTask.h"
#import "WDTNRequestConfig.h"
#import "WDTNNetwrokErrorDefine.h"
#import "WDTNDefines.h"
#import "WDTNNetwrokConfig.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJEncryptUtil/NSObject+gljson.h>


@implementation WDTNRequestProcessor

+ (NSString *)requestIdForURL:(NSString *)urlStr params:(id)jsonParam {
    NSString *body = [WDTNUtils stringFromJSONObject:jsonParam];
    if (body == nil) {
        body = @"";
    }
    NSString *value = [NSString stringWithFormat:@"%@?%@",urlStr,body];
    NSString *requestId = [GLCharCodecUtil md5:value];
    return requestId;
}

+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      task:(WDTNPerformTask *)task
                                     error:(NSError **)error
{
    NSURL *url = [NSURL URLWithString:task.url];
    
    if ([WDTNNetwrokConfig sharedInstance].isDebugModel) {
        NSString *scheme = url.scheme;
        NSString *host = url.host;
        NSString *path = url.path;
        if (scheme.length > 0 && host.length > 0 && path.length > 0) {
            NSString *query = url.query;
            NSString *baseURLStr = [NSString stringWithFormat:@"%@://%@", scheme, host];
            
            NSString *urlStr = nil;
            if (query && query.length > 0) {
                urlStr = [NSString stringWithFormat:@"%@%@?%@&wdnDebug=iphone", baseURLStr, path, query];
            } else {
                urlStr = [NSString stringWithFormat:@"%@%@?wdnDebug=iphone", baseURLStr, path];
            }
            if (task.strictTarget.length > 0) {
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"strictTarget=%@", task.strictTarget]];
            }
            url = [NSURL URLWithString:urlStr];
        }
    }
    
    // url 创建失败，返回 nil
    if (url == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_URL_illegal_domain code:WDTNError_URL_illegal userInfo:nil];
        }
        return nil;
    }
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPShouldHandleCookies = NO;
    // 普通请求超时时间设置为30秒
    mutableRequest.timeoutInterval = 30;
    
    // http请求,不使用微店定制格式的数据
    NSDictionary *headers = nil;
    NSData *body = nil;
    
    if (task.config.useThorProtocol) { // thor 协议类型的网关
        headers = [WDTNThorParameterProcessor HTTPHeaderFields:task.config];
        body = [WDTNThorParameterProcessor HTTPBody:task.params task:task error:error];
    } else { // old gateway
        if (task.config.configType == WDTNRequestConfigForHTTP) { // 纯http请求，不做任何处理
            // NSDictionary 为空时，httpUrlForGL会抛异常，所以做了判断。
            if ( [task.params isKindOfClass:[NSDictionary class]] ) {
                if (task.params.count > 0) {
                    body = [[task.params httpUrlForGL] dataUsingEncoding:NSUTF8StringEncoding];
                }
            }
        } else { // 走Proxy网关的配置
            headers = [WDTNParameterProcessor HTTPHeaderFields:task.config];
            body = [WDTNParameterProcessor HTTPBody:task.params task:task error:error];
        }
    }
    
    // 参数处理有错误，返回
    if (error != NULL && *error != nil) {
        return nil;
    }
    
    mutableRequest.HTTPMethod = method;
    
    // set http headers
    if (headers != nil) {
        [mutableRequest setAllHTTPHeaderFields:headers];
    }
//    [mutableRequest setValue:url.host ?: @"" forHTTPHeaderField:@"Host"];
    [mutableRequest setValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    if (task.moduleName.length > 0) {
        [mutableRequest setValue:task.moduleName forHTTPHeaderField:@"VD-Module"];
    }
    
    // set http body
    [mutableRequest setHTTPBody:body];
    // 解决HttpDNS下的SNI问题
    [NSURLProtocol setProperty:body
                        forKey:@"vdOriginHTTPBody"
                     inRequest:mutableRequest];
    
    // 添加本地日志打印数据
    task.HTTPHeader = headers;
    
    return mutableRequest;
}

@end
