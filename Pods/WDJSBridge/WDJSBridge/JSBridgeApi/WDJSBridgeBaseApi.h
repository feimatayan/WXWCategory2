//
//  WDJSBridgeBaseApi.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/22.
//  Copyright © 2017年 WangYiqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDNJSBridge.h"
#import "WDJSBridgeApiProtocol.h"

@protocol WDWebViewProtocol;

@interface WDJSBridgeBaseApi : NSObject <WDJSBridgeApiProtocol>

// 原始参数
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *params;
@property (nonatomic, weak) WDNJSBridge *jsbridge;
 
@end
