//
//  WDTNRequestProcessor.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDTNPerformTask;
@interface WDTNRequestProcessor : NSObject

/**
 拼接url和参数，然后md5之后作为requestId
 */
+ (NSString *)requestIdForURL:(NSString *)urlStr params:(id)jsonParam;

/**
 根据RequestConfig,拼装proxy协议定义的参数，生成request.
 */
+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      task:(WDTNPerformTask *)task
                                     error:(NSError **)error;

@end
