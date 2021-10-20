//
//  WDTNPrivateDefines.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/10.
//  Copyright © 2016年 weidian. All rights reserved.
//

#ifndef WDTNPrivateDefines_h
#define WDTNPrivateDefines_h

#pragma mark - 日志打印
#import "WDTNLog.h"

#pragma mark - 校时 接口地址

static NSString *const BaseServerOnline = @"https://apis.weidian.com/router.do?rmethod=";
static NSString *const BaseServerDebug  = @"https://wdtestapi.weidian.com/vdianproxy/router.do?rmethod=";

static NSString *const BaseThorServerOnline = @"https://thor.weidian.com/";
static NSString *const BaseThorServerDebug = @"https://thor.daily.weidian.com/";

#pragma mark - 单例的宏定义

// .h
#define nesingleton_interface +(instancetype) sharedInstance;
// .m
#define nesingleton_implementation(class)   \
                                            \
+(instancetype) sharedInstance {            \
static class *_instance;                     \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
    _instance = [[class alloc] init];       \
});                                         \
return _instance;                           \
}                                           \

#pragma mark - weakify and strongify

#ifndef neweakify

#define neweakify(var)      __weak typeof(var) NEWeak_##var = var;
#define nestrongify(var)    __strong typeof(NEWeak_##var) NEStrong_##var = NEWeak_##var;
#endif

static NSString *const WDTNStatisticAPPKey = @"WDTNNetworkExtensionStatisticAPPKey";


#define WDTNPropertyDeprecated(instead)  NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
#define WDTNMethodDeprecated(instead)    __attribute__((deprecated(instead)))


#endif /* WDTNPrivateDefines_h */
