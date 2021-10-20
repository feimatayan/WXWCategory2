//
//  WDTNRequestConfig.h
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNDataPipeline.h"


typedef NS_ENUM(NSInteger, WDTNQueuePriority) {
    WDTNQueuePriorityLow = -4,        // 添加到低优先级队列的末尾
    WDTNQueuePriorityNormal = 0,      // 添加到普通队列的末尾
    WDTNQueuePriorityHigh = 4,        // 添加到高优先级队列的末尾
};


@protocol WDTNRequestConfigDelegate;
@protocol WDTNVarHeaderOnSceneDelegate;
@protocol WDTNStaticHeaderOnSceneDelegate;
@protocol WDTNAppConfigDelegate;

/**
 请求参数和数据处理的配置项
 */
@interface WDTNRequestConfig : NSObject

/// 是否使用thor网关协议
@property (nonatomic) BOOL useThorProtocol;

/// config instance对应的type类型，方便业务进行判断，进行其他处理
@property (nonatomic, readonly) NSString *configType;
/// 通过代理动态获取responsePipeline
@property (nonatomic, weak) id<WDTNRequestConfigDelegate> responseDelegate;
/// header参数，是否加密, 2:加密，0:不加密
@property (nonatomic, readonly) NSInteger reqEncryStatus;
/// header参数，是否压缩; 1:gzip压缩，0:不压缩
@property (nonatomic, readonly) NSInteger reqZipType;
/// 加密密钥map的key值;
@property (nonatomic, readonly) NSString *passKeyId;
/// passId的签名id;
@property (nonatomic, readonly) NSString *signKeyId;
/// 请求的优先级,默认优先级:normal.
@property (nonatomic, readonly) NSInteger queuePriority;
/// 请求时数据的压缩、加密处理流程;
/// 输入类型: NSData, 输出类型: NSData.
@property (nonatomic, strong) WDTNDataPipeline *requestPipeline;
/// 响应时数据的解密、解压、json 解析处理流程;
/// 输入类型: NSData, 输出类型: NSDictionary.
//@property (nonatomic, strong) WDTNDataPipeline *responsePipeline;

/// 动态参数代理
@property (weak, nonatomic) id<WDTNVarHeaderOnSceneDelegate> varHeaderDelegate;
/// 静态参数代理
@property (weak, nonatomic) id<WDTNStaticHeaderOnSceneDelegate> staticHeaderDelegate;
// appConfig代理
@property (nonatomic, weak) id<WDTNAppConfigDelegate> appConfigDelegate;

- (instancetype)initWithConfigType:(NSString *)configType
                    reqEncryStatus:(NSInteger)status
                        reqZipType:(NSInteger)type
                         passKeyId:(NSString *)keyid
                         signKeyId:(NSString *)signid
                     queuePriority:(NSInteger)priority;

@end


@protocol WDTNRequestConfigDelegate <NSObject>

@optional
/**
 response解析时，HTTPURLResponse的headerField中包含解密解压标识。需要根据proxy下发的encryStatus和gzipType字段确定数据是否解密和解压，所以使用代理在 response 时获取responsePipeline。
 "encryStatus"取值： 0:不加密， 1:解密 －1:服务端解密失败;
 "gzipType": 0：不压缩,1：解压缩;
 
 @param config         发起请求时type对应的RequestConfig
 @param resEncryStatus response header解析的encryStatus值
 @param resGzipType    response header解析的gzipType值
 
 @return response的数据处理管道
 */
- (WDTNDataPipeline *)responsePipelineForConfig:(WDTNRequestConfig *)config
                                 resEncryStatus:(NSInteger)resEncryStatus
                                    resGzipType:(NSInteger)resGzipType;

@end
