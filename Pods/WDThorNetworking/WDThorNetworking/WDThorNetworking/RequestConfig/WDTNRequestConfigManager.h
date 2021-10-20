//
//  WDTNRequestConfigFactory.h
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNPrivateDefines.h"

@class WDTNRequestConfig;


/**
 提供RequestConfig的默认实现，业务方也可以通过该对象扩展type.
 */
@interface WDTNRequestConfigManager : NSObject

nesingleton_interface;

/**
 扩展type, 设置一次即可，ConfigManager会一直持有该config.
 
 @param config 自定义的requestConfig
 @param type   自定义的type
 */
- (void)setConfig:(WDTNRequestConfig *)config type:(NSString *)type;


/**
 每个type仅对应一份实例，所以不要修改返回的RequestConfig，以免影响他人的使用。
 */
- (WDTNRequestConfig *)configByType:(NSString *)type;

@end
