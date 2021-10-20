//
//  WDJSBridgeStatisticsProtocol.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/3/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WDJSBridgeStatisticsProtocol <NSObject>

@optional

/**
 埋点统计

 @param param 参数
 */
- (void)logEventWithParam:(NSDictionary *)param;

@end
