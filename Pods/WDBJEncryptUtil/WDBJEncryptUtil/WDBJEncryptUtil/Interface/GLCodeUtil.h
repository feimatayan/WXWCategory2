//
//  GLCodecProvider.h
//  GLAESGzipProvider
//
//  Created by 赵 一山 on 14/12/29.
//  Copyright (c) 2014年 赵 一山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCharCodecUtil : NSObject


/**
 base64编码

 @param srcData 要编码的数据
 @return 编码后的字符串
 */
+ (NSString*)base64Encoding:(NSData*)srcData;

/**
 base64解码

 @param srcString 要解码的字符串
 @return 解码后的数据
 */
+ (NSData*)base64Decoding:(NSString*)srcString;


/**
 md5加密

 @param str 要加密的md5字符串
 @return 加密后的字符串
 */
+ (NSString*)md5:(NSString*)str;

/**
 md5对字符数组加密

 @param bytes 要加密的字符数组
 @param length 字符数组长度
 @return 加密后的字符串
 */
+ (NSString *)md5WithBytes:(char *)bytes length:(NSUInteger)length;

/**
 md5对data加密

 @param data 要加密的数据
 @return 加密后的数据
 */
+ (NSData*)md5Data:(NSData*)data;
/**
 md5对data加密
 
 @param data 要加密的数据
 @return 加密后的字符串
 */
+ (NSString*)md5WithData:(NSData*)data;

/**
 买家数据加密

 @param srcString 要加密的字符串
 @return 加密后的字符串
 */
+ (NSString*)encodePasswordForBuyer:(NSString*)srcString;

/**
 卖家数据加密
 
 @param srcString 要加密的字符串
 @return 加密后的字符串
 */
+ (NSString*)encodePasswordForSeller:(NSString*)srcString;


@end
