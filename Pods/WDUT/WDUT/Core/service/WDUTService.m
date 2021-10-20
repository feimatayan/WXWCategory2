//
// Created by shazhou on 2018/7/12.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTService.h"
#import <AFNetworking.h>
#import "WDUTManager.h"
#import "NSData+WDUT.h"
#import "WDUTDef.h"
#import "WDUTMacro.h"
#import "WDUTLogModel.h"
#import "WDUTUtils.h"

#define WDUT_SERVER_URL_DAILY     @"https://logtake.daily.weidian.com/"
#define WDUT_SERVER_URL_PRE     @"https://logtake.pre.weidian.com/"
#define WDUT_SERVER_URL_RELEASE   @"https://logtake.weidian.com/"
#define WDUT_SERVER_URL ([WDUTConfig instance].envType == WDUT_ENV_DAILY ? WDUT_SERVER_URL_DAILY : WDUT_SERVER_URL_RELEASE)
#define WDUT_LOG_UPLOAD_API @"log_wt"
#define WDUT_GET_SUID_API @"getSuid"

@implementation WDUTService

AFHTTPSessionManager * wdut_session_manager() {
    static dispatch_once_t _once;
    static AFHTTPSessionManager *_sessionM;
    dispatch_once(&_once, ^{
        
        _sessionM = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionM.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return _sessionM;
}

+ (NSString *)getRequestURL:(NSString *)api {
    if ([WDUTConfig instance].envType == WDUT_ENV_DAILY) {
        return [WDUT_SERVER_URL_DAILY stringByAppendingString:api];
    } else if ([WDUTConfig instance].envType == WDUT_ENV_PRE) {
        return [WDUT_SERVER_URL_PRE stringByAppendingString:api];
    } else if ([WDUTConfig instance].envType == WDUT_ENV_RELEASE) {
        return [WDUT_SERVER_URL_RELEASE stringByAppendingString:api];
    }
    return [WDUT_SERVER_URL_DAILY stringByAppendingString:api];
}

+ (void)requestSuid:(NSDictionary *)info complete:(void (^)(BOOL isSuccess, NSDictionary *result, NSError *error))completeBlock {
    NSDictionary *bodyDict = @{@"header": info};
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:&error];
    [self request:WDUT_GET_SUID_API body:body complete:completeBlock];
}

+ (void)uploadLogs:(NSArray *)logArray complete:(void (^)(BOOL isSuccess, NSDictionary *result, NSError *error))completeBlock {
    if (logArray.count <= 0) {
        if (completeBlock) {
            completeBlock(NO, nil, [NSError errorWithDomain:@"" code:WDUT_ERROR_DATA_EMPTY userInfo:nil]);
        }
        return;
    }

    if (![NSJSONSerialization isValidJSONObject:logArray]) {
        if (completeBlock) {
            completeBlock(NO, nil, [NSError errorWithDomain:@"" code:WDUT_ERROR_SERIALIZE_FAILED userInfo:nil]);
        }
        return;
    }
    
    NSError *e = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:logArray options:0 error:&e];
    if (e) {
        if (completeBlock) {
            completeBlock(NO, nil, [NSError errorWithDomain:@"" code:WDUT_ERROR_SERIALIZE_FAILED userInfo:nil]);
        }
        return;
    }

//    if (![WDUTConfig instance].debugMode) {
        data = [data wdutGzipDeflate];
//    }
    if (!data) {
        if (completeBlock) {
            completeBlock(NO, nil, [NSError errorWithDomain:@"" code:WDUT_ERROR_GZIP_FAILED userInfo:nil]);
        }
        return;
    }

    [self request:WDUT_LOG_UPLOAD_API body:data complete:completeBlock];
}

+ (void)request:(NSString *)api body:(NSData *)body complete:(void (^)(BOOL isSuccess, NSDictionary *result, NSError *error))completeBlock {
    NSString *requestURL = [WDUTService getRequestURL:api];
//    if ([WDUTConfig instance].debugMode) {
//        requestURL = [WDUTUtils addQuery:@{@"no_decrypt" : @"true"} withURL:requestURL];
//    }
    
    if ([WDUTConfig instance].envType == WDUT_ENV_DAILY) {
        requestURL = [WDUTUtils addQuery:@{@"lodi_env" : @"daily"} withURL:requestURL];
    } else if ([WDUTConfig instance].envType == WDUT_ENV_PRE) {
        requestURL = [WDUTUtils addQuery:@{@"lodi_env" : @"pre"} withURL:requestURL];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    request.HTTPMethod = @"POST";
//    request.HTTPBody = [WDUTConfig instance].debugMode ? body : [body wdutAes256EncryptWithKey:[WDUTService getAesKey]];
    request.HTTPBody = [body wdutAes256EncryptWithKey:[WDUTService getAesKey]];
    request.HTTPShouldHandleCookies = NO;

    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSURLSessionTask *dataTask = [wdut_session_manager() dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSData *responseObject, NSError *error) {
        CFAbsoluteTime finishTime = CFAbsoluteTimeGetCurrent();
        [self record:(finishTime - startTime) response:response result:responseObject error:error];
        if (completeBlock) {
            if (error) {
                completeBlock(NO, nil, error);
            } else {
                NSDictionary *responseJSON = nil;
                if (responseObject != nil) {
                    responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                }
                if (responseObject && [responseJSON[@"status"] integerValue] == 0) {
                    completeBlock(YES, responseJSON, nil);
                } else {
                    completeBlock(NO, nil, error);
                }
            }
        }
    }];

    [dataTask resume];
}

//埋点
+ (void)record:(CFAbsoluteTime)rt response:(NSURLResponse *)response result:(NSData *)result error:(NSError *)error {
    NSString *rtString = [NSString stringWithFormat:@"%.0f", rt * 1000];
    NSUInteger dataSize = result.length;
    NSString *responseSize = [NSString stringWithFormat:@"%lu", (unsigned long) dataSize];

    NSDictionary *responseJSON = nil;
    if (result != nil) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    }
    BOOL isSuccess = (error == nil && responseJSON != nil && [responseJSON[@"status"] integerValue] == 0);
    NSString *statusCode = isSuccess ? @"1" : @"0";

    NSMutableDictionary *args = [@{} mutableCopy];
    if (isSuccess) {
        args[@"error_desc"] = @"OK";
    } else {
        if (responseJSON[@"message"]) {
            args[@"error_desc"] = responseJSON[@"message"];
        } else if (error) {
            args[@"error_desc"] = error.localizedDescription ? :@"";
        }
    }
    
    if (error) {
        args[@"error_code"] = [@(error.code) stringValue];
    }

    NSString *api = response.URL.absoluteString;
    NSRange range = [api rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        api = [api substringToIndex:range.location];
    }
    args[@"api"] = api ? : @"";

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSDictionary *header = [(NSHTTPURLResponse *)response allHeaderFields];
        if (header[@"x-trace-id"]) {
            args[@"trace_id"] = header[@"x-trace-id"];
        } else if (header[@"x-vtrace-id"]) {
            args[@"trace_id"] = header[@"x-vtrace-id"];
        }
    }

    WT.eventId(@"3103").page(WDUT_PAGE_FIELD_UT).arg1(rtString).arg2(responseSize).arg3(statusCode).args(args).isSuccess(isSuccess).commit();
}

+ (NSString *)getAesKey {
    NSArray *keys = @[@"TmdMY",@"jLfMb",@"W3O5o",@"hgLny",@"oA=="];
    return [keys componentsJoinedByString:@""];
}

@end
