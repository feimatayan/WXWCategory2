//
//  WDJSBridgeConfig.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 配置文件
 */
@interface WDJSBridgeConfig : NSObject

/// 当前scheme，默认kdbridge
@property (nonatomic, copy) NSString *bridgeScheme;

/// 是否输出日志
@property (nonatomic) BOOL showLog;


+ (instancetype)sharedConfig;

@end
