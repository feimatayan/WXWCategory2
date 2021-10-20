//
//  WDJSBridgeApi_WDJSBridge_showModal.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeBaseApi.h"

/**
显示模态对话框
 */
@interface WDJSBridgeApi_WDJSBridge_showModal : WDJSBridgeBaseApi

// 对话框标题（标题和内容必须有其一）
@property (nonatomic, copy) NSString *title;

// 对话框内容（标题和内容必须有其一）
@property (nonatomic, copy) NSString *content;

// 取消按钮文字（确定和取消必须有其一）
@property (nonatomic, copy) NSString *cancelText;

// 确定按钮文字（确定和取消必须有其一）
@property (nonatomic, copy) NSString *confirmText;

@end
