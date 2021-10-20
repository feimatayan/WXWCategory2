//
//  WDJSBridgeApi_WDJSBridge_showToast.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 显示Toast提示
 */
@interface WDJSBridgeApi_WDJSBridge_showToast : WDJSBridgeBaseApi

// 提示内容
@property (nonatomic, copy) NSString *content;

// 持续时间长短（可选，小于等于0短暂，大于0较长）
@property (nonatomic, copy) NSString *duration;

@end
