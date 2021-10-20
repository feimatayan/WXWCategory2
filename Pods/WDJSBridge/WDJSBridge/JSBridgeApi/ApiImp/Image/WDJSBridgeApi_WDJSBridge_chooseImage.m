//
//  WDJSBridgeApi_WDJSBridge_chooseImage.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_chooseImage.h"
/**
 选择图片
 */
@implementation WDJSBridgeApi_WDJSBridge_chooseImage

- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback {
    //暂未实现
    callback(WDJSBridgeHandlerResponseCodeFailure, @{kWDJSBridgeErrMsgKey: @"暂未实现，店长版请使用 2.2.7.8 及其以下版本",kWDJSBridgeErrCodeKey:@(WDJSBridgeErrorNotYetRealized)});
}
@end
