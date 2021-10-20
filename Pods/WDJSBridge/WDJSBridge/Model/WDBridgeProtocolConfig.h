//
//  WDBridgeProtocolConfig.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/5.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDBridgeProtocolConfig : NSObject

/// 协议scheme,default 'kdbridge'
@property (nonatomic, copy) NSString *scheme;

/// 是否读取callback所为回调方法,default no
@property (nonatomic) BOOL useCustomCallbackMethod;

/// 是否需要关心协议返回值，默认YES
@property (nonatomic) BOOL needProtocolBridgeParam;

@end
