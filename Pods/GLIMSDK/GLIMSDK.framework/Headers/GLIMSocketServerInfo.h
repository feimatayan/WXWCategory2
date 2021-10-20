//
//  GLIMSocketServerInfo.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/20.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMSocketServerInfo : NSObject

@property (nonatomic, strong) NSString *host;           // ip地址或域名
@property (nonatomic, assign) NSInteger port;           // 端口号
@property (nonatomic, strong) NSString *url;            // 域名（h5使用）
@property (nonatomic, assign) NSInteger weight;         // 权重
@property (nonatomic, assign) NSInteger attempts;       // 尝试次数
@property (nonatomic, assign) NSInteger maxAttempts;    // 最大尝试次数
@property (nonatomic, assign) BOOL isPerference;        // 是否支持保存为优先地址，默认是YES

/// 普通地址信息
+ (instancetype)serverInfoWithDictionary:(NSDictionary *)dictionary;
/// 保底域名信息
+ (instancetype)safeServerInfoWithDictionary:(NSDictionary *)dictionary;
/// 预上线地址信息
+ (instancetype)preLineServerInfo;
/// 测试环境地址信息
+ (instancetype)testServerInfo;
/// 加速地址信息
+ (instancetype)fastServerInfo;

- (NSDictionary *)toDictionary;

- (BOOL)canConnected;

- (BOOL)isEqualOther:(GLIMSocketServerInfo *)other;

/// 服务器地址信息
- (NSString *)addressInfo;

/// 描述信息
- (NSString *)serverInfos;

@end
