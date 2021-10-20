//
//  WDTNThorResponseProcessor.h
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/28.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import "WDTNResponseProcessor.h"

/**
 被网络库请求流程调用，提供Thor请求的HTTP返回解析
 */
@interface WDTNThorResponseProcessor : WDTNResponseProcessor

/**
 按照Thor协议格式，解析返回值
 
 @param error 解析中遇到的错误
 
 @return 解析后的NSDictionary
 */
+ (NSDictionary *)parseForResponse:(NSHTTPURLResponse *)response data:(NSData *)data config:(WDTNRequestConfig *)config error:(NSError **)error;

@end
