//
//  WDJSBridgeInterface.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDBridgeProtocolConfig;
@protocol WDJSBridgeStatisticsProtocol;

@interface WDJSBridgeInterface : NSObject

/**
 根据参数生成符合协议的URL

 @param module 协议module
 @param identifier 协议
 @param params 参数
 @param config 如果为nil 则使用默认配置
 @return 符合协议的URL
 */
+ (NSURL *)generateBridgeURLWithModule:(NSString *)module identifier:(NSString *)identifier params:(NSDictionary *)params config:(WDBridgeProtocolConfig *)config;

/**
 判断是否为合法的协议URL
 @param config 如果为nil 则使用默认配置
 @return YES符合JSBridge协议 NO不符合JSBridge协议
 */
+ (BOOL)isValidProtocolURL:(NSURL *)url config:(WDBridgeProtocolConfig *)config;

/**
 获取jsbridge协议的UA字段，形如KDJSBridge2/1.0.0
 
 @return jsbridge协议的UA字段
 */
+ (NSString *)userAgentField;

/**
 当前协议版本号
 
 @return 当前协议版本号
 */
+ (NSString *)protocolVersion;


/**
 当前SDK的版本号
 
 @return 当前SDK的版本号
 */
+ (NSString *)sdkVersion;

/**
控制台日志输出开关s
 */
+ (void)enableLog:(BOOL)enable;

/**
 设置埋点统计的代理
 
 @param delegate 统计代理
 */
+ (void)setStatisticsDelegate:(id<WDJSBridgeStatisticsProtocol>)delegate;


@end
