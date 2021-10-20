//
//  GLIMFoundationDefine.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/17.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMFoundationDefine_h
#define GLIMFoundationDefine_h

#pragma mark - Block
typedef void(^GLIMCompletionBlock)(id responeObject, NSError *error);

#pragma mark - Macro for Methods
#define GLIM_WEAK(_instance_)       __weak typeof(_instance_) weak_##_instance_ = _instance_;
#define GLIM_STRONG(_instance_)     __strong typeof(_instance_) strong_##_instance_ = _instance_;

#pragma mark - Macro for Log
#ifdef DEBUG
#define GLIMLogDef        // IM 日志开关
//#define GLIMDEBUG             // IM debug环境
#else
#endif
#ifdef GLIMLogDef
#define GLIMLog(...)        NSLog(__VA_ARGS__)
#define GPCLog(fmt, ...)    NSLog((@"\nGPCLog*******:%@ %s" fmt), NSStringFromClass([self class]), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define GLIMLog(...)
#define GPCLog(fmt, ...)
#endif

#pragma mark - Protocol

#pragma mark - Lock
#define GLIMLOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define GLIMUNLOCK(lock) dispatch_semaphore_signal(lock);

#pragma mark - Notifications
/**
 *  清空视频缓存通知
 *  数据格式：[{@"videoUrl":@"xxxx", @"pathDirectory":@(13)},{@"videoUrl":@"xxxx", @"":@(13)}]
 **/
#define GLIMNOTIFICATION_VIDEO_CLEAR_CACHE  @"GLIMNOTIFICATION_VIDEO_CLEAR_CACHE"

/**
 统计登录日志接口
 */
@protocol GLIMStatisticalDelegate <NSObject>

@optional
#pragma mark - 登录性能统计
- (void)logSDKInitStart;
- (void)logLoadIPListFromServer;
- (void)logLoadIPListSuccessFromServer;
- (void)logLoadIPListFailedFromServer;
- (void)logLoadIPListFromCache;
- (void)logBeginConnectAction;
- (void)logConnectSucceed;
- (void)logConnectFailed:(NSDictionary *)errorInfos;
- (void)logHandshakeSucceed;
- (void)logHandshakeFailed:(NSDictionary *)errorInfos;
- (void)logImLoginStart;
- (void)logImLoginSucceed;
- (void)logImLoginFailed:(NSDictionary *)errorInfos;
- (void)logImLoadRecentChatsStart;
- (void)logImLoadRecentChatsSucceed;
- (void)logImLoadRecentChatsFailed;
- (void)logSDKInitEnd;

#pragma mark - 自定义统计
/// 记录拉取服务器配置信息
- (void)logLoadServerConfInfo:(NSDictionary *)infos;

@end

#endif /* GLIMFoundationDefine_h */
