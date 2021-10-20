//
//  WDJSBridgeApi_WDJSBridge_request.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 普通网络请求接口
 */
@interface WDJSBridgeApi_WDJSBridge_request : WDJSBridgeBaseApi

// 服务器接口地址(必填)
@property (nonatomic, copy) NSString *url;

// 仅支持"GET"和"POST"（可选，默认GET）
@property (nonatomic, copy) NSString *method;

// 请求的参数（可选）
@property (nonatomic, copy) NSDictionary *param;

// 可选
@property (nonatomic, copy) NSDictionary *header;

@end
