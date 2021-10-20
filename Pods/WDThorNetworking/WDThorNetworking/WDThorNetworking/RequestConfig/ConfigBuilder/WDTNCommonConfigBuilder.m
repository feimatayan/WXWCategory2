//
//  WDTNCommonConfigBuilder.m
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import "WDTNCommonConfigBuilder.h"
#import "WDTNRequestConfig.h"
#import "WDTNDefines.h"
#import "WDTNDataProcessCompression.h"
#import "WDTNDataProcessEncryption.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJEncryptUtil/GLDataSignKeyContainer.h>


@implementation WDTNCommonConfigBuilder

- (WDTNRequestConfig *)createConfig {
    NSString *commonKeyid = [[GLAESPassphrase sharedManager] defaultAesPassphraseIDForCommon];
    NSString *commonSignId = [GLDataSignKeyContainer sharedManager].defaultSignIDForCommon;
    
    // EncryStatus, 2:加密，0:不加密
    // ZipType, 1:压缩，0:不压缩
    WDTNRequestConfig *commonConfig = [[WDTNRequestConfig alloc] initWithConfigType:WDTNRequestConfigForCommon reqEncryStatus:2 reqZipType:1 passKeyId:commonKeyid signKeyId:commonSignId queuePriority:WDTNQueuePriorityNormal];
//    commonConfig.responseDelegate = self;
    
    // 请求时先压缩后加密
    WDTNDataProcessCompression *compression = [[WDTNDataProcessCompression alloc] init];
    WDTNDataProcessEncryption *commonEncryption = [[WDTNDataProcessEncryption alloc] init];
    commonEncryption.passKeyId = commonKeyid;
    
    WDTNDataPipeline *commonReqPipeline = [[WDTNDataPipeline alloc] init];
    [commonReqPipeline appendItem:compression];
    [commonReqPipeline appendItem:commonEncryption];
    commonConfig.requestPipeline = commonReqPipeline;
    
    return commonConfig;
}

//#pragma mark - WDTNRequestConfigDelegate
//
//- (WDTNDataPipeline *)responsePipelineForConfig:(WDTNRequestConfig *)config resEncryStatus:(NSInteger)resEncryStatus resGzipType:(NSInteger)resGzipType {
//    
//    return nil;
//}

@end
