//
//  VDPartUploadFinishMission.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDPartUploadFinishMission.h"
#import "VDFileUploador.h"
#import "VDUploadUT.h"
#import "VDUploadLibsConfig.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNetworkMacro.h>

#import <YYModel/YYModel.h>
#import <AFNetworking/AFNetworking.h>


@implementation VDPartUploadFinishMission

- (NSURLRequest *)requestMayError:(WDNErrorDO *__autoreleasing *)error {
    NSString *scope = self.scope;
    
    NSString *host = [VDFileUploador host];
    NSString *api = API_PART_UPLOAD_OVER;
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
    if (self.uploadInitId.length > 0) {
        parameters[@"uploadId"] = self.uploadInitId;
    }
    if (self.key.length > 0) {
        parameters[@"key"] = self.key;
    }
    if (self.partList.length > 0) {
        parameters[@"partList"] = self.partList;
    }
    
    if (self.type == VDUpload_IMG || self.type == VDUpload_DOC) {
        parameters[@"prv"] = self.prv ? @"true" : @"false";
    }
    if (self.type == VDUpload_IMG || self.type == VDUpload_AUDIO) {
        parameters[@"unadjust"] = self.unadjust ? @"true" : @"false";
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
    CFAbsoluteTime finishTime = (CFAbsoluteTimeGetCurrent() - self.partStartTime);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"videoSessionId"] = self.sessionId ?: @"";
    param[@"upload_scope"] = self.scope ?: @"";
    
    param[kVDUHttpResponseSize] = @(self.utResponseSize);
    param[kVDUHttpcode] = @(self.utHttpStatusCode);
    param[kVDUHttpTime] = @(self.utHttpTime * 1000);
    param[kVDUHttpUrl] = API_PART_UPLOAD_OVER;
    param[kVDUTraceId] = self.utTraceId ?: @"";
    param[kVDUCanceled] = @(self.isCancel);
    param[kVDUType] = self.fileType ?: @"";
    param[kVDURetryCount] = @(self.utUploadRetryCount);
    param[kVDUFileSize] = @(self.utUploadFileSize);
    
    param[kVDUChunkInit] = self.uploadInitId ?: @"";
    param[kVDUChunkCount] = @(self.utChunkCount);
    param[kVDUChunkFinish] = @(finishTime * 1000);
    
    if (self.utUploadFileSize > 0 && finishTime > 0 && !error) {
        param[@"file_speed"] = @(self.utUploadFileSize / finishTime / 1024);
    }
    
    [VDUploadUT VDUTChunk:param result:result error:error];
}

@end
