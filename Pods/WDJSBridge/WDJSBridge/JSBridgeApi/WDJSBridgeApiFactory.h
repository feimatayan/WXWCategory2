//
//  WDJSBridgeApiFactory.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/26.
//  Copyright © 2017年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDJSBridgeBaseApi;

@interface WDJSBridgeApiFactory : NSObject

+ (WDJSBridgeBaseApi *)apiWithModule:(NSString *)module identifier:(NSString *)identifier params:(NSDictionary *)params;

+ (BOOL)apiExistsInModule:(NSString *)module identifier:(NSString *)identifier;

@end
