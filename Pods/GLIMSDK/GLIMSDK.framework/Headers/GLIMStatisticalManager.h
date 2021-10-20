//
//  GLIMStatisticalManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/21.
//  Copyright © 2017年 Koudai. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const kGLIMStatisticalAnalysisKey;

@protocol GLIMStatisticalManagerDelegate <NSObject>

/**
 添加统计日志通用接口

 @param spmID 需要埋点的key值，由BI指定
 @param eventID 区分埋点的类型值，如果为空则使用统计的默认事件值
 @param params 参数集
 @param moreParams 额外参数集
 */
- (void)imTraceNormalWithSpmID:(NSString *)spmID
                       eventID:(NSString *)eventID
                        params:(NSDictionary *)params
                    moreParams:(NSDictionary *)moreParams
                      pageName:(NSString *)pageName;
/**
 *  添加统计日志——页面进入
 *  @param spmID  埋点Key BI制定
 *  @param params 参数集
 */
- (void)imTracePageBeginWithSpmID:(NSString *)spmID
                       withParams:(NSDictionary *)params;

- (void)imTracePageBeginWithController:(UIViewController *)controller
                              pageName:(NSString *)pageName
                                params:(NSDictionary *)params;

/**
 *  添加统计日志——页面离开
 *  @param spmID  埋点Key BI制定
 *  @param params 参数集
 */
- (void)imTracePageEndEventWithSpmID:(NSString *)spmID
                          withParams:(NSDictionary *)params;

- (void)imTracePageEndWithController:(UIViewController *)controller
                            pageName:(NSString *)pageName
                              params:(NSDictionary *)params;

@optional

/**
 添加问题跟踪日志

 @param spmID 埋点Key BI指定或自定义
 @param eventID 区分埋点的类型值，如果为空则使用统计的默认事件值
 @param params 参数集
 @param moreParams 额外参数集
 */
- (void)imTraceSelfUseWithSpmID:(NSString *)spmID
                        eventID:(NSString *)eventID
                         params:(NSDictionary *)params
                     moreParams:(NSDictionary *)moreParams;
    
- (void)imTraceExposure:(NSString *)arg1
                   arg2:(NSString *)arg2
                   arg3:(NSString *)arg3
                   args:(NSDictionary *)args
               pageName:(NSString *)pageName;

@end

/**
 统计组件封装，只提供最基本的方法
 */
@interface GLIMStatisticalManager : NSObject

@property (nonatomic, weak) id<GLIMStatisticalManagerDelegate>delegate;
@property (nonatomic, strong) NSString * cuid;

+ (BOOL)isLogInfosOn;

+ (NSString *)appGroupName;

+ (instancetype)shareManager;

#pragma mark - 控件点击
/**
 *  添加统计日志——控件点击，eventID为@"2101"
 *
 *  @param spmID          spmID值
 *  @param parameters     参数集（与more同级）
 *  @param moreParameters more字段对应参数集（字典类型）
 */
+ (void)traceClickEvent:(NSString *)spmID
             parameters:(NSDictionary *)parameters
         moreParameters:(NSDictionary *)moreParameters;

+ (void)traceClickEvent:(NSString *)spmID
             parameters:(NSDictionary *)parameters
         moreParameters:(NSDictionary *)moreParameters
               pageName:(NSString *)pageName;

/**
 添加统计日志——自定义eventID

 @param eventID eventID值
 @param spmID spmID值
 @param parameters 参数集（与more同级）
 @param moreParameters more字段对应参数集（字典类型）
 */
+ (void)traceEventWithID:(NSString *)eventID
                   spmID:(NSString *)spmID
              parameters:(NSDictionary *)parameters
          moreParameters:(NSDictionary *)moreParameters;

+ (void)traceEventWithID:(NSString *)eventID
                   spmID:(NSString *)spmID
              parameters:(NSDictionary *)parameters
          moreParameters:(NSDictionary *)moreParameters
                pageName:(NSString *)pageName;
    
#pragma mark - 曝光日志
+ (void)traceExposure:(NSString *)arg1
                 arg2:(NSString *)arg2
                 arg3:(NSString *)arg3
                 args:(NSDictionary *)args
             pageName:(NSString *)pageName;

#pragma mark - 页面停留时长
/**
 *  添加统计日志——页面进入
 *
 *  @param spmID          spmID值
 */
+ (void)tracePageBeginEvent:(NSString *)spmID;

/**
 添加统计日志——页面进入

 @param spmID spmID值
 @param parameters 更多信息
 */
+ (void)tracePageBeginEvent:(NSString *)spmID
                 parameters:(NSDictionary *)parameters;

+ (void)tracePageBeginEvent:(UIViewController *)controller
                   pageName:(NSString *)pageName
                 parameters:(NSDictionary *)parameters;

/**
 *  添加统计日志——页面离开
 *
 *  @param spmID          spmID值
 */
+ (void)tracePageEndEvent:(NSString *)spmID;

/**
 添加统计日志——页面离开

 @param spmID spmID值
 @param parameters 更多信息
 */
+ (void)tracePageEndEvent:(NSString *)spmID
               parameters:(NSDictionary *)parameters;

+ (void)tracePageEndEvent:(UIViewController *)controller
                 pageName:(NSString *)pageName
               parameters:(NSDictionary *)parameters;

#pragma mark - 性能日志
/**
 *  添加统计日志——记录日志时间
 *
 *  @param spmID          spmID值
 *  @param parameters     参数集（与more同级）
 *  @param moreParameters more字段对应参数集（字典类型）
 */
+ (void)traceLogingTimeEvent:(NSString *)spmID
                  parameters:(NSDictionary *)parameters
              moreParameters:(NSDictionary *)moreParameters;

#pragma mark - 问题跟踪日志
/**
 添加kibana日志，日志仅上报到kibana
 
 @param spmID           spmID值
 @param parameters      参数集（与more同级）
 @param moreParameters  more字段对应参数集（字典类型）
 */
+ (void)traceEventForKibana:(NSString *)spmID
                 parameters:(NSDictionary *)parameters
             moreParameters:(NSDictionary *)moreParameters;

@end

#pragma mark - socket连接统计日志
@interface GLIMStatisticalManager (GLIMSocketConnection)

+ (void)logSocketConnectSuccessed:(NSString *)address time:(NSString *)time;
+ (void)logSocketConnectFailed:(NSString *)address failedReason:(NSString *)reason;

@end


#pragma mark - 统计对象
/**
 IM 统计对象，记录统计日志的关键信息
 用于输出本地日志，验证本地日志与服务器日志的一致性
 */
@interface GLIMStatisticalData : NSObject

/// spmID
@property (nonatomic, strong) NSString *spmKey;
/// spmID对应的描述信息
@property (nonatomic, strong) NSString *spmValue;
/// 触发spmID的时间戳
@property (nonatomic, assign) UInt64 timestamp;
/// 触发spmID和上一步的时间差(扩展字段）
@property (nonatomic, assign) UInt64 interval;

- (instancetype)initWithKey:(NSString *)key
                      value:(NSString *)value
                  timestamp:(UInt64)timestamp;

- (NSString *)logString;

@end
