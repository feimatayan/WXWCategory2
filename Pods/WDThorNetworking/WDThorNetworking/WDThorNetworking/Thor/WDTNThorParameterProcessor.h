//
//  WDTNThorParameterProcessor.h
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/27.
//  Copyright © 2017年 Weidian. All rights reserved.
//


#import "WDTNParameterProcessor.h"


/**
 被网络库请求流程调用，提供Thor请求的HTTP header和body
 */
@interface WDTNThorParameterProcessor : WDTNParameterProcessor

/**
 根据RequestConfig, 按照Thor协议，设置header中key的value
 */
+ (NSDictionary *)HTTPHeaderFields:(WDTNRequestConfig *)config;

/**
 按照Thor定义的格式对http请求组包. 
 context	公共信息，如果压缩加密，需要进行base64编码
 jsonParam  业务参数，如果压缩加密，需要进行base64编码
 appkey     字符串形式
 v          平台版本，用于区分新老vap接口
 sign       签名，防止数据被篡改
 timestamp	请求的时间戳
 
 详细文档:
 http://confluence.vdian.net/pages/viewpage.action?pageId=13993112
 http://confluence.vdian.net/pages/viewpage.action?pageId=13993116
 http://confluence.vdian.net/pages/viewpage.action?pageId=13993114
 */
+ (NSData *)HTTPBody:(id)jsonParam task:(WDTNPerformTask *)task error:(NSError **)error;

+ (NSDictionary *)requestThorBodyWithParse:(NSURLRequest*)request;
@end
