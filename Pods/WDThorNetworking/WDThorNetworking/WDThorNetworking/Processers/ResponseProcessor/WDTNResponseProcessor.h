//
//  WDTNResponseProcessor.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDTNRequestConfig;
@interface WDTNResponseProcessor : NSObject


/**
 解析 response 返回的 nsdata

 @param error 解析中遇到的错误，错误有：1. result == nil,json解析错误；2. 没有status_code(或 code) 或status_code != 0， proxy server错误.

 @return 解析后的NSDictionary
 */
+ (NSDictionary *)parseForResponse:(NSHTTPURLResponse *)response data:(NSData *)data config:(WDTNRequestConfig *)config error:(NSError **)error;


/**
 检查返回的 json 格式是否正确，正确的数据格式：
 {
    "status":{
        "status_code":"0",
        "status_reason":"XXX",
    },
    "result":XXX
 }

 @return 如果格式有问题，返回 error,没有问题，返回 nil.
 */
//+ (NSError *)checkJsonFormat:(NSDictionary *)result;
@end
