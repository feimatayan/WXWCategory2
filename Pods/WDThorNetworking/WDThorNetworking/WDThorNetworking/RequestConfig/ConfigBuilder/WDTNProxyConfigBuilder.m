//
//  WDTNProxyConfigBuilder.m
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import "WDTNProxyConfigBuilder.h"
#import "WDTNRequestConfig.h"
#import "WDTNDataProcessCompression.h"
#import "WDTNDataProcessEncryption.h"
#import "WDTNDefines.h"

#import <WDBJEncryptUtil/GLAESPassphrase.h>
#import <WDBJEncryptUtil/GLDataSignKeyContainer.h>
#import <WDBJEncryptUtil/WDBJEncryptUtil.h>


@implementation WDTNProxyConfigBuilder

- (WDTNRequestConfig *)createConfig {
    NSString *proxyKeyid = [[GLAESPassphrase sharedManager] defaultAesPassphraseIDForProxy];
    NSString *proxySignId = [GLDataSignKeyContainer sharedManager].defaultSignIDForProxy;
    
    // EncryStatus, 2:加密，0:不加密
    // ZipType, 1:压缩，0:不压缩
    WDTNRequestConfig *proxyConfig = [[WDTNRequestConfig alloc] initWithConfigType:WDTNRequestConfigForProxy reqEncryStatus:2 reqZipType:1 passKeyId:proxyKeyid signKeyId:proxySignId queuePriority:WDTNQueuePriorityNormal];
    
    // 请求时先压缩后加密
    WDTNDataProcessCompression *compression = [[WDTNDataProcessCompression alloc] init];
    WDTNDataProcessEncryption *proxyEncryption = [[WDTNDataProcessEncryption alloc] init];
    proxyEncryption.passKeyId = proxyKeyid;
    
    WDTNDataPipeline *proxyReqPipeline = [[WDTNDataPipeline alloc] init];
    [proxyReqPipeline appendItem:compression];
    [proxyReqPipeline appendItem:proxyEncryption];
    proxyConfig.requestPipeline = proxyReqPipeline;
    
    return proxyConfig;
}

@end
