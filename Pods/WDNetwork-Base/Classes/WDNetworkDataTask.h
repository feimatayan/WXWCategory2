//
// Created by yangxin02 on 7/21/16.
// Copyright (c) 2016 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDNetworkDataTask, WDNErrorDO;

typedef void (^WDNetworkDataTaskCompletionBlock)(WDNetworkDataTask *dataTask, id responseData, WDNErrorDO *error);

typedef NS_ENUM(NSInteger, WDNDataTaskType) {
    WDNDataTask_DataTask        = 0,
    WDNDataTask_UploadTask,
    WDNDataTask_DownloadTask,
};


@interface WDNetworkDataTask : NSOperation

@property (nonatomic, copy) NSURLRequest *(^prepareBlock)(WDNErrorDO **);

@property (nonatomic, copy) void(^uploadProgressBlock)(NSProgress *);

@property (nonatomic, copy) WDNetworkDataTaskCompletionBlock taskCompletionBlock;

@property (nonatomic) dispatch_queue_t completeQueue;

@property (nonatomic, strong, readonly) NSURLSessionTask *dataTask;
@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) id responseData;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, assign, readonly) CFAbsoluteTime startTime;
@property (nonatomic, assign, readonly) CFAbsoluteTime responseTime;
@property (nonatomic, assign, readonly) CFAbsoluteTime finishTime;

@property (nonatomic, assign) NSUInteger taskId;

- (instancetype)initWithTaskType:(WDNDataTaskType)taskType;
- (instancetype)initWithRequest:(NSURLRequest *)request taskType:(WDNDataTaskType)taskType;

@end
