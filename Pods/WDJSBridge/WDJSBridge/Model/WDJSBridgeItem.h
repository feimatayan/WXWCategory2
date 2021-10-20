//
//  WDJSBridgeItem.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/5.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseItem.h"

@interface WDJSBridgeItem : WDJSBridgeBaseItem


/// 原始请求，解析h5请求时可读
@property (nonatomic, readonly, strong) NSURLRequest *request __deprecated_msg("please use property url");

/// 原始请求，解析h5请求时可读
@property (nonatomic, readonly, strong) NSURL *url;

/// 协议参数，可读
@property (nonatomic, readonly, copy) NSDictionary *bridgeParam;

/// 命名空间，用来区分不同模块
@property (nonatomic, copy) NSString *module;

/// 标识符（API名称）
@property (nonatomic, copy) NSString *identifier;

/// 只包含业务数据的json结构
@property (nonatomic, copy) NSString *param;

/// 被解析后的业务数据
@property (nonatomic, copy) NSDictionary *parsedParam;

/// 会话id（SDK和业务层的上下文标识，业务方只读）
@property (nonatomic, readonly, strong) id contextID;

/// 上下文信息透传
@property (nonatomic, readonly, strong) NSDictionary *contextInfo;

@end
