//
//  VDPartUploadMission.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDPartUploadMission.h"
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


@implementation VDPartUploadMission

- (NSURLRequest *)requestMayError:(WDNErrorDO *__autoreleasing *)error {
    NSString *scope = self.scope;
    
    NSString *host = [VDFileUploador host];
    NSString *api = API_PART_UPLOAD;
    NSString *query = [NSString stringWithFormat:@"scope=%@&fileType=%@", scope, self.fileType];
    
    NSString *url = [NSString stringWithFormat:@"https://%@/%@?%@", host, api, query];
    
    VDUploadAccountDO *account = [VDUploadLibsConfig sharedInstance].account;
    NSData *fileData = self.fileData ?: [NSData dataWithContentsOfFile:self.filePath];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%lu", scope, self.uploadId, (unsigned long)self.partId];
    NSString *mimeType = self.mimeType;
    NSString *md5 = [fileData wdn_MD5];
    
    NSDictionary *parameters = @{
        @"duid": account.duid ?: @"",
        @"userId": account.userId ?: @"",
        @"token": account.token ?: @"",
        @"uploadId": self.uploadInitId ?: @"",
        @"key": self.key ?: @"",
        @"md5": md5 ?: @"",
        @"partId": @(self.partId),
    };
    
    AFHTTPRequestSerializer *requestSerializer = wdn_session_manager().requestSerializer;
    NSError *originError = nil;
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:url
                                                                          parameters:parameters
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileData) {
            [formData appendPartWithFileData:fileData
                                        name:@"part"
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
    
    param[kVDUHttpcode] = @(self.utHttpStatusCode);
    param[kVDUHttpTime] = @(self.utHttpTime * 1000);
    param[kVDUHttpUrl] = API_PART_UPLOAD;
    param[kVDUTraceId] = self.utTraceId ?: @"";
    param[kVDUCanceled] = @(self.isCancel);
    param[kVDUType] = self.fileType ?: @"";
    
    param[kVDUChunkIndex] = @(self.partId);
    param[kVDUChunkCount] = @(self.utChunkCount);
    param[kVDUChunkInit] = self.uploadInitId ?: @"";
    param[kVDUChunkSize] = @(self.utChunkFileSize);
    param[kVDUChunkRetry] = @(self.utUploadRetryCount);
    param[kVDUChunkOffsetFrom] = @((self.partId - 1) * self.partSize);
    param[kVDUChunkOffsetTo] = @((self.partId - 1) * self.partSize + self.utChunkFileSize);
    param[kVDUChunkLast] = @(self.partId == self.utChunkCount);
    
    if (self.utChunkFileSize > 0 && self.utHttpTime > 0 && !error) {
        param[@"chunk_speed"] = @(self.utChunkFileSize / self.utHttpTime / 1024);
    }
    
    [VDUploadUT VDUTChunk:param result:result error:error];
}

@end
