//
//  WDTNThorConfigBuilder.h
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/27.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNRequestConfigBuilderProtocol.h"


/**
 被网络库请求流程调用，用于创建Thor请求的配置项
 */
@interface WDTNThorConfigBuilder : NSObject <WDTNRequestConfigBuilderProtocol>

@property (nonatomic, assign) NSString* configType;

@end
