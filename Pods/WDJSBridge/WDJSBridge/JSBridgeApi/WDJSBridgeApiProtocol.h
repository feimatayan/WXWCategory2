//
//  WDJSBridgeApiProtocol.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/29.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDNJSBridge.h"

@protocol WDJSBridgeApiProtocol <NSObject>

- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback;

@end
