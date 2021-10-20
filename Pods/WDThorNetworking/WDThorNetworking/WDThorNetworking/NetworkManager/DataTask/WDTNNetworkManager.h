//
//  WDTNNetworkManager.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WDTNDefines.h"

@class WDTNRequestConfig;
@class WDTNControlTask;

/**
 对 NSURLSession 的扩展，支持动态修改并发数。
 */
@interface WDTNNetworkManager : NSObject

// 默认并发数4，可动态修改。
@property (nonatomic, assign) NSInteger maximumConnections;

+ (instancetype)defalutManager;

/**
 不想使用默认的单例类时，可以创建一个manager，在独立的队列中执行请求。
 */
- (instancetype)init;
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 自定义config的类型, 一种类型设置一次即可，ConfigManager会一直持有该config.
 
 @param config 自定义的requestConfig
 @param type   自定义的type
 */
- (void)setConfig:(WDTNRequestConfig *)config type:(NSString *)type;

/**
 获取相应类型的自定义config.
 
 @param type   自定义的type
 
 @return 返回RequestConfig
 */
- (WDTNRequestConfig *)configForType:(NSString *)type;

/**
 便捷方法，默认发送 proxy 的请求
 */
- (WDTNControlTask *)POST:(NSString *)url
                   params:(id)params
                  success:(WDTNReqResSuccessBlock)successBlock
                  failure:(WDTNReqResFailureBlock)failureBlock;

/**
 该接口会将参数处理成 proxy 服务端接口定义的数据格式。

 @param url             post 请求的 url，不能带参数
 @param params          请求参数，一般是字典类型，支持json object
 @param type            requestConfig的类型
 @param successBlock    请求成功的回调，在主线程执行。
 @param failureBlock    请求失败的回调，在主线程执行。

 @return 返回controlTask，可以取消正在执行的请求。
 */
- (WDTNControlTask *)POST:(NSString *)url
                   params:(id)params
               configType:(NSString *)type
                  success:(WDTNReqResSuccessBlock)successBlock
                  failure:(WDTNReqResFailureBlock)failureBlock;

/**
 可以指定IP
 
 @param url             post请求的url
 @param strictTarget    ip:端口
 @param moduleName      区分来源
 @param pageName        区分来源, UT
 @param params          请求参数，一般是字典类型，支持json object
 @param type            requestConfig的类型
 @param successBlock    请求成功的回调，在主线程执行。
 @param failureBlock    请求失败的回调，在主线程执行。
 @return                返回controlTask，可以取消正在执行的请求。
 */
- (WDTNControlTask *)POST:(NSString *)url
             strictTarget:(NSString *)strictTarget
               moduleName:(NSString *)moduleName
                 pageName:(NSString *)pageName
                   params:(id)params
               configType:(NSString *)type
                  success:(WDTNReqResSuccessBlock)successBlock
                  failure:(WDTNReqResFailureBlock)failureBlock;


+ (NSDictionary *)thorRequestParse:(NSURLRequest*)thorRequest;

@end
