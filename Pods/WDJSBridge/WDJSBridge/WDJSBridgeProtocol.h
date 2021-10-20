//
//  WDJSBridgeProtocol.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDNJSBridge, WDJSBridgeItem;

@protocol WDJSBridgeProtocol <NSObject>

@optional

/**
 JSBridge将要加载本次JSBridge协议的请求
 询问业务方是否允许加载本次JSBridge的请求
 如果未实现该方法 则默认为允许
 
 @param jsbridge 当前的jsbridge
 @param item 部分解析后的数据,仅有module、identifier和url有值
 @return YES:是 NO:否
 */
- (BOOL)jsbridge:(WDNJSBridge *)jsbridge shouldSupportForItem:(WDJSBridgeItem *)item;

@end
