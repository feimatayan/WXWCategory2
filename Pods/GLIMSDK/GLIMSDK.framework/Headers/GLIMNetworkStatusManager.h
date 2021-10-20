//
//  GLIMNetworkStatusManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/10/10.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络状态管理
 对AFNetworkReachabilityManager的封装
 */
@interface GLIMNetworkStatusManager : NSObject

/// 网络可达回调，暂时不开放具体网络状态
@property (nonatomic, strong) dispatch_block_t reachableCallback;
/// 网络不可达回调
@property (nonatomic, strong) dispatch_block_t notReachableCallback;
/// 标识网络是否可达
@property (nonatomic, assign, readonly) BOOL reachable;

@property (nonatomic, assign, readonly) BOOL isWifiStatus;

+ (instancetype)sharedInstance;

/// 开启网络监控
- (void)startNetworkMonitor;

#pragma mark - 对网络状态组件的封装
/// YES 当前网络不可达，用于HTTP请求
+ (BOOL)realReachabilityNotReachable;
/// 获取当前网络的使用情况
+ (NSString *)realReachabilityCurrentNetworkStatus;

@end
