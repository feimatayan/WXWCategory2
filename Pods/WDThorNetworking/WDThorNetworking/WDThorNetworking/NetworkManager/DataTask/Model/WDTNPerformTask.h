//
//  WDTNPerformTask.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNDefines.h"
#import "WDTNPrivateDefines.h"
#import "WDTNResponseHandler.h"


@class WDTNRequestConfig;

@interface WDTNPerformTask : NSObject

/// dataTask的id, manager通过taskIdentifier找到dataTask进行操作。
@property (nonatomic, strong) NSString *taskIdentifier;
/// 实际发起请求的对象
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
/// response的自定义解析流程
@property (nonatomic, strong) WDTNRequestConfig *config;
/// 保存dataTask的多个block块
@property (nonatomic, strong) NSMutableArray <WDTNResponseHandler*> *responseHandlers;

@property (nonatomic, copy) NSString *url; ///< 发起请求时创建request的参数
@property (nonatomic, copy) NSString *strictTarget; // 日常指定机器
@property (nonatomic, copy) NSDictionary *params; ///< 发起请求时创建request的参数

@property (nonatomic, strong) NSDictionary *HTTPHeader; ///< 只用于日志打印
@property (nonatomic, strong) NSDictionary *publicParams; ///< 只用于日志打印

@property (nonatomic, assign) BOOL reStart;

// 时间校验的重试次数
@property (nonatomic, assign) NSUInteger verifyTimes;

// UT
@property (nonatomic, copy  ) NSString          *moduleName;
@property (nonatomic, copy  ) NSString          *pageName;

@property (nonatomic, assign) CFAbsoluteTime    utWaitRequestTime;
@property (nonatomic, assign) CFAbsoluteTime    utThorRequestTime;
@property (nonatomic, assign) CFAbsoluteTime    utThorResponseTime;

// 测试执行时间使用
#ifdef TEST_TAG
///< AFNetWorking 返回时间
@property (nonatomic, assign) NSTimeInterval AFNetWorkingResponseTime;
///< 网络扩展库返回时间
@property (nonatomic, assign) NSTimeInterval WDNEResponseTime;
#endif

- (void)addResponseHandler:(WDTNResponseHandler *)handler;

- (void)removeHandlerById:(NSString *)handlerID;

@end

