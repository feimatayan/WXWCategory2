//
//  WDTNNetworkManager.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNNetworkManager.h"
#import "WDTNNetworkManager+Thor.h"
#import <AFNetworking/AFNetworking.h>
// model类
#import "WDTNPerformTask.h"
// config获取
#import "WDTNRequestConfig.h"
#import "WDTNRequestConfigManager.h"
#import "WDTNNetworkConfig.h"
#import "WDTNNetwrokConfig.h"
// request生成
#import "WDTNRequestProcessor.h"
// response解析
#import "WDTNResponseProcessor.h"
#import "WDTNUtils.h"
#import "WDTNControlTask.h"
#import "WDTNAFResponseSerialization.h"
#import "WDTNThorParameterProcessor.h"


@interface WDTNNetworkManager () <WDTNControlDelegate>

/// 包装AFURLSessionManager进行网络请求
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
/// 当前并发执行的个数
@property (nonatomic, assign) int activeRequestCount;
/// 每个request从创建到发送的执行队列
@property (nonatomic) dispatch_queue_t sysQueue;

/// 去掉执行完成的task的集合. 相同请求的可以添加多个回调函数。
@property (nonatomic, strong) NSMutableDictionary *currentTotalTasksDict;
/// 高优先级等待队列
@property (nonatomic, strong) NSMutableArray *highPriorityQueuedTasks;
/// 普通优先级等待队列
@property (nonatomic, strong) NSMutableArray *normalPriorityQueuedTasks;
/// 低优先级等待队列
@property (nonatomic, strong) NSMutableArray *lowPriorityQueuedTasks;

@end

@implementation WDTNNetworkManager

+ (instancetype)defalutManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    Class httpDNSProtocol = NSClassFromString(@"VDDProtocol");
    if (httpDNSProtocol) {
        defaultConfiguration.protocolClasses = @[httpDNSProtocol];
    }
    
    return [self initWithSessionConfiguration:defaultConfiguration];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sysQueue = dispatch_queue_create("com.weidian.WDTNNetworkManager.requestQueue", DISPATCH_QUEUE_SERIAL);
    
    _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    _sessionManager.completionGroup = dispatch_group_create(); // response执行队列的group
    _sessionManager.completionQueue = dispatch_queue_create("com.weidian.WDTNNetworkManager.responseQueue", DISPATCH_QUEUE_CONCURRENT);
    _sessionManager.responseSerializer = (id<AFURLResponseSerialization>)[[WDTNAFResponseSerialization alloc] init];
    
    _maximumConnections = 4;
    _activeRequestCount = 0;
    
    _currentTotalTasksDict      = [[NSMutableDictionary alloc] init];
    _highPriorityQueuedTasks    = [[NSMutableArray alloc] init];
    _normalPriorityQueuedTasks  = [[NSMutableArray alloc] init];
    _lowPriorityQueuedTasks     = [[NSMutableArray alloc] init];
    
    // 初始化默认的config
    [WDTNRequestConfigManager sharedInstance];
    
    return self;
}

#pragma mark - public methods

- (void)setConfig:(WDTNRequestConfig *)config type:(NSString *)type {
    if (type && config) {
        [[WDTNRequestConfigManager sharedInstance] setConfig:config type:type];
    }
}


- (WDTNRequestConfig *)configForType:(NSString *)type {
    if (!type ) {
        return nil;
    }
    
    return [[WDTNRequestConfigManager sharedInstance] configByType:type];
}

- (WDTNControlTask *)POST:(NSString *)url
                   params:(id)params
                  success:(WDTNReqResSuccessBlock)successBlock
                  failure:(WDTNReqResFailureBlock)failureBlock
{
    return [self POST:url
         strictTarget:nil
           moduleName:nil
             pageName:nil
               params:params
           configType:WDTNRequestConfigForProxy
              success:successBlock
              failure:failureBlock];
}

- (WDTNControlTask *)POST:(NSString *)url
                   params:(id)params
               configType:(NSString *)type
                  success:(WDTNReqResSuccessBlock)successBlock
                  failure:(WDTNReqResFailureBlock)failureBlock
{
    return [self POST:url
         strictTarget:nil
           moduleName:nil
             pageName:nil
               params:params
           configType:type
              success:successBlock
              failure:failureBlock];
}

- (WDTNControlTask *)POST:(NSString *)url
             strictTarget:(NSString *)strictTarget
               moduleName:(NSString *)moduleName
                 pageName:(NSString *)pageName
                   params:(id)params
               configType:(NSString *)type
                  success:(WDTNReqResSuccessBlock)successBlock
                  failure:(WDTNReqResFailureBlock)failureBlock
{
    // 没有 url 和 type 报错！
    if (url == nil || type == nil) {
        WDTNLog(@"The URL(%@), type(%@) have nil value!", url, type);
        return nil;
    }
    
    // 1. 获取config,一般在发送请求前就创建好config了，所以不考虑多线程同步问题
    WDTNRequestConfig *config = [[WDTNRequestConfigManager sharedInstance] configByType:type];
    if (config == nil) {
        WDTNLog(@"The URL(%@)'s type(%@) config not found!", url, type);
        return nil;
    }
    
    // 同一个url可能同时被请求多次，所以一个requestId可能对应多个handlerID。
    NSString *taskIdentifier = [WDTNRequestProcessor requestIdForURL:url params:params];
    NSString *handlerID = [NSString stringWithFormat:@"%p", &handlerID];
    
    dispatch_async(_sysQueue, ^{
        WDTNResponseHandler *handler = [[WDTNResponseHandler alloc] initWithHandlerID:handlerID success:successBlock failure:failureBlock];
        
        // 2. 检查是否已经存在相同请求
        WDTNPerformTask *existingPerformTask = self.currentTotalTasksDict[taskIdentifier];
        // 2.1) 存在，添加responseHandle到task.
        if (existingPerformTask != nil) {
            [existingPerformTask addResponseHandler:handler];
            return ;
        }
        
        // 3. 保存参数，等到发送请求时再创建request
        WDTNPerformTask *performTask = [[WDTNPerformTask alloc] init];
        performTask.taskIdentifier = taskIdentifier;
        performTask.config = config;
        performTask.url = url;
        performTask.params = params;
        
        performTask.pageName = pageName;
        performTask.moduleName = moduleName;
        if (type == WDTNRequestConfigForThorTest) {
            performTask.strictTarget = strictTarget;
        } else {
            performTask.strictTarget = nil;
        }
        
        [performTask addResponseHandler:handler];
        self.currentTotalTasksDict[taskIdentifier] = performTask;
        
        performTask.utWaitRequestTime = CFAbsoluteTimeGetCurrent();
        
        [self enqueueTask:performTask];
        if (config.useThorProtocol && ![WDTNNetworkConfig querySecurityItem:config.configType]) {
            [WDTNNetworkConfig watchSecurityItem:config.configType callback:^{
                dispatch_async(self.sysQueue, ^{
                    // 保证并发数都用上
                    [self startNextTaskIfNecessary];
                    [self startNextTaskIfNecessary];
                    [self startNextTaskIfNecessary];
                    [self startNextTaskIfNecessary];
                });
            }];
        } else {
            [self startNextTaskIfNecessary];
        }
    });
    
    // 5. 返回control对象
    if (taskIdentifier) {
        return [[WDTNControlTask alloc] initWithControlID:handlerID taskIdentifier:taskIdentifier delegate:self];
    } else {
        return nil;
    }
}

#pragma mark - WDTNControlDelegate

/*
 https://bugly.qq.com/v2/crash-reporting/crashes/900015401/136717?pid=2
 https://bugly.qq.com/v2/crash-reporting/crashes/900015401/136238?pid=2
 这个crash调过来怎么会是-[__NSDictionaryM taskIdentifier]: unrecognized selector sent to instance
 */
- (void)canelTask:(WDTNControlTask *)controlTask {
    if (![controlTask isKindOfClass:[WDTNControlTask class]]) {
        return;
    }
    
    NSString *taskIdentifier = controlTask.taskIdentifier;
    if (taskIdentifier.length == 0) {
        return;
    }
    
    dispatch_async(_sysQueue, ^{
        WDTNPerformTask *performTask = _currentTotalTasksDict[taskIdentifier];
        
        // 1. 删除request的回调函数
        NSString *controlID = controlTask.controlID;
        if (controlID.length > 0) {
            [performTask removeHandlerById:controlID];
        }
        
        // 2. count == 0说明没有其他引用了。
        if (performTask && performTask.responseHandlers.count == 0) {
            // 3. 取消请求，在-URLSession:task:didCompleteWithError:中会对_activeRequestCount减1。
            [performTask.sessionTask cancel];
            // 4. 删除task的引用
            [_currentTotalTasksDict removeObjectForKey:taskIdentifier];
        }
    });
}

#pragma mark - help methods

// 开始请求，activeCount + 1.
- (void)startTask:(WDTNPerformTask *)performTask {
    // 一进来就加1，这样创建 request 失败也可以走 taskFinished：方法。
    _activeRequestCount += 1;
    
    // 创建dataTask，每次执行时再获取公共参数，防止参数失效。
    NSError *error = nil;
    NSURLRequest *request = [WDTNRequestProcessor requestWithMethod:@"POST" task:performTask error:&error];
    if (error) {
        performTask.utThorRequestTime = CFAbsoluteTimeGetCurrent();
        
        [self taskFinished:performTask.taskIdentifier
                  response:nil
              responseData:nil
                     error:[self composeUserinfoForError:error performTask:performTask]];
    } else {
        neweakify(self);
        NSURLSessionDataTask *task = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            // 8. 在completionQueue串行队列中执行回调函数
            [NEWeak_self taskFinished:performTask.taskIdentifier
                             response:(NSHTTPURLResponse *)response
                         responseData:responseObject
                                error:error];
            
        }];
        performTask.sessionTask = task;
        
        [task resume];
        
        performTask.utThorRequestTime = CFAbsoluteTimeGetCurrent();
        
        if ([WDTNNetwrokConfig sharedInstance].isPrintAllParams == PRINT_LOG_TOTAL) {
            // 打印全量日志，包括Header
            WDTNLog(@"Send request RequestId:%@ \nURL:%@ \nHttp header:%@ \nHttp body:%@",
                    performTask.taskIdentifier,
                    performTask.url,
                    performTask.HTTPHeader,
                    [WDTNUtils stringFromJSONObject:performTask.publicParams ?: @{}]);
        } else if ([WDTNNetwrokConfig sharedInstance].isPrintAllParams == PRINT_LOG_BRIEF) {
            // 打印简要日志
            WDTNLog(@"Send request RequestId:%@ \nURL:%@ \nParams:%@",
                    performTask.taskIdentifier,
                    performTask.url,
                    performTask.params ?: @{});
        }
    }
}

- (void)reStartTask:(WDTNPerformTask *)performTask {
    dispatch_async(_sysQueue, ^{
        self.currentTotalTasksDict[performTask.taskIdentifier] = performTask;
        
        [self startTask:performTask];
    });
}

/**
 处理sessionTask的回调
 
 @param taskIdentifier 获取performTask需要
 @param responseData   服务返回数据
 @param error          请求的错误信息
 */
- (void)taskFinished:(NSString *)taskIdentifier
            response:(NSHTTPURLResponse *)HTTPResponse
        responseData:(NSData *)responseData
               error:(NSError *)error
{
    CFAbsoluteTime AFResponseTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(_sysQueue, ^{
        WDTNPerformTask *performTask = [self returnAndRemoveTask:taskIdentifier];
        //获取当前的任务，并开始下一个任务
        [self decrementActiveTaskCount];
        [self startNextTaskIfNecessary];
        
        performTask.utThorResponseTime = AFResponseTime;
        
        if (performTask.config.useThorProtocol) {
            __weak typeof(self) weakself = self;
            [self thor_processData:responseData task:performTask response:HTTPResponse cfError:error reSendBlock:^(WDTNPerformTask *task, double delay) {
                if (delay > 0) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), weakself.sysQueue, ^{
                        [weakself reStartTask:task];
                    });
                } else {
                    [weakself reStartTask:task];
                }
            } callback:^(NSDictionary *result, NSError *parseError) {
                [weakself safeCallBackTask:performTask
                                  response:HTTPResponse
                                    result:result
                                     error:parseError];
            }];
        } else {
            NSError *parseError = error;
            NSDictionary *result = nil;
            if (!parseError) {
                 result = [WDTNResponseProcessor parseForResponse:HTTPResponse
                                                             data:responseData
                                                           config:performTask.config
                                                            error:&parseError];
            }
            
            [self safeCallBackTask:performTask
                          response:HTTPResponse
                            result:result
                             error:parseError];
        }
        
#ifdef TEST_TAG
        CFAbsoluteTime WDNResponseTime = CFAbsoluteTimeGetCurrent();
        
        static int rsCount = 0;
        NSDictionary *timeDict = @{@"url":performTask.url,
                                   @"requestTime":@(performTask.utThorRequestTime),
                                   @"AFNetWorkingResponseTime":@(AFResponseTime),
                                   @"WDNEResponseTime":@(WDNResponseTime),
                                   @"cost time":[NSString stringWithFormat:@"cache:%@;rs:%@;cb:%@;timemore=%@;requestmore=%@", @(performTask.utThorRequestTime-performTask.utWaitRequestTime), @(AFResponseTime-performTask.utThorRequestTime), @(WDNResponseTime-performTask.utWaitRequestTime), (WDNResponseTime-performTask.utWaitRequestTime) > 2 ? @"long":@"short", (AFResponseTime-performTask.utThorRequestTime) > 2 ? @"long":@"short"],
                                   @"_highPriorityQueuedTasks":@(_highPriorityQueuedTasks.count),
                                   @"_normalPriorityQueuedTasks":@(_lowPriorityQueuedTasks.count),
                                   @"_lowPriorityQueuedTasks":@(_lowPriorityQueuedTasks.count),
                                   @"error":[NSString stringWithFormat:@"%@", error],
                                   @"callbackcount":[NSString stringWithFormat:@"%d", ++rsCount],};
        
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        tmp[@"time"] = timeDict;
        NSLog(@"\nresult  %@\n", tmp);
#endif
    });
}

- (void)safeCallBackTask:(WDTNPerformTask *)performTask
                response:(NSHTTPURLResponse *)response
                  result:(NSDictionary *)result
                   error:(NSError *)error
{
    if (!error) {
        WDTNLog(@"Response succeed RequestId:%@ \nURL:%@ \nResult:%@ \nAllHeaderFields:%@",
                performTask.taskIdentifier,
                performTask.url,
                result,
                [response allHeaderFields]);
        
        [self safeCallSuccessBlock:performTask response:response result:result];
    } else {
        WDTNLog(@"Response failed RequestId:%@ \nURL:%@ \nServer Error:%@ \nAllHeaderFields:%@",
                performTask.taskIdentifier,
                performTask.url,
                error,
                [response allHeaderFields]);
        
        [self safeCallFailureBlock:performTask response:response error:error];
    }
}

- (void)safeCallSuccessBlock:(WDTNPerformTask *)performTask
                    response:(NSHTTPURLResponse *)response
                      result:(NSDictionary *)result
{
    NSArray *handles = [performTask.responseHandlers copy];
    for (WDTNResponseHandler *handler in handles) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler.successBlock != nil) {
                handler.successBlock(result, response, performTask.sessionTask.originalRequest);
            }
        });
    }
}

- (void)safeCallFailureBlock:(WDTNPerformTask *)performTask
                    response:(NSHTTPURLResponse *)response
                       error:(NSError *)error
{
    NSArray *handles = [performTask.responseHandlers copy];
    for (WDTNResponseHandler *handler in handles) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler.failureBlock != nil) {
                handler.failureBlock(error, response, performTask.sessionTask.originalRequest);
            }
        });
    }
}

#pragma mark - private methods

- (NSError *)composeUserinfoForError:(NSError *)error performTask:(WDTNPerformTask *)performTask {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (performTask.url) {
        userInfo[@"url"] = performTask.url;
    }
    if (performTask.params) {
        userInfo[@"params"] = performTask.params;
    }
    
    return [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
}

// 在_requestQueue中执行
- (void)decrementActiveTaskCount {
    if (self.activeRequestCount > 0) {
        self.activeRequestCount -= 1;
    }
}

// 当前并发数是否小于最大并发数
- (BOOL)isActiveRequestCountBelowMaximumLimit {
    return _activeRequestCount < _maximumConnections;
}

- (WDTNPerformTask *)returnAndRemoveTask:(NSString *)identifier {
    WDTNPerformTask *performTask = _currentTotalTasksDict[identifier];
    [_currentTotalTasksDict removeObjectForKey:identifier];
    return performTask;
}

// 在_requestQueue中执行
- (void)startNextTaskIfNecessary {
    if ([self isActiveRequestCountBelowMaximumLimit]) {
        WDTNPerformTask *performTask = [self dequeueTask];
        if (performTask != nil) {
            [self startTask:performTask];
        }
    }
}

// 根据优先级进入等待队列
- (void)enqueueTask:(WDTNPerformTask *)performTask {
    switch (performTask.config.queuePriority) {
        case WDTNQueuePriorityHigh:
            [_highPriorityQueuedTasks addObject:performTask];
            break;
        case WDTNQueuePriorityNormal:
            [_normalPriorityQueuedTasks addObject:performTask];
            break;
        case WDTNQueuePriorityLow:
            [_lowPriorityQueuedTasks addObject:performTask];
            break;
    }
}

/// 返回队列最前面的task.
- (WDTNPerformTask *)dequeueTask {
    WDTNPerformTask *performTask = nil;
    
    if (_highPriorityQueuedTasks.count > 0) {
        performTask = _highPriorityQueuedTasks.firstObject;
        [_highPriorityQueuedTasks removeObjectAtIndex:0];
    } else if (_normalPriorityQueuedTasks.count > 0) {
        performTask = _normalPriorityQueuedTasks.firstObject;
        [_normalPriorityQueuedTasks removeObjectAtIndex:0];
    } else if (_lowPriorityQueuedTasks.count > 0) {
        performTask = _lowPriorityQueuedTasks.firstObject;
        [_lowPriorityQueuedTasks removeObjectAtIndex:0];
    }
    
    return performTask;
}

+ (NSDictionary *)thorRequestParse:(NSURLRequest*)thorRequest {
    return  [WDTNThorParameterProcessor requestThorBodyWithParse:thorRequest];
}

@end
