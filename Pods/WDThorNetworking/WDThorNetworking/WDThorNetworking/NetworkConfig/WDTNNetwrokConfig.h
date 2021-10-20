//
//  WDTNNetwrokConfig.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WDTNVarHeaderOnSceneDelegate.h"
#import "WDTNStaticHeaderOnSceneDelegate.h"
#import "WDTNAppConfigDelegate.h"
#import "WDTNPrivateDefines.h"
#import "WDTNAccountDelegate.h"
#import "WDTNThorResponseDelegate.h"


@class WDTNThorSecurityItem;
@class WDTNAccountDO;


typedef enum : NSUInteger {
    PRINT_LOG_NONE = 0,
    PRINT_LOG_TOTAL,
    PRINT_LOG_BRIEF,
} PARAM_LOG_PRINT;


@interface WDTNNetwrokConfig : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) BOOL isDebugModel;

// 是否开启日志打印，默认值 NO.
@property (assign, nonatomic) BOOL isLogOn;

// 是否关闭网络校时，默认值 NO.
@property (assign, nonatomic) BOOL isSystemClockOff WDTNPropertyDeprecated("废弃");


#pragma mark - thor configs

/// thor应用ID，用于设置user-agent, http://confluence.vdian.net/pages/viewpage.action?pageId=13993106
@property (strong, nonatomic) NSString *thorAppCode;

/// 用于配置thor的安全参数，configType做key. 此配置不是线程安全的，请在App初始化时进行配置，不要动态修改已有配置。
@property (readonly, nonatomic) NSMutableDictionary<NSString*, WDTNThorSecurityItem*> *thorSecurityItems;


/**
 默认值 NO,只打印业务参数;
 YES: 打印公共参数和业务参数，格式如下：
 {
    header:{},
    edata:{
        header:{},
        body:{}
    }
 }
 */
@property (nonatomic, assign) PARAM_LOG_PRINT isPrintAllParams;

// 动态参数代理
@property (nonatomic, weak) id<WDTNVarHeaderOnSceneDelegate> varHeaderDelegate;
// 静态参数代理
@property (nonatomic, weak) id<WDTNStaticHeaderOnSceneDelegate> staticHeaderDelegate;
// appConfig代理
@property (nonatomic, weak) id<WDTNAppConfigDelegate> appConfigDelegate;

// 唤起登录的代理, 升级登录SDK会实现，必须实现
// 业务也可以自己实现
@property (nonatomic, weak) id<WDTNAccountDelegate> accountDelegate;

@property (nonatomic, weak) id<WDTNThorResponseDelegate> thorResponseDelegate;

// 账号信息，升级登录SDK会set,
// 可选
@property (nonatomic, strong) WDTNAccountDO *account;

// SDKb内部使用,
// 处理异常情况下，请求时候没有初始化加密信息...
@property (nonatomic, copy) NSString *watchConfigType;
@property (nonatomic, copy) void(^watchCallback)(void);

@end
