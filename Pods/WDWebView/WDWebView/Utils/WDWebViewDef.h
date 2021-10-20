//
// Created by 石恒智 on 2018/1/2.
// Copyright (c) 2018 无线生活（杭州）信息科技有限公司. All rights reserved.
//

#ifndef WDWebViewDef_H
#define WDWebViewDef_H

///DEBUG模式下打印日志
#ifdef DEBUG
#define WDWebView_LOG_ENABLED
#endif

///是否在控制台打印日志
#ifdef WDWebView_LOG_ENABLED
#define WDWebViewLog(fmt, ...) NSLog((@"WDWebViewLog:%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define WDWebViewLog(...)
#endif  /*WDASM_LOG_ENABLED*/

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

#ifndef dispatch_main_sync_safe
#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }
#endif
#endif
