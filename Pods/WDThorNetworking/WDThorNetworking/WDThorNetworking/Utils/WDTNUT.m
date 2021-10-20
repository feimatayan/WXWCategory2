//
//  WDTNUT.m
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/10/26.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import "WDTNUT.h"
#import "WDTNPrivateDefines.h"
#import "WDTNDefines.h"
#import "WDTNPerformTask.h"

#import "NSError+WDTNUT.h"

#import <objc/runtime.h>
#import <objc/message.h>


@implementation WDTNUT

+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args {
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(commitEvent:args:);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        ((void (*)(id, SEL, NSString *, NSDictionary *)) objc_msgSend)(utClass, utSelector, eventId, args);
    }
}

+ (void)commitException:(NSString *)pageName
                   arg1:(NSString *)arg1
                   arg2:(NSString *)arg2
                   arg3:(NSString *)arg3
                   args:(NSDictionary *)args
{
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(commitEvent:pageName:arg1:arg2:arg3:args:);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        ((void (*)(id, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, NSDictionary *)) objc_msgSend)
        (utClass, utSelector, @"3103", @"exception", arg1, arg2, arg3, args);
    }
}

+ (void)commitThor:(BOOL)success
              task:(WDTNPerformTask *)task
          dataSize:(NSInteger)dataSize
            status:(NSDictionary *)status
             error:(NSError *)error
{
    NSString *page = task.pageName;
    NSString *url = task.url;
    NSString *module = task.moduleName;
    NSString *appStatus = task.publicParams[@"context"][@"app_status"];
    NSURLRequest *request = task.sessionTask.originalRequest;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.sessionTask.response;
    
    double rt = fabs(task.utThorResponseTime - task.utThorRequestTime) * 1000;
    BOOL reStart = task.reStart;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (url.length == 0) {
            return ;
        }
        
        NSURL *api = [NSURL URLWithString:url];
        
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        if (request) {
            args[@"request_size"] = @(request.HTTPBody.length);
        }
        
        args[@"sdk_v"] = WDTHOR_SDK_VERSION;
        args[@"thor_v"] = WDTHOR_NETWORKING_VERSION;
        args[@"url"] = api.absoluteString;
        
        if (response) {
            args[@"http_status_code"] = [NSString stringWithFormat:@"%ld", (long)response.statusCode];
            args[@"trace_id"] = response.allHeaderFields[@"X-Trace-Id"] ? : @"";
            
            // httpDNS
            args[@"VD-HttpDNS-Re"] = response.allHeaderFields[@"VD-HttpDNS-Re"] ? : @"";
            args[@"VD-HttpDNS-Host"] = response.allHeaderFields[@"VD-HttpDNS-Host"] ? : @"";
            args[@"isHttpDns"] = response.allHeaderFields[@"VD-HttpDNS-Host"] ? @"true" : @"false";
        }
        
        args[@"status"] = success ? @"1" : @"0";
        
        if (appStatus.length > 0) {
            args[@"app_status"] = appStatus;
        }
        args[@"app_resend"] = reStart ? @"1" : @"0";
        
        // 要不要加上平台信息
        if (module.length > 0) {
            args[@"origin"] = module;
        }
        
        // 加一个错误，标记网络错误，还是接口错误
        args[@"http_status"] = @"1";
        if (success) {
            args[@"error_code"] = @"0";
            args[@"error_message"] = @"OK";
        } else {
            if (error) {
                args[@"http_status"] = @"0";
                
                // 网络错误
                args[@"error_code"] = [NSString stringWithFormat:@"%ld", (long)error.wdn_code];
                args[@"error_desc"] = error.wdn_message;
                args[@"error_message"] = error.debugDescription;
            } else if (status) {
                // 服务器端错误
                id codeNum = status[@"code"];
                if (codeNum && [codeNum respondsToSelector:@selector(longValue)]) {
                    args[@"error_code"] = [NSString stringWithFormat:@"%ld", [codeNum longValue]];
                }
                
                id subCodeNum = status[@"subCode"];
                if (subCodeNum && [subCodeNum respondsToSelector:@selector(longValue)]) {
                    args[@"error_subCode"] = [NSString stringWithFormat:@"%ld", [subCodeNum longValue]];
                }
                
                NSString *description = status[@"description"];
                if (description && [description isKindOfClass:[NSString class]]) {
                    args[@"error_desc"] = description;
                }
                
                NSString *message = status[@"message"];
                if (message && [message isKindOfClass:[NSString class]]) {
                    args[@"error_message"] = message;
                }
            } else {
                args[@"http_status"] = @"0";
            }
        }
        
        [self commitUTWithRT:rt
                    dataSize:dataSize
                        args:args
                   isSuccess:success
                        page:page];
    });
}

+ (NSString *)getCuid {
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(getCuid);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        return ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelector);
    }
    
    return nil;
}

+ (NSString *)getSuid {
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(getSuid);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        return ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelector);
    }
    
    return nil;
}

#pragma mark - Private

+ (void)commitUTWithRT:(double)rt
              dataSize:(NSInteger)dataSize
                  args:(NSDictionary *)args
             isSuccess:(BOOL)isSuccess
                  page:(NSString *)page
{
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(commitEvent:pageName:arg1:arg2:arg3:args:isSuccess:);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        ((void (*)(id, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, NSDictionary *, BOOL)) objc_msgSend)
        (utClass, utSelector, @"3103", page.length > 0 ? page : @"thor", [NSString stringWithFormat:@"%.0f", rt], [NSString stringWithFormat:@"%ld", (long)dataSize], isSuccess ? @"1" : @"0", args, isSuccess);
    }
}

#pragma mark - 占位

- (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args {
    // do nothing
}

- (void)commitEvent:(NSString *)eventID segmentation:(NSDictionary *)segmentation {
    // do nothing
}

- (void)commitEvent:(NSString *)commitEvent
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
{
    // do nothing
}

- (void)commitEvent:(NSString *)commitEvent
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
          isSuccess:(BOOL)isSuccess
{
    // do nothing
}

- (void)getCuid {
    // do nothing
}

- (void)getSuid {
    // do nothing
}

@end
