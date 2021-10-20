//
//  WDTNThorAES.h
//  WDThorNetworking
//
//  Created by zephyrhan on 2017/9/29.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 服务端和Android均适用mbedtls中抠出来的AES做加解密，iOS系统AES的使用PKCS7|ECB也能兼容，
 但是为防万一, 和以后的变化，这里还是使用mbedtle的代码
 */
@interface WDTNThorAES : NSObject

/**
 AES加密

 @param inputData 输入待加密数据
 @param aesKey 秘钥字符串(hex string)
 @return 加密后的数据
 */
+ (NSData*)thorAESEncrypt:(NSData*)inputData withAESKey:(NSString*)aesKey;

/**
 AES解密

 @param inputData 输入待解密数据
 @param aesKey 秘钥字符串(hex string)
 @return 解密后的数据
 */
+ (NSData*)thorAESDecrypt:(NSData*)inputData withAESKey:(NSString*)aesKey;

@end
