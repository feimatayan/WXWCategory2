//
//  WDJSBridgeStatisticsEventList.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/3/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeStatisticsEventList.h"

#ifndef WDJSBridgeStatisticsEventList_m
#define WDJSBridgeStatisticsEventList_m

NSString * const WDJSBridgeStatistics_jsbridge_call             = @"jsbridge_call";
NSString * const WDJSBridgeStatistics_jsbridge_call_h5          = @"jsbridge_call_h5";
NSString * const WDJSBridgeStatistics_jsbridge_call_plugin      = @"jsbridge_call_plugin";
NSString * const WDJSBridgeStatistics_jsbridge_call_illegal     = @"jsbridge_call_illegal";
NSString * const WDJSBridgeStatistics_jsbridge_handle_native_h5 = @"jsbridge_handle_native_h5";
NSString * const WDJSBridgeStatistics_jsbridge_handle_h5_native = @"jsbridge_handle_h5_native";
NSString * const WDJSBridgeStatistics_jsbridge_h5_native_illegal = @"jsbridge_h5_native_illegal";
NSString * const WDJSBridgeStatistics_jsbridge_h5_native_fail    = @"jsbridge_h5_native_fail";
NSString * const WDJSBridgeStatistics_jsbridge_h5_native_ok      = @"jsbridge_h5_native_ok";
NSString * const WDJSBridgeStatistics_jsbridge_h5_native_callback = @"jsbridge_h5_native_callback";
NSString * const WDJSBridgeStatistics_jsbridge_native_h5_callback = @"jsbridge_call";
NSString * const WDJSBridgeStatistics_jsbridge_native_plugin_callback = @"jsbridge_native_plugin_callback";

NSString * const WDJSBridgeStatistics_jsbridge_invoke_business_plugin = @"jsbridge_invoke_business_plugin";
NSString * const WDJSBridgeStatistics_jsbridge_invoke_inner_plugin = @"jsbridge_invoke_inner_plugin";
NSString * const WDJSBridgeStatistics_jsbridge_invoke_fuzzy_plugin = @"jsbridge_invoke_fuzzy_plugin";
NSString * const WDJSBridgeStatistics_jsbridge_invoke_fail = @"jsbridge_invoke_fail";

NSString * const WDJSBridgeStatistics_jsbridge_callback = @"jsbridge_callback";

NSString * const WDJSBridgeStatistics_jsbridge_business_support = @"jsbridge_business_support";
NSString * const WDJSBridgeStatistics_jsbridge_jsbridge_support = @"jsbridge_jsbridge_support";
NSString * const WDJSBridgeStatistics_jsbridge_both_support = @"jsbridge_both_support";

NSString * const WDJSBridgeStatistics_jsbridge_webview_url_illegal     = @"jsbridge_webview_url_illegal";
#endif /* WDJSBridgeStatisticsEventList_h */
