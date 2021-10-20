//
//  WDTNThorProtocolImp.h
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/27.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNRequestConfig.h"


/**
 实现Thor相关协议细节
 */
@interface WDTNThorProtocolImp : NSObject

/**
 提供thor规范的UA
 
 参考:
 http://confluence.vdian.net/pages/viewpage.action?pageId=13993106
 
 @return UA
 */
+ (NSString*)thorUserAgent;

/**
 使用thor的签名方式，对参数签名，并组装payload

 参考:
 http://confluence.vdian.net/pages/viewpage.action?pageId=13993116
 http://confluence.vdian.net/pages/viewpage.action?pageId=13993114

 @param context 通用统计参数
 @param jsonParam 业务参数,一般应该是json对象
 @param config 请求的配置
 @return thor签名之后的payload, 包含v和timestampt等字段，可直接用于http body
 */
+ (NSString*)thorPayloadWithContext:(NSDictionary*)context
                              param:(id)jsonParam
                          forConfig:(WDTNRequestConfig*)config;

/**
 对指定参数字典进行thor协议加密处理
 input json string -> utf8 data -> gzip data -> aes data -> base64 string output
 
 @param jsonStr 要加密的json字符串
 @return 加密完成后的base64字符串
 */
+ (NSString*)thorEncrypt:(NSString*)jsonStr withAESKey:(NSString*)aesKey;

/**
 对数据进行thor协议的解密和验证
 input base64 string -> aes data -> gzip data -> origin data -> crc32 check
 
 @param data    要解密的数据
 @param options 是否加密，是否压缩，crc32等
 @return 解密后数据
 */
+ (NSData*)thorDecrypt:(NSData*)data
            withAESKey:(NSString*)aesKey
            andOptions:(NSDictionary*)options;

@end
