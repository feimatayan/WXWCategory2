//
//  WDUT.h
//  WDUT
//
//  Created by WeiDian on 15/12/24.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WDUTConfig.h"

@class WDUTBuilder;

@interface WDUT : NSObject

#pragma mark - setup

/**
 * 初始化WDUT
 *
 * @param appKey WeiDian相关业务App分配的应用唯一AppKey标识
 */
+ (void)startWithAppKey:(NSString *)appKey;

/**
 * 设置环境变量
 *
 * @param envType WDUTEnvType
 */
+ (void)setEnvType:(WDUTEnvType)envType;

/**
 * 设置patch版本号
 *
 * @param patchVersion
 */
+ (void)setPatchVersion:(NSString *)patchVersion;

/**
 * 设置自定义渠道标识，默认是AppStore渠道号("appstore")
 *
 * @param channel
 */
+ (void)setChannel:(NSString *)channel;

/**
 * WT功能是否启用
 *
 * @param enable
 */
+ (void)enableUT:(BOOL)enable;

/**
 * 设置位置信息手动获取，默认自动管理

 * @param manually
 */
+ (void)setLocationTrackManually:(BOOL)manually;

/**
 获取ut内部纬度
 
 @return 纬度
 */
+ (NSString *)getLatitude;

/**
 获取ut内部经度
 
 @return 经度
 */
+ (NSString *)getLongitude;

/**
 * 设置经纬度
 *
 * @param latitude
 * @param longitude
 */
+ (void)setLatitude:(NSString *)latitude longitude:(NSString *)longitude;


/// 设置用户信息
/// @param duid
/// @param userId
/// @param phoneNumber
+ (void)setDuid:(NSString *)duid
         userId:(NSString *)userId
    phoneNumber:(NSString *)phoneNumber;

+ (void)setShopId:(NSString *)shopId;

+ (void)addFilteredPageArray:(NSArray *)pageArray;

+ (void)addSpecialPages:(NSArray *)specialPages;

/**
 * 获取设备Id
 *
 * @return 设备Id
 */
+ (NSString *)getCuid;

/**
 * 获取suid
 *
 * @return suid
 */
+ (NSString *)getSuid;

/**
 * 获取一次会话的session值
 *
 * @return sessionId
 */
+ (NSString *)getSessionId;

#pragma mark - page

/**
 * 设置page生命周期手动管理，默认自动管理
 *
 * @param manually
 */
+ (void)setPageTrackManually:(BOOL)manually;

/**
 * 手动设置进入页面
 *
 * @param page
 */
+ (void)pageAppear:(UIViewController *)page;

/**
 * 手动设置退出页面
 *
 * @param page
 */
+ (void)pageDisappear:(UIViewController *)page pageName:(NSString *)pageName;

/**
 * 设置页面别名
 *
 * @param controller
 * @param pageName
 * @param page的上下文信息
 */
+ (void)updateViewController:(id)controller pageName:(NSString *)pageName;

/**
 * 设置页面别名以及自定义参数
 *
 * @param controller
 * @param pageName
 * @param args
 */
+ (void)updateViewController:(id)controller
                    pageName:(NSString *)pageName
                        args:(NSDictionary *)args;


/**
 获取页面别名

 @param controller
 @return pageName
 */
+ (NSString *)getPageNameWithController:(id)controller;

+ (void)commitPageEventManually:(id)controller;

#pragma mark - event

/**
 * 提交事件日志记录，可携带参数上报
 * @note 事件Id需报备申请
 *
 * @param eventId 事件Id
 * @param args 携带参数上报
 * @param arg1, arg2, arg3 协议字段
 * @param policy 上报机制(实时上报, 批量上报) 默认批量
 * @param isSuccess 采样字段(区分成功&失败，对应不同的采样率) 默认成功
 */
+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args;

+ (void)commitEvent:(NSString *)eventId
               args:(NSDictionary *)args
             policy:(WDUTReportStrategy)policy;

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args;

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
             policy:(WDUTReportStrategy)policy;

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
          isSuccess:(BOOL)isSuccess;

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
          isSuccess:(BOOL)isSuccess
             policy:(WDUTReportStrategy)policy;

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
             module:(NSString *)module
          isSuccess:(BOOL)isSuccess
             policy:(WDUTReportStrategy)policy;

#pragma mark - click event

/**
 * 记录点击事件
 *
 * @param controlName
 * @param args
 */
+ (void)commitClickEvent:(NSString *)controlName
                    args:(NSDictionary *)args;

/**
 * 记录点击事件，可设置上报策略
 *
 * @param controlName
 * @param args
 * @param policy
 */
+ (void)commitClickEvent:(NSString *)controlName
                    args:(NSDictionary *)args
                  policy:(WDUTReportStrategy)policy;

#pragma mark - push

+ (void)pushRegister:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args;

+ (void)pushArrive:(NSString *)arg1
              arg2:(NSString *)arg2
              arg3:(NSString *)arg3
              args:(NSDictionary *)args;

+ (void)pushDisplay:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args;

+ (void)pushOpen:(NSString *)arg1
            arg2:(NSString *)arg2
            arg3:(NSString *)arg3
            args:(NSDictionary *)args;

#pragma mark - 曝光

+ (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args;

+ (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args
            pageName:(NSString *)pageName;

+ (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args
            pageName:(NSString *)pageName
          controller:(UIViewController *)controller;

// =================================================================== //
#pragma mark - deprecated

/**
 * 获取设备Id
 *
 * @deprecated Use getDeviceId instead
 * @return 设备Id
 */
+ (NSString *)getWDUDID __attribute__((deprecated("Use getDeviceId instead.")));

/**
 * 获取一次会话的session值
 *
 * @return 会话的session值
 */
+ (NSString *)getSessionID __attribute__((deprecated("Use getSessionId instead.")));

/**
 * 提交事件日志记录，事件Id需报备申请
 *
 * @param eventId 事件Id
 * @param segmentation
 */
+ (void)commitEvent:(NSString *)eventId segmentation:(NSDictionary *)segmentation __attribute__((deprecated("Use commitEvent:args: instead.")));

+ (void)updateViewController:(id)controller pageName:(NSString *)pageName
                segmentation:(NSDictionary *)segmentation __attribute__((deprecated("Use updateViewController:pageName:args: instead.")));

/**
 * 提交事件日志记录，事件Id需报备申请
 *
 * @param eventId 事件Id
 */
+ (void)commitEvent:(NSString *)eventId __attribute__((deprecated("Use commitEvent:args: instead.")));

+ (NSString *)getDeviceId __attribute__((deprecated("Use getCuid instead.")));

+ (void)commitCtrlClickedEvent:(NSString *)controlName
                  segmentation:(NSDictionary *)segmentation __attribute__((deprecated("Use commitClickEvent instead.")));

+ (void)pushRegisterDeviceToken:(NSString *)arg1
                           arg2:(NSString *)arg2
                           arg3:(NSString *)arg3
                           args:(NSDictionary *)args __attribute__((deprecated("Use pushRegister instead.")));

@end



