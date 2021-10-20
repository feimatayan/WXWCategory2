//
//  GLIMAutoReplyManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/12/6.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMFoundationDefine.h"

extern NSString * const kGLIMAutoReplychangeKey;
extern NSString * const kGLIMAutoReplyWelcomeKey;
extern NSString * const kGLIMAutoReplyListDataKey;

@class GLIMOrderAutoReplyData;

@interface GLIMAutoReplyManager : NSObject


+ (void)getImSdkSetConfigInfos:(GLIMCompletionBlock)completion;

/**
 请求自动回复信息

 @param completion 回调函数
 */
+ (void)requestAutoReplyInfos:(GLIMCompletionBlock)completion;

/**
 更新自动回复信息

 @param autoReplyArray 自动回复
 @param welcome 欢迎语
 @param completion 回调函数
 */
+ (void)updateAutoReplyInfos:(NSArray *)autoReplyArray
                     welcome:(NSString *)welcome
                  completion:(GLIMCompletionBlock)completion;

/**
 更新自动回复开关

 @param isAutoReplyOn   YES 打开，NO 关闭
 @param completion  回调函数
 */
+ (void)updateAutoReplychange:(BOOL)isAutoReplyOn completion:(GLIMCompletionBlock)completion;

#pragma mark - 下单客户自动回复

/**
 获取所有类型下单客户自动回复信息

 @param completion 回调函数，请求成功返回下单用户自动回复信息数组，请求失败返回nil及相关错误信息
 */
+ (void)requestOrderAutoReplyInfos:(GLIMCompletionBlock)completion;

/**
 为指定类型下单客户设置自动回复信息

 @param replyType 下单客户类型
 @param changeStatus 自动回复开关
 @param contentString 自动回复内容
 @param completion 回调函数，请求失败会返回nil及相关错误信息
 */
+ (void)updateOrderAutoReplyInfosWithType:(NSInteger)replyType
                             changeStatus:(NSInteger)changeStatus
                            contentString:(NSString *)contentString
                               completion:(GLIMCompletionBlock)completion;

#pragma mark - OrderCheck

/// 获取开关状态
/// @param completion 回调函数
+ (void)getOrderCheckEnableStatus:(GLIMCompletionBlock)completion;

/// 设置开关状态
/// @param enable 开关状态，0 关闭 1 开启
/// @param label 开关标签，核对订单开关 "checkOrderSwitch"；商家是否可见开关 "sellerVisibleSwitch"
/// @param completion 回调函数
+ (void)setOrderCheckEnableStatus:(BOOL)enable
                            label:(NSString *)label
                       completion:(GLIMCompletionBlock)completion;

/// 获取订单地址修改权限
/// @param orderId 订单id
/// @param completion 回调函数
+ (void)getOrderAddressModifyPremission:(NSString *)orderId
                             completion:(GLIMCompletionBlock)completion;

@end
