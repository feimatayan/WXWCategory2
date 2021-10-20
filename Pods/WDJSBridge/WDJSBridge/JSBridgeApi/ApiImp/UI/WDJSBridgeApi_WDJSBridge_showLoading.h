//
//  WDJSBridgeApi_WDJSBridge_showLoading.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 显示加载对话框
 */
@interface WDJSBridgeApi_WDJSBridge_showLoading : WDJSBridgeBaseApi

// 加载提示内容（可选）
@property (nonatomic, copy) NSString *content;

@end
