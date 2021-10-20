//
// Created by yangxin02 on 7/21/16.
// Copyright (c) 2016 WeiDian. All rights reserved.
//


#import <objc/runtime.h>

#import <AFNetworking/AFHTTPSessionManager.h>

#import "WDNetworkDataTask.h"
#import "WDNErrorDO.h"
#import "WDNetworkConstant.h"


@interface WDNetworkDataTask ()

@property (nonatomic, strong) NSURLSessionTask *dataTask;
@property (nonatomic, assign) WDNDataTaskType taskType;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) id responseData;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) WDNErrorDO *wdnError;

@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CFAbsoluteTime responseTime;
@property (nonatomic, assign) CFAbsoluteTime finishTime;

@end

@implementation WDNetworkDataTask

- (instancetype)init {
    return [self initWithRequest:nil taskType:WDNDataTask_DataTask];
}

- (instancetype)initWithTaskType:(WDNDataTaskType)taskType {
    return [self initWithRequest:nil taskType:taskType];
}

- (instancetype)initWithRequest:(NSURLRequest *)request taskType:(WDNDataTaskType)taskType {
    self = [super init];
    if (self) {
        if (taskType == WDNDataTask_DataTask) {
            self.queuePriority = NSOperationQueuePriorityVeryHigh;
        } else if (taskType == WDNDataTask_UploadTask) {
            self.queuePriority = NSOperationQueuePriorityHigh;
        } else {
            self.queuePriority = NSOperationQueuePriorityNormal;
        }
        
        self.request = request;
        self.taskType = taskType;
    }
    return self;
}

- (void)main {
    if (self.isCancelled) {
        [self setWdnError:[WDNErrorDO errorWithCode:WDNetworkCancel msg:@"请求前被取消!"]];
        [self wdn_taskEnd];
        
        return;
    }
    
    if (self.prepareBlock) {
        WDNErrorDO *error = nil;
        NSURLRequest *request = self.prepareBlock(&error);
        
        if (request) {
            self.request = request;
        }
        
        if (error) {
            [self setWdnError:error];
            [self wdn_taskEnd];
            
            return;
        }
    }
    
    if (!self.request) {
        [self setWdnError:[WDNErrorDO errorWithCode:WDNUnKnowError msg:@"Request is nil!"]];
        [self wdn_taskEnd];
        
        return;
    }
    
    // 用信号量控制请求同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    void(^completionHandler)(NSURLResponse *, id, NSError *) = ^(NSURLResponse *response, id responseData, NSError *error){
        self.response = (NSHTTPURLResponse *) response;
        self.responseData = responseData;
        self.error = error;
        
        dispatch_semaphore_signal(semaphore);
    };
    
    NSURLSessionTask *dataTask = nil;
    dispatch_time_t timeOut = DISPATCH_TIME_FOREVER; // 线程等待时间
    switch (self.taskType) {
        case WDNDataTask_DataTask: {
            // 业务数据任务
            NSTimeInterval requestTimeOut = self.request.timeoutInterval;
            if (requestTimeOut > 0) {
                timeOut = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(requestTimeOut * NSEC_PER_SEC));
            }
            dataTask = [wdn_session_manager() dataTaskWithRequest:self.request
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:completionHandler];
        } break;
        case WDNDataTask_UploadTask: {
            NSTimeInterval requestTimeOut = self.request.timeoutInterval;
            if (requestTimeOut > 0) {
                timeOut = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(requestTimeOut * NSEC_PER_SEC));
            }
            // 上传任务, 不设置同步信号量的超时时间.
            
            dataTask = [wdn_session_manager() uploadTaskWithStreamedRequest:self.request
                                                                   progress:self.uploadProgressBlock
                                                          completionHandler:completionHandler];
        } break;
        case WDNDataTask_DownloadTask: {
            
        } break;
    }
    self.dataTask = dataTask;
    
    if (self.isCancelled) {
        [self setWdnError:[WDNErrorDO errorWithCode:WDNetworkCancel msg:@"请求前被取消!"]];
        [self wdn_taskEnd];
        
        return;
    }
    
    if (!dataTask) {
        [self setWdnError:[WDNErrorDO errorWithCode:WDNUnKnowError msg:@"WDNNetworkDataTask is nil!"]];
        [self wdn_taskEnd];
        
        return;
    }
    
    // 发送请求
    [dataTask resume];
    // 记录发送时间
    self.startTime = CFAbsoluteTimeGetCurrent();
    // 等待请求返回
    dispatch_semaphore_wait(semaphore, timeOut);
    
    [self wdn_finish];
}

- (void)cancel {
    if (self.isFinished || self.isCancelled) {
        return;
    }
    
    [super cancel];
    
    if (!self.isExecuting) {
        return;
    }
    
    [self.dataTask cancel];
}

#pragma mark - Private

- (void)wdn_finish {
    if (self.isCancelled) {
        self.wdnError = [WDNErrorDO errorWithCode:WDNetworkCancel msg:@"请求中被取消!"];
    } else {
        if (!self.responseData && !self.error) {
            self.wdnError = [WDNErrorDO errorWithCode:WDNHttpTimeOut msg:@"请求超时!"];
        }
    }
    
    [self wdn_taskEnd];
}

- (void)wdn_taskEnd {
    // 计算相应时间
    NSNumber *responseTime = objc_getAssociatedObject(self.dataTask, &kWDNetworkTaskStartTimeKey);
    if (responseTime) {
        self.responseTime = [responseTime doubleValue];
    } else {
        self.responseTime = 0;
    }
    self.finishTime = CFAbsoluteTimeGetCurrent();
    
    WDNErrorDO *errorDO = self.wdnError;
    if (self.error) {
        errorDO = [WDNErrorDO httpCommonErrorWithError:self.error];
    }
    
    if (self.completeQueue) {
        dispatch_async(self.completeQueue, ^{
            if (self.taskCompletionBlock) {
                self.taskCompletionBlock(self, self.responseData, errorDO);
            }
        });
    } else {
        if (self.taskCompletionBlock) {
            self.taskCompletionBlock(self, self.responseData, errorDO);
        }
    }
}

@end
