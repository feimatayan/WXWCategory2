//
//  WDJSBridgeMacros.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#ifndef WDJSBridgeMacros_h
#define WDJSBridgeMacros_h

#define kWDBridgeProtocolJSObject @"KDJSBridge2"

#define kWDBridgeProtocolMethodCall  [kWDBridgeProtocolJSObject stringByAppendingString:@".FN_handleRequest"]

#define kWDBridgeProtocolMethodCallBack [kWDBridgeProtocolJSObject stringByAppendingString:@".onComplete"]

#define kWDJSBridgeAPIPrefix @"WDJSBridgeApi"

#define WDJSBridge_SDK_Version          @"2.0.2"
#define WDJSBridge_Protocol_Version     @"1.0.0"


#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

#endif /* WDJSBridgeMacros_h */
