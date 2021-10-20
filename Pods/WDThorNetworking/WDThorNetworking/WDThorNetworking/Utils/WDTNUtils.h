//
//  WDTNUtils.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/9.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDTNUtils : NSObject


/**
 将nil转换为空字符串

 @param str 输入字符串
 @return 非nil字符串
 */
+ (NSString*)safeString:(NSString*)str;

/**
 安全解析数组，防止crash

 @param dict 源字典
 @param key  key
 @return 结果
 */
+ (id)safeObjectFromDict:(NSDictionary*)dict forKey:(NSString*)key;

/**
 *  NSString 或 NSData 解析为 NSDictionary 或 NSArray
 *
 *  @param jsonstr 需要解析的字符串(NSString)或者数据(NSData)
 *
 *  @return 返回json对象
 */
+ (id)jsonParse:(id)jsonstr;

/**
 *  NSDictionary 或 NSArray 转换为 NSString
 *
 *  @param object NSDictionary 或 NSArray
 */
+ (NSString *)stringFromJSONObject:(id)object;


/**
 按照原有 BI 模板，如：
 1. ORGANIZATION;;0503025-社区-帖子详情页-评论-评论数
 2. weex;;wx_render
 来上报技术埋点
 
 @param eventId 按照 BI 格式拼装后的事件
 @param paramsDic 技术埋点参数
 */
+ (void)logTechEvent:(NSString *)eventId paramsDic:(NSDictionary *)paramsDic;


/**
 按照模块和事件拆分方式来上报技术埋点
 
 @param eventName 需要统计的事件名
 @param moduleName 事件来源模块名
 @param paramsDic 技术埋点参数
 */
+ (void)logTechEvent:(NSString *)eventName
          fromModule:(NSString *)moduleName
          withParams:(NSDictionary *)paramsDic;

@end
