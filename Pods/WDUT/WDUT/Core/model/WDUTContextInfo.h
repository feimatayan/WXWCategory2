//
//  WDUTContextInfo.h
//  WDUT
//
//  Created by WeiDian on 15/12/25.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface WDUTContextInfo : NSObject

// duid
@property (atomic, copy) NSString *userId;

// userId
@property (atomic, copy) NSString *formatUserId;

@property (atomic, copy) NSString *phoneNumber;

@property (atomic, copy) NSString *shopId;

@property (atomic, copy) NSString *currentNetworkString;

@property (atomic, copy) NSString *currentCarrierString;

@property (atomic, copy) NSString *currentIpString;

@property (atomic, copy) NSString *rooted;

/*
 * 缓存网络状态
 * */
@property (atomic, assign) NetworkStatus currentNetworkStatus;

/**
 * 设置当前HotPatch的版本号
 * !! 重新review下，是否保留
 */
@property(atomic, copy) NSString *patchVersion;

/**
 * 设置自定义渠道号
 * 默认是AppStore渠道号("appstore")
 */
@property(atomic, copy) NSString *channel;

@property (nonatomic, strong) NSMutableDictionary *steadyContextInfo;

@property (atomic, copy) NSString *cuid;

/**
 * 获取微店平台的设备唯一标识
 *
 * @return 微店平台的设备唯一标识
 */
+ (NSString *)suid;

#pragma mark - device information

/**
 * 获取当前设备是否是越狱设备
 *
 * @return 当前设备的越狱状态
 */
+ (BOOL)isJailbroken;

#pragma mark -前后台监听
+ (void)onWillEnterForegroundNotification:(NSNotification *)notification;

+ (NSMutableDictionary *)getContextInfo;

+ (WDUTContextInfo *)instance;

//有patch 会带上了patch version
+ (NSString *)appVersion;

@end
