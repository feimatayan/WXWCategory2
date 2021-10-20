//
//  WDTNRequestConfigFactory.m
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import "WDTNRequestConfigManager.h"
#import "WDTNRequestConfig.h"
#import "WDTNDataPipeline.h"
#import "WDTNDefines.h"
#import "WDTNCommonConfigBuilder.h"
#import "WDTNProxyConfigBuilder.h"
#import "WDTNUpgradeConfigBuilder.h"
#import "WDTNHTTPConfigBuilder.h"
#import "WDTNThorConfigBuilder.h"
#import "WDTNDataProcessDecompression.h"
#import "WDTNDataProcessDecryption.h"
#import "WDTNDataProcessJSONSerialization.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>


@interface WDTNRequestConfigManager () <WDTNRequestConfigDelegate>
@property (nonatomic, strong) NSMutableDictionary *dict; ///< 缓存config
@end

@implementation WDTNRequestConfigManager

nesingleton_implementation(WDTNRequestConfigManager);

- (instancetype)init {
    if (self = [super init]) {
        _dict = [[NSMutableDictionary alloc] init];
        
        [self createDefaultConfigs];
    }
    return self;
}

- (void)createDefaultConfigs {
    // 因为 response 的处理顺序目前都是先解密后解压，逻辑处理相同，所以放到一块处理。
    WDTNRequestConfig *commonConfig = [[WDTNCommonConfigBuilder new] createConfig];
    commonConfig.responseDelegate = self;
    
    WDTNRequestConfig *proxyConfig = [[WDTNProxyConfigBuilder new] createConfig];
    proxyConfig.responseDelegate = self;
    
    WDTNRequestConfig *upgradeConfig = [[WDTNUpgradeConfigBuilder new] createConfig];
    upgradeConfig.responseDelegate = self;
    
    WDTNRequestConfig *httpConfig = [[WDTNHTTPConfigBuilder new] createConfig];
    httpConfig.responseDelegate = self;
    
    WDTNThorConfigBuilder* builder = [WDTNThorConfigBuilder new];
    WDTNRequestConfig *thorConfig = [builder createConfig];

    builder.configType = WDTNRequestConfigForThorPre;
    WDTNRequestConfig *thorPreConfig = [builder createConfig];

    builder.configType = WDTNRequestConfigForThorTest;
    WDTNRequestConfig *thorTestConfig = [builder createConfig];
    
    _dict[WDTNRequestConfigForCommon] = commonConfig;
    _dict[WDTNRequestConfigForProxy] = proxyConfig;
    _dict[WDTNRequestConfigForUpgrade] = upgradeConfig;
    _dict[WDTNRequestConfigForHTTP] = httpConfig;
    _dict[WDTNRequestConfigForThor] = thorConfig;
    _dict[WDTNRequestConfigForThorPre] = thorPreConfig;
    _dict[WDTNRequestConfigForThorTest] = thorTestConfig;
}

#pragma mark - public method

- (void)setConfig:(WDTNRequestConfig *)config type:(NSString *)type {
    if (type != nil && config != nil) {
        _dict[type] = config;
    }
}

- (WDTNRequestConfig *)configByType:(NSString *)type {
    return _dict[type];
}

#pragma mark - WDTNRequestConfigDelegate

/**
 因为response的回调处理是线性的，所以可以复用responsePipeline的对象。
 */
static WDTNDataPipeline *responsePipeline = nil;
static WDTNDataProcessDecryption *decryption = nil;
static WDTNDataProcessDecompression *decompression = nil;
static WDTNDataProcessJSONSerialization *JSONSerialization = nil;

- (WDTNDataPipeline *)responsePipelineForConfig:(WDTNRequestConfig *)config resEncryStatus:(NSInteger)resEncryStatus resGzipType:(NSInteger)resGzipType {
    if (responsePipeline == nil) {
        responsePipeline = [[WDTNDataPipeline alloc] init];
    }
    
    [responsePipeline removeAllItems];

    // 先解密
    if (resEncryStatus == 1) {
        if (decryption == nil) {
            decryption = [[WDTNDataProcessDecryption alloc] init];
        }
        decryption.passKeyId = config.passKeyId;
        
        [responsePipeline appendItem:decryption];
    }
    // 再解压
    if (resGzipType == 1) {
        if (decompression == nil) {
            decompression = [[WDTNDataProcessDecompression alloc] init];
        }
        
        [responsePipeline appendItem:decompression];
    }
    // json 解析
    if (JSONSerialization == nil) {
        JSONSerialization = [[WDTNDataProcessJSONSerialization alloc] init];
    }
    [responsePipeline appendItem:JSONSerialization];
    
    return responsePipeline;
}

@end



