//
//  WDJSBridgeApi_WDJSBridge_setClipboardData.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/12.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 复制内容到系统剪贴板
 */
@interface WDJSBridgeApi_WDJSBridge_setClipboardData : WDJSBridgeBaseApi

@property (nonatomic, copy) NSString *data;

@end
