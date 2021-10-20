//
//  WDNetworkConstant.m
//  WDNetworkingDemo
//
//  Created by yangxin02 on 2018/8/28.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <objc/runtime.h>

#import "WDNetworkConstant.h"
#import "WDNDeviceInfoUtil.h"


NSString * const kWDNetworkTaskStartTimeKey = @"WDNetworkTaskStartTimeKey";

dispatch_queue_t wdn_context_serial_queue() {
    static dispatch_queue_t _queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_queue_create("WDNBaseHandler.SERIAL.Queue", DISPATCH_QUEUE_SERIAL);
    });
    return _queue;
}

dispatch_queue_t wdn_create_default_queue(const char * label, long identifier) {
    dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(identifier, 0);
    dispatch_set_target_queue(queue, globalQueue);
    return queue;
}

dispatch_queue_t wdn_request_queue() {
    static dispatch_queue_t _request_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _request_queue = wdn_create_default_queue("com.weidian.networking.request", DISPATCH_QUEUE_PRIORITY_HIGH);
    });
    return _request_queue;
}

dispatch_queue_t wdn_reponse_queue() {
    static dispatch_queue_t _reponseQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reponseQueue = wdn_create_default_queue("com.weidian.networking.reponse", DISPATCH_QUEUE_PRIORITY_HIGH);
    });
    return _reponseQueue;
}

AFHTTPSessionManager * wdn_session_manager() {
    static dispatch_once_t _once;
    static AFHTTPSessionManager *_sessionM;
    dispatch_once(&_once, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSMutableArray *protocolClasses = [NSMutableArray new];
        NSArray *customizeProtocols = [WDNetworkConstant customizeProtocolClasses];
        if (customizeProtocols.count > 0) {
            [protocolClasses addObjectsFromArray:customizeProtocols];
        }
        Class httpDNSProtocol = NSClassFromString(@"VDDProtocol");
        if (httpDNSProtocol) {
            [protocolClasses addObject:httpDNSProtocol];
        }
        if (protocolClasses.count > 0) {
            configuration.protocolClasses = protocolClasses;
        }
        
        _sessionM = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:200];
        _sessionM.responseSerializer = responseSerializer;
        
        #warning "默认是1, 用于测试设置2, 看看是否更快. by yangxin02"
        _sessionM.operationQueue.maxConcurrentOperationCount = 2;
        
        _sessionM.completionQueue = wdn_create_default_queue("com.weidian.networking.complete", DISPATCH_QUEUE_PRIORITY_HIGH);
        [_sessionM setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSArray<id<NSURLSessionDataDelegate>> *URLSessionDelegates = [WDNetworkConstant URLSessionDelegates];
            for (id<NSURLSessionDataDelegate> delegate in URLSessionDelegates) {
                if (delegate &&
                    [delegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
                    [delegate URLSession:session
                                    task:task
                         didSendBodyData:bytesSent
                          totalBytesSent:totalBytesSent
                totalBytesExpectedToSend:totalBytesExpectedToSend];
                }
            }
        }];
        [_sessionM setDataTaskDidReceiveResponseBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response){
            NSArray<id<NSURLSessionDataDelegate>> *URLSessionDelegates = [WDNetworkConstant URLSessionDelegates];
            for (id<NSURLSessionDataDelegate> delegate in URLSessionDelegates) {
                if (delegate &&
                    [delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
                    [delegate URLSession:session
                                dataTask:dataTask
                      didReceiveResponse:response
                       completionHandler:^(NSURLSessionResponseDisposition disposition) {}];
                }
            }
            
            objc_setAssociatedObject(dataTask,
                                     &kWDNetworkTaskStartTimeKey,
                                     @(CFAbsoluteTimeGetCurrent()),
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            return NSURLSessionResponseAllow;
        }];
        [_sessionM setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData * data) {
            NSArray<id<NSURLSessionDataDelegate>> *URLSessionDelegates = [WDNetworkConstant URLSessionDelegates];
            for (id<NSURLSessionDataDelegate> delegate in URLSessionDelegates) {
                if (delegate &&
                    [delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
                    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
                }
            }
        }];
        [_sessionM setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
            NSArray<id<NSURLSessionDataDelegate>> *URLSessionDelegates = [WDNetworkConstant URLSessionDelegates];
            for (id<NSURLSessionDataDelegate> delegate in URLSessionDelegates) {
                if (delegate &&
                    [delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
                    [delegate URLSession:session task:task didCompleteWithError:error];
                }
            }
        }];
    });
    return _sessionM;
}


/**
 目前只有图片上传在用

 @return NSOperationQueue
 */
NSOperationQueue * wdn_queue() {
    static NSOperationQueue *_httpQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpQueue = [[NSOperationQueue alloc] init];
        _httpQueue.maxConcurrentOperationCount = 5;
        
        void (^block)(NSNotification *note) = ^(NSNotification *note) {
            WDNDeviceInfoUtil *deviceInfoUtil = [WDNDeviceInfoUtil shareUtil];
            WDNStatus currentNetStatus = deviceInfoUtil.currentNetStatus;
            NSString *cellularNetType = deviceInfoUtil.cellularNetType;
            
            //并发数不能开太多
            NSUInteger count = 8;
            //考虑到iphone的CPU性能都很好, 暂时不考虑单核和双核带来的性能影响.
            //目前还不知道监控网路上行和下行的速度
            //没有查到如何获取iphone的信号强度, 私有api可能会通不过
            if (currentNetStatus == WDNStatusWIFI) {
                //wifi暂时不减
            } else {
                if (cellularNetType == CTRadioAccessTechnologyLTE) {
                    //理论下载(10)MB和上传(1)MB级别
                } else if (cellularNetType == CTRadioAccessTechnologyCDMAEVDORevB
                           || cellularNetType == CTRadioAccessTechnologyCDMAEVDORevA
                           || cellularNetType == CTRadioAccessTechnologyHSUPA
                           || cellularNetType == CTRadioAccessTechnologyHSDPA) {
                    //理论下载(1000)KB和上传(100)KB级别
                    count -= 2;
                } else if (cellularNetType == CTRadioAccessTechnologyeHRPD
                           || cellularNetType == CTRadioAccessTechnologyCDMAEVDORev0) {
                    //理论下载(100)KB和上传(10)KB级别
                    count -= 4;
                } else if (cellularNetType == CTRadioAccessTechnologyCDMA1x
                           || cellularNetType == CTRadioAccessTechnologyEdge
                           || cellularNetType == CTRadioAccessTechnologyGPRS) {
                    //CDMA1x, 比GPRS稍微好点
                    //Edge, 理论的上下行速度是GPRS的几倍
                    //GPRS, 理论下载(10)KB和上传(1)KB级别
                    count -= 6;
                }
            }
            
            _httpQueue.maxConcurrentOperationCount = count;
        };
        block(nil);
        
        [[NSNotificationCenter defaultCenter] addObserverForName:WDNetWorkStatusChangeNOTIFICATION
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:block];
    });

    return _httpQueue;
}


@interface WDNetworkConstant ()

@property (nonatomic, strong) NSMutableArray<id<NSURLSessionDataDelegate>> *URLSessionDelegates;
@property (nonatomic, copy) NSArray *customizeProtocolClasses;

@end

@implementation WDNetworkConstant

+ (instancetype)sharedConstant {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] initPrivate];
    });
    return _sharedInstance;
}

#pragma mark - URLSessionDelegates

+ (NSArray<id<NSURLSessionDataDelegate>> *)URLSessionDelegates {
    @synchronized ([WDNetworkConstant class]) {
        return [WDNetworkConstant sharedConstant].URLSessionDelegates;
    }
}

+ (void)setURLSessionDelegate:(id<NSURLSessionDataDelegate>)delegate {
    @synchronized ([WDNetworkConstant class]) {
        if (!delegate) {
            return;
        }
        
        WDNetworkConstant *shareConstant = [WDNetworkConstant sharedConstant];
        if ([shareConstant.URLSessionDelegates indexOfObject:delegate] == NSNotFound) {
            [shareConstant.URLSessionDelegates addObject:delegate];
        }
    }
}

#pragma mark - ProtocolClasses

+ (NSArray *)customizeProtocolClasses {
    return [WDNetworkConstant sharedConstant].customizeProtocolClasses;
}

+ (void)setCustomizeProtocolClasses:(NSArray *)protocolClasses {
    [WDNetworkConstant sharedConstant].customizeProtocolClasses = protocolClasses;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        self.URLSessionDelegates = [NSMutableArray array];
    }
    return self;
}

@end
