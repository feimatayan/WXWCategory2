//
//  GLIMSDKExtensionUtils.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/9/11.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 微店Token失效
extern NSString * const kGLIMSDKExtensionNotificationTokenInvalid;
/// 账号权限失效
extern NSString * const kGLIMSDKExtensionNotificationAuthorityInvalid;

/**
 扩展业务处理
 */
@interface GLIMSDKExtensionUtils : NSObject

/**
 根据返回码判断微店的Token是否失效

 @param resultDict HTTP请求返回码
 @return YES Or NO
 */
+ (BOOL)isUserTokenValid:(NSDictionary *)resultDict;

/**
 发送Token失效通知

 @param resultDict Token失效错误信息
 */
+ (void)postUserTokenInvalidNotification:(NSDictionary *)resultDict;

/**
 根据返回码判断是否未授权

 @param resultDict HTTP请求返回码
 @return 未授权则返回错误信息，否则返回nil
 */
+ (NSError *)authorityErrorWithDictionary:(NSDictionary *)resultDict;

@end
