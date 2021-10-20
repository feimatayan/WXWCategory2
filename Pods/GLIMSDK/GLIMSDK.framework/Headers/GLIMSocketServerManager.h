//
//  GLIMSocketServerManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/20.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMSocketServerInfo.h"
#import "GLIMFoundationDefine.h"

typedef void (^GLIMSocketServerLoadCompletion)(NSError  *error);

/// TCP服务器管理
@interface GLIMSocketServerManager : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) GLIMSocketServerLoadCompletion completion;
@property (nonatomic, weak) id<GLIMStatisticalDelegate> logDelegate;

/// 强制拉取服务器信息
@property (nonatomic, assign) BOOL forceRequestServers;

+ (instancetype)sharedManager;

- (void)loadServerDataWithCompletion:(GLIMSocketServerLoadCompletion)completion;

- (NSArray *)allServerInfoArray;

/// 当前使用的IP地址
- (GLIMSocketServerInfo *)currentServerInfo;

/**
 *  @author huangbiao, 17-02-21 11:08:02
 *
 *  保存优先IP地址
 *
 *  @param serverInfo 连接成功的IP地址
 */
- (void)savePerferenceServer:(GLIMSocketServerInfo *)serverInfo;

@end
