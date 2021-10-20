//
//  VDDirectUploadMission.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/8/29.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDDirectUploadMission.h"
#import "VDFileUploador.h"
#import "VDUploadUT.h"
#import "VDUploadLibsConfig.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNetworkMacro.h>

#import <WDNetwork-Base/NSString+WDNetwork.h>
#import <WDNetwork-Base/NSData+WDNetwork.h>

#import <AFNetworking/AFHTTPSessionManager.h>
#import <YYModel/YYModel.h>


@implementation VDDirectUploadMission

- (NSURLRequest *)requestMayError:(WDNErrorDO *__autoreleasing *)error {
    NSString *scope = self.scope;
    
    NSString *host = [VDFileUploador host];
    NSString *api = API_UPLOAD_DIRECT;
    NSString *query = [NSString stringWithFormat:@"scope=%@&fileType=%@", scope, self.fileType];
    
    NSString *url = [NSString stringWithFormat:@"https://%@/%@?%@", host, api, query];
    
    VDUploadAccountDO *account = [VDUploadLibsConfig sharedInstance].account;
    NSData *fileData = self.fileData ?: [NSData dataWithContentsOfFile:self.filePath];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", scope, self.uploadId];
    NSString *mimeType = self.mimeType;
    NSString *md5 = [fileData wdn_MD5];
    
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
    if (md5.length > 0) {
        parameters[@"md5"] = md5;
    }
    
    if (self.type == VDUpload_IMG || self.type == VDUpload_DOC) {
        parameters[@"prv"] = self.prv ? @"true" : @"false";
    }
    if (self.type == VDUpload_IMG || self.type == VDUpload_AUDIO) {
        parameters[@"unadjust"] = self.unadjust ? @"true" : @"false";
    }
    if (self.type == VDUpload_DOC) {
        NSString *zipSign = [self zipSign:fileData];
        if (zipSign.length > 0) {
            parameters[@"sign"] = zipSign;
        }
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
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileData) {
            [formData appendPartWithFileData:fileData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:mimeType];
        }
    } error:&originError];
    
    if (request) {
        request.HTTPShouldHandleCookies = NO;
        request.timeoutInterval = [self timeout];
        
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"videoSessionId"] = self.sessionId ?: @"";
    param[@"upload_scope"] = self.scope ?: @"";
    param[@"file_path"] = self.filePath ?: @"";
    param[@"file_origin_path"] = self.originPath ?: @"";
    
    param[kVDUHttpResponseSize] = @(self.utResponseSize);
    param[kVDUHttpcode] = @(self.utHttpStatusCode);
    param[kVDUHttpTime] = @(self.utHttpTime * 1000);
    param[kVDUHttpUrl] = API_UPLOAD_DIRECT;
    param[kVDUTraceId] = self.utTraceId ?: @"";
    param[kVDUCanceled] = @(self.isCancel);
    param[kVDUFileSize] = @(self.utUploadFileSize);
    param[kVDUType] = self.fileType ?: @"";
    param[kVDURetry] = @(self.utUploadRetry);
    param[kVDURetryCount] = @(self.utUploadRetryCount);
    
    if (self.utUploadFileSize > 0 && self.utHttpTime > 0 && !error) {
        param[@"file_speed"] = @(self.utUploadFileSize / self.utHttpTime / 1024);
    }
    
    [VDUploadUT VDUTDirect:param result:result error:error];
}

@end
