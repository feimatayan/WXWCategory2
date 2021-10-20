//
//  WDTNThorConfigBuilder.m
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/27.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import "WDTNThorConfigBuilder.h"
#import "WDTNDefines.h"
#import "WDTNRequestConfig.h"
#import "WDTNRequestConfigBuilderProtocol.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJEncryptUtil/GLDataSignKeyContainer.h>


@interface WDTNThorConfigBuilder () <WDTNRequestConfigBuilderProtocol>

@end

@implementation WDTNThorConfigBuilder

- (id)init {
    if (self = [super init]) {
        self.configType = WDTNRequestConfigForThor;
    }
    
    return self;
}

- (WDTNRequestConfig *)createConfig {
    // EncryStatus, 1:加密，0:不加密
    // ZipType, thor不支持单独配置压缩，加密则请求必压缩，否则不压缩
    // AESKeyID, thor的密钥随版本变化，直接由业务参数表传递，不在config中配置
    // SignedKeyID, thor的签名盐随版本变化，直接由业务参数表传递，不在config中配置
    WDTNRequestConfig *thorConfig = [[WDTNRequestConfig alloc] initWithConfigType:self.configType
                                                                   reqEncryStatus:YES
                                                                       reqZipType:YES
                                                                        passKeyId:@""
                                                                        signKeyId:@""
                                                                    queuePriority:WDTNQueuePriorityNormal];
    thorConfig.useThorProtocol = YES;
    
    // thor的协议需要对context及paraml两块分别进行加密处理，不同于其他请求的针对http body整块数据处理
    // 所以直接在WDTNThorParameterProcessor进行打包，不使用之前的处理管道模式
    thorConfig.requestPipeline = nil;
    
    return thorConfig;
}

@end
