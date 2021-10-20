//
//  NSError+WDTNUT.m
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/10/29.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import "NSError+WDTNUT.h"
#import "WDTNNetwrokErrorDefine.h"


@implementation NSError (WDTNUT)

- (NSInteger)wdn_code {
    switch (self.code) {
//        case NSURLErrorCancelled:               return -10101;
//        case NSURLErrorBadURL:                  return -40004;
//        case NSURLErrorUnsupportedURL:          return -40004;
//        case NSURLErrorTimedOut:                return -40002;
//        case NSURLErrorCannotFindHost:          return -40007;
//        case NSURLErrorDNSLookupFailed:         return -40007;
//        case NSURLErrorCannotConnectToHost:     return -40008;
//        case NSURLErrorNotConnectedToInternet:  return -40006;
//        case NSURLErrorCallIsActive:            return -40009;
//        case NSURLErrorNetworkConnectionLost:   return -40010;
//        case NSURLErrorBadServerResponse:       return -40005;
        case WDTNError_URL_illegal:             return WDTNError_URL_illegal;
        case WDTNError_Compression_failed:      return WDTNError_Compression_failed;
        case WDTNError_Encryption_failed:       return WDTNError_Encryption_failed;
        case WDTNError_HttpStatusCode_illegal:  return WDTNError_HttpStatusCode_illegal;
        case WDTNError_Decryption_failed:       return WDTNError_Decryption_failed;
        case WDTNError_Decompression_failed:    return WDTNError_Decompression_failed;
        case WDTNError_JsonParse_failed:        return WDTNError_JsonParse_failed;
            
        default: return self.code;
    }
}

- (NSString *)wdn_message {
    switch (self.code) {
//        case NSURLErrorCancelled:               return @"请求被取消!";
//        case NSURLErrorBadURL:                  return @"无效协议!";
//        case NSURLErrorUnsupportedURL:          return @"URL错误!";
//        case NSURLErrorTimedOut:                return @"请求超时!";
//        case NSURLErrorCannotFindHost:          return @"找不到服务器!";
//        case NSURLErrorDNSLookupFailed:         return @"DNS查询失败!";
//        case NSURLErrorCannotConnectToHost:     return @"服务器关闭或者端口不对!";
//        case NSURLErrorNotConnectedToInternet:  return @"无法创建网络!";
//        case NSURLErrorCallIsActive:            return @"正在通话!";
//        case NSURLErrorNetworkConnectionLost:   return @"网络被中断!";
//        case NSURLErrorBadServerResponse:       return @"服务器错误!";
        case WDTNError_URL_illegal:             return WDTNError_URL_illegal_domain;
        case WDTNError_Compression_failed:      return WDTNError_Compression_failed_domain;
        case WDTNError_Encryption_failed:       return WDTNError_Encryption_failed_domain;
        case WDTNError_HttpStatusCode_illegal:  return @"http非200响应";
        case WDTNError_Decryption_failed:       return WDTNError_Decryption_failed_domain;
        case WDTNError_Decompression_failed:    return WDTNError_Decompression_failed_domain;
        case WDTNError_JsonParse_failed:        return WDTNError_JsonParse_failed_domain;
            
        default: return self.userInfo[NSLocalizedDescriptionKey];
    }
}

@end
