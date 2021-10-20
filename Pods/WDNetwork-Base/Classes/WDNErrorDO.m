//
//  WDNErrorDO.m
//  WDNetworkingDemo
//
//  Created by yangxin02 on 1/20/16.
//  Copyright © 2016 yangxin02. All rights reserved.
//

#import "WDNErrorDO.h"

@interface WDNErrorDO ()

@property (nonatomic, strong) NSString      *message;
@property (nonatomic, assign) NSInteger     serverCode;
@property (nonatomic, strong) NSError       *originError;

@end

@implementation WDNErrorDO

+ (instancetype)errorWithCode:(WDNErrorType)code msg:(NSString *)msg {
    WDNErrorDO *error = [[WDNErrorDO alloc] init];
    error.code = code;
    error.message = msg;
    return error;
}

+ (instancetype)serverErrorWithCode:(NSInteger)code msg:(NSString *)msg {
    WDNErrorDO *error = [[WDNErrorDO alloc] init];
    
    error.code = WDNServerReturnCode;
    error.serverCode = code;
    error.message = msg;
    
    return error;
}

+ (instancetype)httpCommonErrorWithError:(NSError *)error {
    WDNErrorDO *wdnErrorDO = [[WDNErrorDO alloc] init];
    [wdnErrorDO setOriginError:error];
    return wdnErrorDO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subCode = -1;
    }
    return self;
}

- (void)setOriginError:(NSError *)error {
    if (!error) {
        return;
    }

    _originError = error;
//    self.desc = error.userInfo[NSLocalizedDescriptionKey];
    switch (error.code) {
        case NSURLErrorCancelled:
            self.message = @"请求被取消啦~";
            self.desc = self.message;
            self.code = WDNetworkCancel;
            break;
        case NSURLErrorBadURL:
            self.message = @"无效协议";
            self.desc = self.message;
            self.code = WDNHttpBadURL;
            break;
        case NSURLErrorUnsupportedURL:
            self.message = @"URL错误";
            self.desc = self.message;
            self.code = WDNHttpBadURL;
            break;
        case NSURLErrorTimedOut:
            self.message = @"请求超时啦~";
            self.desc = self.message;
            self.code = WDNHttpTimeOut;
            break;
        case NSURLErrorCannotFindHost:
            self.message = @"找不到服务器";
            self.desc = self.message;
            self.code = WDNHttpCannotFindHost;
            break;
        case NSURLErrorDNSLookupFailed:
            self.message = @"DNS查询失败";
            self.desc = self.message;
            self.code = WDNHttpCannotFindHost;
            break;
        case NSURLErrorCannotConnectToHost:
            self.message = @"服务器关闭或者端口不对";
            self.desc = self.message;
            self.code = WDNHttpErrorCannotConnectToHost;
            break;
        case NSURLErrorNotConnectedToInternet:
            self.message = @"无法创建网络";
            self.desc = self.message;
            self.code = WDNHttpNoNetwork;
            break;
        case NSURLErrorCallIsActive:
            self.code = WDNHttpCallIsActive;
            self.message = @"正在通话中";
            self.desc = self.message;
            break;
        case NSURLErrorNetworkConnectionLost:
            self.code = WDNHttpNetworkConnectionLost;
            self.message = @"网络被中断";
            self.desc = self.message;
            break;
        case NSURLErrorBadServerResponse:
            self.code = WDNHttpBadServerResponse;
            self.message = @"服务器错误";
            self.desc = self.message;
            break;
        default:
            self.code = WDNHttpCommonError;
            self.message = [NSString stringWithFormat:@"NSError.code:%ld, NSError.domain:%@", (long)error.code, error.domain];
            self.desc = @"手机开小差";
            break;
    }
}

/**
 *  NSURLErrorUnknown, 可能是底层框架错误;
 *  NSURLErrorCancelled,
 *  NSURLErrorUserCancelledAuthentication, 用户认证点击了“cancel”按钮;
 *  NSURLErrorUserAuthenticationRequired, 需要用户名和密码;
 *
 *  NSURLErrorNotConnectedToInternet, 无法创建网络;
 *  NSURLErrorCallIsActive, 正在通话;
 *
 *  NSURLErrorBadURL, url错误;
 *  NSURLErrorUnsupportedURL, 无效协议;
 *
 *  NSURLErrorCannotFindHost, NSURLErrorDNSLookupFailed, 主机找不到, 可能是DNS问题;
 *  NSURLErrorCannotConnectToHost, 主机关闭或者端口不对;
 *
 *  NSURLErrorNetworkConnectionLost, 链接被中断;
 *  NSURLErrorHTTPTooManyRedirects, 太多的重定向;
 *  NSURLErrorRedirectToNonExistentLocation, 重定向错误;
 *
 *  NSURLErrorBadServerResponse, 类似“500 Server Error”的错误;
 *
 *  NSURLErrorDataLengthExceedsMaximum, 资源超过固定大小;
 *  NSURLErrorResourceUnavailable, 数据没找到或者编码失败等等;
 *  NSURLErrorZeroByteResource, 请求without sending any data;
 *  NSURLErrorCannotDecodeRawData, ;
 *  NSURLErrorCannotDecodeContentData, ;
 *  NSURLErrorCannotParseResponse, ;
 *  NSURLErrorInternationalRoamingOff, 好像是漫游断开;
 *  NSURLErrorDataNotAllowed, ;
 *  NSURLErrorRequestBodyStreamExhausted, 客户端数据处理的协议没有实现;
 *
 *
 *  NSURLErrorTimedOut, 请求超时;
 */

+ (BOOL)needReSend4HttpsWithError:(NSError *)error {
    if (!error) {
        return NO;
    }

    NSInteger code = error.code;
    if (code == NSURLErrorCancelled) {
        return NO;
    }
    
    return YES;
//    || code == NSURLErrorSecureConnectionFailed
//    || code == NSURLErrorServerCertificateHasBadDate
//    || code == NSURLErrorServerCertificateUntrusted
//    || code == NSURLErrorServerCertificateHasUnknownRoot
//    || code == NSURLErrorServerCertificateNotYetValid
//    || code == NSURLErrorClientCertificateRejected
//    || code == NSURLErrorClientCertificateRequired;
}

@end
