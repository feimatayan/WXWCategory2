//
//  WDJSBridgeStatisticsManager.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/3/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDJSBridgeStatisticsEventList.h"

@protocol WDJSBridgeStatisticsProtocol;
@class WDJSBridgeItem;

@interface WDJSBridgeStatisticsManager : NSObject

@property (nonatomic, weak) id<WDJSBridgeStatisticsProtocol> delegate;

+ (instancetype)sharedManager;

/**
 埋点统计

 @param event 统计事件
 @param param 参数
 */
- (void)logWithEvent:(NSString *)event param:(NSDictionary *)param;

/**
 埋点统计

 @param event 统计事件
 @param item JSBridge解析后的对象
 */
- (void)logWithEvent:(NSString *)event item:(WDJSBridgeItem *)item;

/**
 埋点统计
 
 注意！item会被解析成JSON字符串
 并添加到字典中,对应的key为param，例：
 {param:itemJson}

 @param event 统计事件
 @param param 参数
 @param item JSBridge解析后的对象
 */
- (void)logWithEvent:(NSString *)event param:(NSDictionary *)param item:(WDJSBridgeItem *)item;

@end
