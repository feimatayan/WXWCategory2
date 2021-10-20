//
//  WDTNUploadManager.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/15.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNUploadManager.h"
#import "WDTNAFResponseSerialization.h"
#import "WDTNRequestProcessor.h"
#import "WDTNControlTask.h"
#import "WDTNResponseHandler.h"
#import "WDTNPrivateDefines.h"
#import "WDTNUtils.h"
#import "WDTNNetwrokErrorDefine.h"
#import "WDTNPrivateDefines.h"

#import <AFNetworking/AFURLSessionManager.h>


@interface WDTNUploadTask : NSObject
@property (nonatomic, strong) NSString *taskIdentifier;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@property (nonatomic, strong) WDTNMultipartFormData *formData;
@property (nonatomic, strong) WDTNResponseHandler *handler;
///< 发送请求的时间
@property (nonatomic, assign) NSTimeInterval requestTime;

#ifdef TEST_TAG
///< 应用调用时间
@property (nonatomic, assign) NSTimeInterval inputRequestTime;
///< AFNetWorking 返回时间
@property (nonatomic, assign) NSTimeInterval AFNetWorkingResponseTime;
///< 网络扩展库返回时间
@property (nonatomic, assign) NSTimeInterval WDNEResponseTime;
#endif
@end

@implementation WDTNUploadTask

+ (instancetype)taskWithIdentifier:(NSString *)identifier formData:(WDTNMultipartFormData *)formData handler:(WDTNResponseHandler* )handler {
    WDTNUploadTask *task = [[WDTNUploadTask alloc] init];
    task.taskIdentifier = identifier;
    task.formData = formData;
    task.handler = handler;
    return task;
}

@end

@interface WDTNUploadManager () <WDTNControlDelegate>
@property (nonnull, strong) AFURLSessionManager *sessionManager;
/// 当前并发执行的个数
@property (nonatomic, assign) int activeRequestCount;
/// 每个request从创建到发送的执行队列
@property (nonatomic, strong) dispatch_queue_t requestQueue;
/// 去掉执行完成的task的集合。
@property (nonatomic, strong) NSMutableDictionary *currentTotalTasksDict;
/// 等待队列
@property (nonatomic, strong) NSMutableArray *queuedTasks;
@end

@implementation WDTNUploadManager

+ (instancetype)defaultManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSessionManager];
        
        _requestQueue = dispatch_queue_create("com.weidian.WDTNUploadManager.requestQueue", DISPATCH_QUEUE_SERIAL);
        _maximumConnections =  4; // URLSession 的默认值就是4
        _activeRequestCount = 0;
        
        _currentTotalTasksDict = [[NSMutableDictionary alloc] init];
        _queuedTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initSessionManager {
    _sessionManager = [[AFURLSessionManager alloc] init];
    _sessionManager.completionGroup = dispatch_group_create(); // response执行队列的group
    _sessionManager.completionQueue = dispatch_queue_create("com.weidian.WDTNUploadManager.completionQueue", DISPATCH_QUEUE_SERIAL); // response执行的队列
    _sessionManager.responseSerializer = (id<AFURLResponseSerialization>)[[WDTNAFResponseSerialization alloc] init];
}

#pragma mark - public

- (WDTNControlTask *)postWithFormData:(WDTNMultipartFormData *)formData
                                success:(WDTNReqResSuccessBlock)success
                                failure:(WDTNReqResFailureBlock)failure {
#ifdef TEST_TAG
    NSTimeInterval inputReqTime = [[NSDate date] timeIntervalSince1970];//CFAbsoluteTimeGetCurrent();
#endif
    NSString *taskIdentifier = [WDTNRequestProcessor requestIdForURL:formData.url params:formData.params];
    dispatch_async(_requestQueue, ^{
        // 保存参数
        WDTNResponseHandler *handler = [[WDTNResponseHandler alloc] initWithHandlerID:nil success:success failure:failure];
        WDTNUploadTask *task = [WDTNUploadTask taskWithIdentifier:taskIdentifier formData:formData handler:handler];
#ifdef TEST_TAG
        task.inputRequestTime = inputReqTime;
#endif
        self.currentTotalTasksDict[taskIdentifier] = task;
        // 是否允许发起请求
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            // 立即请求
            [self startTask:task];
        } else {
            // 进入等待队列
            [self enqueueTask:task];
        }
    });
    
    if (taskIdentifier) {
        return [[WDTNControlTask alloc] initWithControlID:nil taskIdentifier:taskIdentifier delegate:self];
    } else {
        return nil;
    }
}

#pragma mark - WDTNControlDelegate

- (void)canelTask:(WDTNControlTask *)controlTask {
    dispatch_sync(_requestQueue, ^{
        WDTNUploadTask *task = _currentTotalTasksDict[controlTask.taskIdentifier];
        [task.sessionTask cancel];
        
        [_currentTotalTasksDict removeObjectForKey:controlTask.taskIdentifier];
    });
}

#pragma mark - help methods

/**
 处理sessionTask的回调
 */
- (void)taskFinished:(NSString *)taskIdentifier response:(NSURLResponse * _Nonnull)response responseData:(NSData *)responseData error:(NSError *)error {
    
#ifdef TEST_TAG
    NSTimeInterval AFNetWorkingResponseTime = [[NSDate date] timeIntervalSince1970];//CFAbsoluteTimeGetCurrent();
#endif
    
    WDTNUploadTask *task = [self returnAndRemoveTask:taskIdentifier];
    
    NSString *retFunction = task.formData.retFunction;
    NSDictionary *jsonContent = nil;
    if (error == nil) {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (retFunction != nil && retFunction.length > 0) {
            responseString = [self substringWithoutFunction:retFunction str:responseString];
        }
        
        jsonContent = [WDTNUtils jsonParse:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        // json 解析错误
        if (jsonContent == nil) {
            error = [NSError errorWithDomain:WDTNError_JsonParse_failed_domain code:WDTNError_JsonParse_failed userInfo:nil];
        }
    }
    
    if (error != nil) {
        WDTNLog(@"Upload error :%@",error);
        [self safeCallFailureBlock:task response:response error:error];
    } else {
        WDTNLog(@"Upload success :%@",jsonContent);
#ifdef TEST_TAG
        NSTimeInterval WDNEResponseTime = [[NSDate date] timeIntervalSince1970];//CFAbsoluteTimeGetCurrent();
        
        NSDictionary *timeDict = @{@"startHandleTime":@(task.requestTime),
                                   @"requestTime":@(task.requestTime),
                                   @"AFNetWorkingResponseTime":@(AFNetWorkingResponseTime),
                                   @"WDNEResponseTime":@(WDNEResponseTime),
                                   @"costTime":[NSString stringWithFormat:@"cache:%@;rs:%@;cb:%@;timemore=%@;requestmore=%@", @(task.requestTime - task.inputRequestTime), @(AFNetWorkingResponseTime - task.requestTime), @(WDNEResponseTime - task.inputRequestTime), (WDNEResponseTime - task.inputRequestTime) > 2 ? @"long":@"short", (AFNetWorkingResponseTime - task.requestTime) > 2 ? @"long":@"short"]
                                   };
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        [tmp addEntriesFromDictionary:jsonContent];
        tmp[@"time"] = timeDict;
        jsonContent = tmp;
#endif
        [self safeCallSuccessBlock:task response:response result:jsonContent];
    }
    
    dispatch_async(_requestQueue, ^{
        [self decrementActiveTaskCount];
        [self startNextTaskIfNecessary];
    });
}

- (void)safeCallSuccessBlock:(WDTNUploadTask *)task response:(NSURLResponse * _Nonnull)response result:(NSDictionary *)result {
    if (task.handler != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (task.handler.successBlock != nil) {
                task.handler.successBlock(result, response, task.sessionTask.originalRequest);
            }
        });
    }
}

- (void)safeCallFailureBlock:(WDTNUploadTask *)task response:(NSURLResponse * _Nonnull)response error:(NSError *)error {
    if (task.handler != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (task.handler.failureBlock != nil) {
                task.handler.failureBlock(error, response, task.sessionTask.originalRequest);
            }
        });
    }
}

// 当前并发数是否小于最大并发数
- (BOOL)isActiveRequestCountBelowMaximumLimit {
    return _activeRequestCount < _maximumConnections;
}

// 开始请求，activeCount + 1.
- (void)startTask:(WDTNUploadTask *)task {
    _activeRequestCount += 1;
    
    neweakify(self);
    NSURLRequest *request = [self requestWithFormData:task.formData];
    NSURLSessionDataTask *sessionTask = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil
                                                           completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                               nestrongify(self);

                                                               [NEStrong_self taskFinished:task.taskIdentifier
                                                                                  response:response
                                                                              responseData:responseObject
                                                                                     error:error];
                                                           }];
    
    task.sessionTask = sessionTask;
    
    [sessionTask resume];
    
    NSTimeInterval requestTime = [[NSDate date] timeIntervalSince1970];
    task.requestTime = requestTime;
}

// 根据优先级进入等待队列
- (void)enqueueTask:(WDTNUploadTask *)task {
    [_queuedTasks addObject:task];
}

#pragma mark - private methods

- (WDTNUploadTask *)returnAndRemoveTask:(NSString *)identifier {
    // 因为删除task时，可能同时存在添加task的情况，所以将操作放到同一个队列里面执行。
    __block WDTNUploadTask *task = nil;
    dispatch_sync(_requestQueue, ^{
        task = _currentTotalTasksDict[identifier];
        [_currentTotalTasksDict removeObjectForKey:identifier];
    });
    return task;
}

// 在_requestQueue中执行
- (void)decrementActiveTaskCount {
    if (self.activeRequestCount > 0) {
        self.activeRequestCount -= 1;
    }
}

// 在_requestQueue中执行
- (void)startNextTaskIfNecessary {
    if ([self isActiveRequestCountBelowMaximumLimit]) {
        WDTNUploadTask *task = [self dequeueTask];
        if (task != nil) {
            [self startTask:task];
        }
    }
}

// 返回队列最前面的task.
- (WDTNUploadTask *)dequeueTask {
    WDTNUploadTask *task = nil;
    if (_queuedTasks.count > 0) {
        task = _queuedTasks.firstObject;
        [_queuedTasks removeObjectAtIndex:0];
    }
    return task;
}

#pragma mark - getter && setter

- (void)setMaximumConnections:(NSInteger)maximumConnections {
    dispatch_async(_requestQueue, ^{
        _maximumConnections = maximumConnections;
    });
}

// 创建 request
- (NSURLRequest *)requestWithFormData:(WDTNMultipartFormData *)formData {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:formData.url]];
    request.HTTPShouldHandleCookies = NO;
    
    if (request == nil) {
        return nil;
    }
    
    NSString *boundary = createMultipartFormBoundary();
    
    // 1.HTTPHeader
    request.HTTPMethod = @"POST";
    
    NSString *content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    // 2.添加自定义header
    if (formData.HTTPHeader != nil) {
        [request setAllHTTPHeaderFields:formData.HTTPHeader];
    }
    
    // 3.body
    NSMutableData *requestData = [NSMutableData data];
    // 分界线
    NSString *MPboundary    = [NSString stringWithFormat:@"--%@", boundary];
    // 结束符
    NSString *endMPboundary = [NSString stringWithFormat:@"--%@--", boundary];
    
    // 3.1.params
    NSMutableString *paramsStr = [[NSMutableString alloc] init];
    NSDictionary *params = formData.params;
    for (NSString *key in params.allKeys) {
        [paramsStr appendFormat:@"%@\r\n", MPboundary];
        // 添加字段名称，换2行
        [paramsStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        // 添加字段的值
        [paramsStr appendFormat:@"%@\r\n",params[key]];
    }
    [requestData appendData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 3.2.partArray, 多文件
    NSArray *partArray= formData.partArray;
    NSMutableString *partStr = nil;
    for (NSDictionary *dict in partArray) {
        partStr = [[NSMutableString alloc] init];
        // 添加分界线，换行
        [partStr appendFormat:@"%@\r\n", MPboundary];
        // 文件名称
        [partStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
         dict[WDTNFromPartKey], dict[WDTNFromPartFilename]];
        // 声明上传文件的格式
        [partStr appendFormat:@"Content-Type:%@\r\n\r\n", dict[WDTNFromPartFileType]];
        
        [requestData appendData:[partStr dataUsingEncoding:NSUTF8StringEncoding]];
        // 文件二进制数据
        [requestData appendData:dict[WDTNFromPartFileData]];
    }
    
    // 4.加入结束符
    NSString *endBoundaryStr = [NSString stringWithFormat:@"\r\n%@",endMPboundary];
    [requestData appendData:[endBoundaryStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 5.request 添加 body
    [request setHTTPBody:requestData];
    
    return request;
}

// 每次请求随机取 boundary
static NSString * createMultipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}

// 截掉回调函数
- (NSString *)substringWithoutFunction:(NSString *)retFunction str:(NSString *)str  {
    NSString *pattern = [NSString stringWithFormat:@"%@\\((\\{.*?\\})\\).*?",retFunction];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
    if (results.count > 0) {
        NSTextCheckingResult *result = results[0];
        if (result.numberOfRanges > 1) {
            return [str substringWithRange:[result rangeAtIndex:1]];
        }
    }
    return str;
}

- (NSString *)stringForHeaders:(NSDictionary *)headers {
    NSMutableString *headerString = [NSMutableString string];
    for (NSString *field in [headers allKeys]) {
        [headerString appendString:[NSString stringWithFormat:@"%@: %@\r\n", field, [headers valueForKey:field]]];
    }
    [headerString appendString:@"\r\n"];
    return [NSString stringWithString:headerString];
}

@end
