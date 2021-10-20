//
//  WDJSBridgeApi_WDJSBridge_callSMS.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
 发短信
 */
@interface WDJSBridgeApi_WDJSBridge_callSMS : WDJSBridgeBaseApi

// 收信人号码，多个号码分号分割（可选）
@property (nonatomic, copy) NSString *phoneNumbers;

// 短信内容（可选）
@property (nonatomic, copy) NSString *content;

@end
