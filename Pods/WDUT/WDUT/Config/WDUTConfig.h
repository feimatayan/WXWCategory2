//
//  WDUTConfig.h
//  WDUT
//
//  Created by WeiDian on 15/12/25.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WDUT_CONFIG_PROTOCOL_VERSION   @"0.0.5"

/**
 * 失败后重试次数
 */
#define WDUT_RETRY_MAX_COUNT             2

#define WDUT_MAX_FAILED_COUNT 10

#define WDUT_MAX_CONCURRENT_OPERATION_NUMBER 5

#define WDUT_MIN_TIMED_PROCESSOR_INTERVAL 300

//单条日志最大长度
#define WDUT_MAX_LENGTH_SINGLE_LOG 1024 * 1024

typedef NS_ENUM(NSInteger, WDUTReportStrategy) {
    /**
     * 批量上报，达到缓存临界值时触发发送
     */
            WDUTReportStrategyBatch = 100,
    /**
     * 实时上报
     */
            WDUTReportStrategyInstant = 0,
};

typedef NS_ENUM(NSInteger, WDUTEnvType) {
    WDUT_ENV_DAILY = 1,
    WDUT_ENV_PRE,
    WDUT_ENV_RELEASE,
};

@interface WDUTConfig : NSObject

/**
 * WeiDian相关业务App分配的应用唯一AppKey标识
 */
@property(nonatomic, copy) NSString *appKey;

@property(nonatomic, assign) WDUTEnvType envType;

// UT功能开关
@property (nonatomic, assign) BOOL utEnable;

// UT上报功能开关
@property (nonatomic, assign) BOOL uploadEnable;

// debug mode, 上传不加密不压缩
//@property (nonatomic, assign) BOOL debugMode;

//上传重试间隔，单位毫秒
@property(nonatomic, assign) NSInteger uploadRetryInterval;

//session更新时间，单位秒
@property(nonatomic, assign) NSInteger sessionRefreshDuration;

// 打包上传配置
@property(nonatomic, strong) NSDictionary *batchNumOfUpload;

// 优先级配置
@property(nonatomic, strong) NSDictionary *eventPriorityMap;

// 采样配置
@property(nonatomic, strong) NSDictionary *sampleRateMap;

/// ut自身采样率
@property(nonatomic, assign) NSInteger selfSampleRate;

// 页面进出跟踪开关
@property(nonatomic, assign) BOOL pageTrackManually;

// 位置跟踪开关
@property(nonatomic, assign) BOOL locationTrackManually;

// 并发数
@property (nonatomic, assign) NSInteger maxConcurrentCount;

// 定时上传间隔(单位: ms)
@property (nonatomic, assign) NSInteger timedProcessorInterval;

// 是否用锁控制同步
@property (nonatomic, assign) BOOL threadSafeUsingLock;

// 不记录页面事件的页面
@property (nonatomic, strong) NSMutableSet *filteredPageList;

// 页面嵌套情况下，取子页面
@property (nonatomic, strong) NSMutableSet *specialPages;

//config转为单例，控制内部逻辑，上下文信息移到contextInfo中
+ (instancetype)instance;

//过渡一下，conf上是数组，转为map
- (void)setSampleMap:(NSArray *)sampleRateList;

- (void)setPriorityMap:(NSArray *)eventPriorityList;

@end


