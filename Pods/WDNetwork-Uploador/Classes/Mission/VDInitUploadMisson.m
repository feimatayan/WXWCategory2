//
//  VDInitUploadMisson.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDInitUploadMisson.h"
#import "VDFileUploador.h"
#import "VDUploadUT.h"
#import "VDUploadResultDO.h"
#import "VDUploadLibsConfig.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNetworkMacro.h>

#import <YYModel/YYModel.h>
#import <AFNetworking/AFNetworking.h>


@interface VDInitUploadMisson ()

@end

@implementation VDInitUploadMisson

- (NSURLRequest *)requestMayError:(WDNErrorDO *__autoreleasing *)error {
    NSString *scope = self.scope;
    
    NSString *host = [VDFileUploador host];
    NSString *api = API_PART_UPLOAD_INIT;
    NSString *query = [NSString stringWithFormat:@"scope=%@&fileType=%@", scope, self.fileType];
    
    NSString *url = [NSString stringWithFormat:@"https://%@/%@?%@", host, api, query];
    
    VDUploadAccountDO *account = [VDUploadLibsConfig sharedInstance].account;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (account.duid.length > 0) {
        parameters[@"duid"] = account.duid;
    }
    if (account.userId.length > 0) {
        parameters[@"userId"] = account.userId;
    }
    if (account.token.length > 0) {
        parameters[@"token"] = account.token;
    }
    
    for (id key in self.postParam) {
        if (![key isKindOfClass:NSString.class] || parameters[key]) {
            continue;
        }
        
        id value = self.postParam[key];
        if (!value || (![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class])) {
            continue;
        }
        
        if ([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class]) {
            parameters[key] = value;
        }
    }
    
    AFHTTPRequestSerializer *requestSerializer = wdn_session_manager().requestSerializer;
    NSError *originError = nil;
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:url
                                                                          parameters:parameters
                                                           constructingBodyWithBlock:nil
                                                                               error:&originError];
    
    if (request) {
        request.HTTPShouldHandleCookies = NO;
        request.timeoutInterval = 30;
        
        [request setValue:@"ios.weidian.com" forHTTPHeaderField:@"Origin"];
        [request setValue:@"https://ios.weidian.com" forHTTPHeaderField:@"referer"];
        [request setValue:[VDFileUploador UA] forHTTPHeaderField:@"User-Agent"];
        [request setValue:host forHTTPHeaderField:@"Host"];
    } else {
        *error = [WDNErrorDO httpCommonErrorWithError:originError];
    }
    
    WDNLog(@"\nVDUPLOADER URL: %@ \nparam: %@", url, [parameters yy_modelToJSONObject]);
    
    return request;
}

- (void)sendUT:(VDUploadResultDO *)result error:(WDNErrorDO *)error {
    if (self.errorDO) {
        error = self.errorDO;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"videoSessionId"] = self.sessionId ?: @"";
    param[@"upload_scope"] = self.scope ?: @"";
    param[@"file_path"] = self.filePath ?: @"";
    param[@"file_origin_path"] = self.originPath ?: @"";
    
    param[kVDUFileSize] = @(self.utUploadFileSize);
    param[kVDUHttpResponseSize] = @(self.utResponseSize);
    param[kVDUHttpcode] = @(self.utHttpStatusCode);
    param[kVDUHttpTime] = @(self.utHttpTime * 1000);
    param[kVDUHttpUrl] = API_PART_UPLOAD_INIT;
    param[kVDUTraceId] = self.utTraceId ?: @"";
    param[kVDUCanceled] = @(self.isCancel);
    param[kVDUType] = self.fileType ?: @"";
    
    param[kVDUChunkInit] = result.uploadId ?: @"";
    
    [VDUploadUT VDUTChunk:param result:result error:error];
}

@end
