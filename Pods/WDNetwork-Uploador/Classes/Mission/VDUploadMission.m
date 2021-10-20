//
// Created by weidian2015090112 on 2018/8/29.
// Copyright (c) 2018 yangxin02. All rights reserved.
//

#import "VDUploadMission.h"
#import "VDFileUploadQueue.h"
#import "VDUploadResultDO.h"
#import "VDFileUploador.h"
#import "VDUploadUT.h"
#import "VDUploadLibsConfig.h"
#import "VDUploadAccountDO.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNetworkMacro.h>
#import <WDNetwork-Base/WDNetworkDataTask.h>
#import <WDNetwork-Base/NSString+WDNetwork.h>
#import <WDNetwork-Base/WDNDeviceInfoUtil.h>

#import <YYModel/YYModel.h>
#import <CommonCrypto/CommonHMAC.h>


@interface VDUploadMission ()

@property (nonatomic, strong) NSURLRequest *sendRequest;

@property (nonatomic, strong) WDNetworkDataTask *dataTask;

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) BOOL isFinish;

@end

@implementation VDUploadMission
{
    __strong NSString *_fileType;
    __strong NSString *_mimeType;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isCancel = NO;
        self.isFinish = NO;
        
        self.isOriginPath = NO;
    }
    return self;
}

- (double)timeout {
    if (self.utUploadFileSize == 0) {
        return 300;
    }
        
    double timeout = self.utUploadFileSize / 1024 / 8;
    if (self.type == VDUpload_VIDEO) {
//        double timeout = imageSize / 1024 / 12;
        return MAX(120, timeout);
    } else {
//        double timeout = imageSize / 1024 / 12;
        return MIN(300, MAX(60, timeout));
    }
}

- (NSString *)fileType {
    if (!_fileType) {
        switch (self.type) {
            case VDUpload_IMG: {
                _fileType = @"image";
            } break;
            case VDUpload_AUDIO: {
                _fileType = @"audio";
            } break;
            case VDUpload_VIDEO: {
                _fileType = @"video";
            } break;
            case VDUpload_DOC: {
                _fileType = @"doc";
            } break;
        }
    }
    
    return _fileType;
}

- (NSString *)mimeType {
    if (!_mimeType) {
        switch (self.type) {
            case VDUpload_IMG: {
                _mimeType = @"image/jpeg";
                _mimeType = @"image/*";
            } break;
            case VDUpload_AUDIO: {
                _mimeType = @"audio/mpeg";
                _mimeType = @"*/*";
            } break;
            case VDUpload_VIDEO: {
                _mimeType = @"video/mp4";
                _mimeType = @"*/*";
            } break;
            case VDUpload_DOC: {
                _mimeType = @"application/msword";
                _mimeType = @"*/*";
            } break;
        }
    }
    
    return _mimeType;
}

- (NSString *)zipSign:(NSData *)fileData {
    const char *value = [fileData bytes];
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)fileData.length, md5);
    
    unsigned char md55[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5, (CC_LONG)CC_MD5_DIGEST_LENGTH, md55);
    
    unsigned char sign[CC_MD5_DIGEST_LENGTH + 1];
    sign[0] = 0x01;
    int index = 1;
    for (int i = 4; i < 12; i++) {
        sign[index++] = md5[i];
    }
    for (int i = 4; i < 12; i++) {
        sign[index++] = md55[i];
    }
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:(CC_MD5_DIGEST_LENGTH + 1) * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH + 1; i++) {
        [outputString appendFormat:@"%02x", sign[i]];
    }
    
    return outputString;
}

- (void)reload {
    self.retryTimes--;
    
    self.utUploadRetry = YES;
    self.utUploadRetryCount += 1;
    
    self.dataTask = nil;
    
    [self upload];
}

/// 上传方法入口，检查网络、必要参数、登录
- (void)upload {
    @synchronized (self) {
        if (self.isCancel) {
            return;
        }
    }
    
    NSString *scope = self.scope;
    if (scope.length == 0) {
        [self failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"please set scope"]];
        return;
    }
    
    WDNStatus wdbWDNStatus = [WDNDeviceInfoUtil shareUtil].currentGeneralNetStatus;
    if (wdbWDNStatus == WDNStatusNo) {
        [self failureWithError:[WDNErrorDO errorWithCode:WDNHttpNoNetwork msg:@"没有网络"]];
        return;
    }
    
    VDUploadAccountDO *account = [VDUploadLibsConfig sharedInstance].account;
    if (account && account.userId.length > 0 && account.token.length > 0) {
        [self innerUpload];
    } else {
        id<VDUploadAccountDelegate> accountDelegate = [VDUploadLibsConfig sharedInstance].accountDelegate;
        if (accountDelegate) {
            if ([accountDelegate respondsToSelector:@selector(uploadLogin:cancel:)]) {
                __weak typeof(self) weakself = self;
                [accountDelegate uploadLogin:^(BOOL success) {
                    if (success) {
                        [weakself innerUpload];
                    } else {
                        [weakself failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
                    }
                } cancel:^{
                    [weakself failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
                }];
            } else {
                [self failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
            }
        } else {
            [self failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
        }
    }
}

- (void)innerUpload {
    @synchronized (self) {
        if (self.isCancel) {
            return;
        }
    }
    
    WDNErrorDO *error;
    self.sendRequest = [self requestMayError:&error];
    if (!self.sendRequest) {
        [self failureWithError:error];
        return;
    }
    
    self.dataTask = [WDNetworkDataTask.alloc initWithRequest:self.sendRequest taskType:WDNDataTask_UploadTask];
    
    __weak typeof(self) weak_self = self;
    [self.dataTask setUploadProgressBlock:^(NSProgress *innerProgress) {
        weak_self.progress = innerProgress;
        
        if (weak_self.progressBlock) {
            weak_self.progressBlock(innerProgress);
        }
    }];
    [self.dataTask setTaskCompletionBlock:^(WDNetworkDataTask *task, id data, WDNErrorDO *error) {
        [weak_self completeWithData:data error:error];
    }];
    
    [wdn_upload_queue() addOperation:self.dataTask];
    
    self.utRequestSize = self.sendRequest.HTTPBody.length;
}

- (void)query {
    @synchronized (self) {
        if (self.isCancel) {
            return;
        }
    }
    
    NSString *scope = self.scope;
    if (scope.length == 0) {
        [self failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"please set scope"]];
        return;
    }
    
    WDNStatus wdbWDNStatus = [WDNDeviceInfoUtil shareUtil].currentGeneralNetStatus;
    if (wdbWDNStatus == WDNStatusNo) {
        [self failureWithError:[WDNErrorDO errorWithCode:WDNHttpNoNetwork msg:@"没有网络"]];
        return;
    }
    
    VDUploadAccountDO *account = [VDUploadLibsConfig sharedInstance].account;
    if (account && account.userId.length > 0 && account.token.length > 0) {
        [self innerQuery];
    } else {
        id<VDUploadAccountDelegate> accountDelegate = [VDUploadLibsConfig sharedInstance].accountDelegate;
        if (accountDelegate) {
            if ([accountDelegate respondsToSelector:@selector(uploadLogin:cancel:)]) {
                __weak typeof(self) weakself = self;
                [accountDelegate uploadLogin:^(BOOL success) {
                    if (success) {
                        [weakself innerQuery];
                    } else {
                        [weakself failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
                    }
                } cancel:^{
                    [weakself failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
                }];
            } else {
                [self failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
            }
        } else {
            [self failureWithError:[WDNErrorDO errorWithCode:VDUploadParamError msg:@"没有登录"]];
        }
    }
}

- (void)innerQuery {
    @synchronized (self) {
        if (self.isCancel) {
            return;
        }
    }
    
    WDNErrorDO *error;
    self.sendRequest = [self requestMayError:&error];
    if (!self.sendRequest) {
        [self failureWithError:error];
        return;
    }
    
    self.dataTask = [WDNetworkDataTask.alloc initWithRequest:self.sendRequest taskType:WDNDataTask_DataTask];
    
    __weak typeof(self) weak_self = self;
    [self.dataTask setTaskCompletionBlock:^(WDNetworkDataTask *task, id data, WDNErrorDO *error) {
        [weak_self completeWithData:data error:error];
    }];
    
    [wdn_upload_queue() addOperation:self.dataTask];
    
    self.utRequestSize = self.sendRequest.HTTPBody.length;
}

#pragma mark - Complete

- (void)completeWithData:(id)data error:(WDNErrorDO *)error {
    @synchronized (self) {
        if (self.isCancel) {
            return;
        }
    }
    
    VDUploadResultDO *result = nil;
    if (data && !error) {
        result = [VDUploadResultDO yy_modelWithJSON:data];
        if (result.code == 100 || result.code == 200) {
            [self successWithResult:result data:data];
            
            return;
        } else {
            error = [WDNErrorDO serverErrorWithCode:result.code msg:result.message];
        }
    }
    
    if (!error) {
        error = [WDNErrorDO errorWithCode:WDNUnKnowError msg:@"系统错误"];
    }
    
    if (self.retryTimes > 0) {
        if (result) {
            if (result.code == 422) {
                [self completeWith422:error data:data];
            } else if (result.code == 421 || result.code == 423) {
                [self completeWith421And423:error data:data];
            } else {
                [self reload];
            }
        } else {
            if (error.code == WDNetworkCancel) {
                [self failureWithError:error data:data];
            } else if (error.code == WDNHttpTimeOut && !error.originError) {
                // 超时的话就不重试了，因为超时的机率还是很大
                [self failureWithError:error data:data];
            } else {
                [self reload];
            }
        }
        
        return;
    }
    
    [self failureWithError:error data:data];
}

#pragma mark - error code

- (void)completeWith421And423:(WDNErrorDO *)error data:(id)data {
    __weak typeof(self) weakself = self;
    
    id<VDUploadAccountDelegate> accountDelegate = [VDUploadLibsConfig sharedInstance].accountDelegate;
    if (accountDelegate && [accountDelegate respondsToSelector:@selector(uploadReLogin:cancel:)]) {
        [accountDelegate uploadReLogin:^(BOOL success) {
            if (success) {
                [weakself reload];
            } else {
                [weakself failureWithError:error data:data];
            }
        } cancel:^{
            [weakself failureWithError:error data:data];
        }];
    } else {
        [self failureWithError:error data:data];
    }
}

- (void)completeWith422:(WDNErrorDO *)error data:(id)data {
    __weak typeof(self) weakself = self;
    
    id<VDUploadAccountDelegate> accountDelegate = [VDUploadLibsConfig sharedInstance].accountDelegate;
    if (accountDelegate && [accountDelegate respondsToSelector:@selector(uploadRefreshToken:)]) {
        [accountDelegate uploadRefreshToken:^(BOOL success, BOOL needRelogin) {
            if (success) {
                [weakself reload];
            } else {
                if (needRelogin) {
                    [weakself completeWith421And423:error data:data];
                } else {
                    [weakself failureWithError:error data:data];
                }
            }
        }];
    } else {
        [self failureWithError:error data:data];
    }
}

#pragma mark - Finish

- (void)successWithResult:(VDUploadResultDO *)result data:(id)data {
    @synchronized (self) {
        if (self.isCancel || self.isFinish) {
            return;
        }
        
        self.isFinish = YES;
    }
    
    NSHTTPURLResponse *response = self.dataTask.response;
    
    // log
    WDNLog(@"\nVDUPLOADER URL: %@ \nresult: %@",
           self.dataTask.request.URL,
           [result yy_modelToJSONObject]);
    
    // callback
    if (self.completeBlock) {
        result.traceId = self.utTraceId;
        
        self.completeBlock(result, nil);
        self.completeBlock = nil;
    }
    
    // ut
    if (response) {
        self.utHttpStatusCode = response.statusCode;
        self.utTraceId = response.allHeaderFields[@"x-trace-id"];
    }
    self.utHttpTime = self.dataTask.finishTime - self.dataTask.startTime;
    if ([data isKindOfClass:[NSData class]]) {
        self.utResponseSize = ((NSData *)data).length;
    }
    [self sendUT:result error:nil];
    
    // 下一个任务
    [VDFileUploadQueue removeFileByMission:self];
    [VDFileUploadQueue doNextAfterMission:self];
    
    // clear
    self.dataTask = nil;
}

- (void)cancel {
    @synchronized (self) {
        if (self.isCancel || self.isFinish) {
            return;
        }
        
        [self failureWithError:[WDNErrorDO errorWithCode:WDNetworkCancel msg:@"用户取消请求"] isCancel:YES];
    }
}

- (void)failureWithError:(WDNErrorDO *)error {
    [self failureWithError:error data:nil isCancel:NO];
}

- (void)failureWithError:(WDNErrorDO *)error data:(id)data {
    [self failureWithError:error data:data isCancel:NO];
}

- (void)failureWithError:(WDNErrorDO *)error isCancel:(BOOL)isCancel {
    [self failureWithError:error data:nil isCancel:isCancel];
}

- (void)failureWithError:(WDNErrorDO *)error data:(id)data isCancel:(BOOL)isCancel {
    @synchronized (self) {
        if (self.isCancel || self.isFinish) {
            return;
        }
        
        if (isCancel) {
            self.isCancel = isCancel;
            
            if (self.dataTask) {
                [self.dataTask cancel];
            }
        } else {
            self.isFinish = YES;
        }
    }
    
    NSHTTPURLResponse *response = self.dataTask.response;
    
    // log
    WDNLog(@"\nVDUPLOADER URL: %@ \nheader: %@\nerror: %@",
           self.dataTask.request.URL,
           response.allHeaderFields,
           [error yy_modelToJSONObject]);
    
    if (isCancel) {
        // 用户主动取消，不回调，不上报
    } else {
        // 回调
        if (self.completeBlock) {
            self.completeBlock(nil, error);
            self.completeBlock = nil;
        }
        
        // ut
        if (response) {
            self.utHttpStatusCode = response.statusCode;
            self.utTraceId = response.allHeaderFields[@"x-trace-id"];
        }
        self.utHttpTime = self.dataTask.finishTime - self.dataTask.startTime;
        if ([data isKindOfClass:[NSData class]]) {
            self.utResponseSize = ((NSData *)data).length;
        }
        [self sendUT:nil error:error];
    }
    
    
    // 开始下一个任务
    [VDFileUploadQueue removeFileByMission:self];
    [VDFileUploadQueue doNextAfterMission:self];
    
    // clear
    self.dataTask = nil;
}

- (void)sendUT:(VDUploadResultDO *)result error:(WDNErrorDO *)error {
    
}

@end
