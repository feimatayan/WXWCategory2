//
//  WDTNNetworkManager+Thor.m
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/11/7.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import "WDTNNetworkManager+Thor.h"
#import "WDTNPerformTask.h"
#import "WDTNThorResponseProcessor.h"
#import "WDTNServerClockProofreader.h"
#import "WDTNNetwrokConfig.h"
#import "WDTNUT.h"

#import "NSError+WDTNUT.h"


@implementation WDTNNetworkManager (Thor)

- (void)thor_processData:(NSData *)data
                    task:(WDTNPerformTask *)performTask
                response:(NSHTTPURLResponse *)response
                 cfError:(NSError *)cfError
             reSendBlock:(void(^)(WDTNPerformTask *, double))reSendBlock
                callback:(void(^)(NSDictionary *, NSError *))callback
{
    BOOL success = NO;
    NSDictionary *status = nil;
    NSError *error = cfError;
    
    if (!error) {
        NSDictionary *dict = [WDTNThorResponseProcessor parseForResponse:response
                                                                    data:data
                                                                  config:performTask.config
                                                                   error:&error];
        if (!error) {
            NSDictionary *result = nil;
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                status = dict[@"status"];
                result = dict[@"result"];
                if (![status isKindOfClass:[NSDictionary class]]) {
                    status = nil;
                }
                if ([result isKindOfClass:[NSNull class]]) {
                    result = nil;
                }
                
                NSInteger code = -1;
                NSInteger subCode = -1;
                if (status[@"code"] && [status[@"code"] respondsToSelector:@selector(integerValue)]) {
                    code = [status[@"code"] integerValue];
                }
                if (status[@"subCode"] && [status[@"subCode"] respondsToSelector:@selector(integerValue)]) {
                    subCode = [status[@"subCode"] integerValue];
                }
                
                long long serverTime = 0;
                if ([result isKindOfClass:[NSDictionary class]]) {
                    if (result[@"serverTime"] && [result[@"serverTime"] respondsToSelector:@selector(longLongValue)]) {
                        serverTime = [result[@"serverTime"] longLongValue];
                    }
                }
                
                if (code == 0) {
                    success = YES;
                    
                    callback(dict, nil);
                } else if (code == 2) {
                    if (subCode == 31) {
                        [self thor_completeWithCode2SubCode31:performTask
                                                       result:dict
                                                  reSendBlock:reSendBlock
                                                     callback:callback];
                    } else {
                        [self thor_completeWithCode2:performTask
                                              result:dict
                                         reSendBlock:reSendBlock
                                            callback:callback];
                    }
                } else if (code == 20) {
                    // 实名认证
                    [self thor_completeWithCode20:performTask data:dict callback:callback];
                } else if (code == 40) {
                    [[WDTNServerClockProofreader sharedInstance] updateServerTime:serverTime];
                    
                    [self thor_completeWithCode40:performTask
                                           result:dict
                                      reSendBlock:reSendBlock
                                         callback:callback];
                } else {
                    // 服务器端错误
                    callback(dict, nil);
                }
            } else {
                // result解析失败
                callback(nil, [NSError errorWithDomain:@"com.weidian.thor"
                                                  code:-1
                                              userInfo:@{@"status": @{@"description": @"result解析失败"},}]);
            }
        } else {
            // result序列化失败
            callback(nil, error);
        }
    } else {
        // 网络错误
        if (error.wdn_code == 53 && !performTask.reStart) {
            performTask.reStart = YES;
            
            reSendBlock(performTask, 0);
        } else {
            callback(nil, error);
        }
    }
    
    // Thor UT
    [WDTNUT commitThor:success task:performTask dataSize:data.length status:status error:error];
}

- (void)thor_completeWithCode2SubCode31:(WDTNPerformTask *)performTask
                                 result:(NSDictionary *)result
                            reSendBlock:(void(^)(WDTNPerformTask *, double))reSendBlock
                               callback:(void(^)(NSDictionary *, NSError *))callback
{
    id<WDTNAccountDelegate> delegate = [WDTNNetwrokConfig sharedInstance].accountDelegate;
    if (delegate && [delegate respondsToSelector:@selector(thorRefreshToken:callback:)]) {
        __weak typeof(self) weakself = self;
        [delegate thorRefreshToken:performTask callback:^(WDTNPerformTask *task, BOOL refreshSuccess, BOOL needRelogin) {
            if (refreshSuccess) {
                // 重试
                reSendBlock(task, 0);
            } else {
                if (needRelogin) {
                    [weakself thor_completeWithCode2:performTask
                                              result:result
                                         reSendBlock:reSendBlock
                                            callback:callback];
                } else {
                    // 刷新token失败
                    callback(result, nil);
                }
            }
        }];
    } else {
        // 刷新token失败
        callback(result, nil);
    }
}

- (void)thor_completeWithCode2:(WDTNPerformTask *)performTask
                        result:(NSDictionary *)result
                   reSendBlock:(void(^)(WDTNPerformTask *, double))reSendBlock
                      callback:(void(^)(NSDictionary *, NSError *))callback
{
    id<WDTNAccountDelegate> delegate = [WDTNNetwrokConfig sharedInstance].accountDelegate;
    if (delegate && [delegate respondsToSelector:@selector(thorReLogin:callback:)]) {
        [delegate thorReLogin:performTask callback:^(WDTNPerformTask *task, BOOL loginSuccess) {
            if (loginSuccess) {
                // 重试
                reSendBlock(task, 0);
            }
        }];
    }
    
    // UDC登出
    callback(result, nil);
}

- (void)thor_completeWithCode20:(WDTNPerformTask *)performTask
                           data:(NSDictionary *)data
                       callback:(void(^)(NSDictionary *, NSError *))callback
{
    NSDictionary *result = data[@"result"];
    if (!result || ![result isKindOfClass:[NSDictionary class]]) {
        callback(data, nil);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *authPageUrl = result[@"authPageUrl"];
        if (!authPageUrl || ![authPageUrl isKindOfClass:[NSString class]] || authPageUrl.length == 0) {
            return ;
        }
        
        id<WDTNThorResponseDelegate> delegate = [WDTNNetwrokConfig sharedInstance].thorResponseDelegate;
        if (delegate) {
            BOOL appInAuther = NO;
            if ([delegate respondsToSelector:@selector(thorAppInAuthentication)]) {
                appInAuther = [delegate thorAppInAuthentication];
            }
            
            if (!appInAuther && [delegate respondsToSelector:@selector(thorAuthenticationWithURL:result:)]) {
                [delegate thorAuthenticationWithURL:authPageUrl result:result];
            }
        }
    });
    
    NSString *message = result[@"message"];
    if (message && [message isKindOfClass:[NSString class]] && message.length > 0) {
        NSDictionary *status = data[@"status"];
        if (status && [status isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mutStatus = [status mutableCopy];
            mutStatus[@"message"] = message;
            mutStatus[@"description"] = message;
            
            NSMutableDictionary *mutData = [data mutableCopy];
            mutData[@"status"] = [mutStatus copy];
            
            callback([mutData copy], nil);
        } else {
            callback(data, nil);
        }
    } else {
        callback(data, nil);
    }

}

- (void)thor_completeWithCode40:(WDTNPerformTask *)performTask
                         result:(NSDictionary *)result
                    reSendBlock:(void(^)(WDTNPerformTask *, double))reSendBlock
                       callback:(void(^)(NSDictionary *, NSError *))callback
{
    if (performTask.verifyTimes < 3) {
        performTask.verifyTimes += 1;
        
        // 重试
        reSendBlock(performTask, 0);
    } else {
        callback(result, nil);
    }
}

@end
