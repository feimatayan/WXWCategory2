//
//  WDTNRequestConfigBuilderProtocol.h
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#ifndef WDTNRequestConfigBuilderProtocol_h
#define WDTNRequestConfigBuilderProtocol_h

#import "WDTNRequestConfig.h"


/**
 添加自定义的config时需要实现改协议。
 创建config时如果指定了responseDelegate, 需要实现responsePipelineForConfig:resEncryStatus:resGzipType:
 */
@protocol WDTNRequestConfigBuilderProtocol <WDTNRequestConfigDelegate>

/**
 创建config
 
 @return 与type对应的RequestConfig实例
 */
- (WDTNRequestConfig *)createConfig;

@end

#endif /* WDTNRequestConfigBuilderProtocol_h */
