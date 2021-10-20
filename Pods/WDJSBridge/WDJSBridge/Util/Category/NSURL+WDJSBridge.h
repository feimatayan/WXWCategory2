//
//  NSURL+WDJSBridge.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (WDJSBridge)

/**
 *  @author Acorld, 16-05-16
 *
 *  @brief 将url的参数解析成键值对
 *
 *  @return NSDictionary
 */
- (NSDictionary *)jsbridge_queryPairs;

@end
