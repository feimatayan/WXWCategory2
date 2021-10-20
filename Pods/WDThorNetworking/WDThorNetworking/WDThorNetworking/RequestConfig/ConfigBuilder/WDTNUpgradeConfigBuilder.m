//
//  WDTNUpgradeConfigBuilder.m
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import "WDTNUpgradeConfigBuilder.h"
#import "WDTNRequestConfig.h"
#import "WDTNDataProcessCompression.h"
#import "WDTNDataProcessEncryption.h"
#import "WDTNDefines.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJEncryptUtil/GLDataSignKeyContainer.h>


@implementation WDTNUpgradeConfigBuilder

- (WDTNRequestConfig *)createConfig {
    NSString *upgradeKeyid = [[GLAESPassphrase sharedManager] defaultAesPassphraseIDForUpgrade];
    NSString *upgradeSignId = [GLDataSignKeyContainer sharedManager].defaultSignIDForUpgrade;
    
    // EncryStatus, 2:加密，0:不加密
    // ZipType, 1:压缩，0:不压缩
    WDTNRequestConfig *upgradeConfig = [[WDTNRequestConfig alloc] initWithConfigType:WDTNRequestConfigForUpgrade reqEncryStatus:2 reqZipType:0 passKeyId:upgradeKeyid signKeyId:upgradeSignId queuePriority:WDTNQueuePriorityNormal];
    
    // 请求时只加密
    WDTNDataProcessEncryption *upgradeEncryption = [[WDTNDataProcessEncryption alloc] init];
    upgradeEncryption.passKeyId = upgradeKeyid;
    
    WDTNDataPipeline *upgradeReqPipeline = [[WDTNDataPipeline alloc] init];
    [upgradeReqPipeline appendItem:upgradeEncryption];
    upgradeConfig.requestPipeline = upgradeReqPipeline;
    
    return upgradeConfig;
}

@end
