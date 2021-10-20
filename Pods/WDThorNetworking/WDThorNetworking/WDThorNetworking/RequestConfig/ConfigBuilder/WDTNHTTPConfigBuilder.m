//
//  WDTNHTTPConfigBuilder.m
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/12.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import "WDTNHTTPConfigBuilder.h"
#import "WDTNRequestConfig.h"
#import "WDTNDefines.h"


@implementation WDTNHTTPConfigBuilder

- (WDTNRequestConfig *)createConfig {

    WDTNRequestConfig *upgradeConfig = [[WDTNRequestConfig alloc] initWithConfigType:WDTNRequestConfigForHTTP reqEncryStatus:0 reqZipType:0 passKeyId:nil signKeyId:nil queuePriority:WDTNQueuePriorityNormal];
    
    // 请求时，什么都不做
//    WDTNDataPipeline *upgradeReqPipeline = [[WDTNDataPipeline alloc] init];
//    upgradeConfig.requestPipeline = upgradeReqPipeline;
    
    return upgradeConfig;
}

@end
