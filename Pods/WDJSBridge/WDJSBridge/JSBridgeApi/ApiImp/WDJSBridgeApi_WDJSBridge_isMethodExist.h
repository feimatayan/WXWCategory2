//
//  WDJSBridgeApi_WDJSBridge_isMethodExist.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/15.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
调用的功能是否存在，此功能不能被外部注册的同名插件替换
 */
@interface WDJSBridgeApi_WDJSBridge_isMethodExist : WDJSBridgeBaseApi

// 业务标识 (必须）
@property (nonatomic, copy) NSString *module;

// 功能标识（必须）
@property (nonatomic, copy) NSString *identifier;

// 功能标识（兼容字段，逐步废弃，由identifier替代）
@property (nonatomic, copy) NSString *method;

@end
