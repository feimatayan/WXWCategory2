//
//  WDTNThorProtocolImp.m
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/27.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import "WDTNThorProtocolImp.h"
#import "WDTNLog.h"
#import "WDTNDefines.h"
#import "WDTNServerClockProofreader.h"
#import "WDTNNetwrokConfig.h"
#import "WDTNThorSecurityItem.h"
#import "WDTNThorSecurityItem.h"
#import "WDTNUtils.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJDeviceInfo/WDBJDeviceInfo.h>
#import "CommonCrypto/CommonDigest.h"
#import "WDTNThorAES.h"
#import "WDTNThorGZip.h"
#include <zlib.h>


@implementation WDTNThorProtocolImp

static NSString* _thorUA = nil;

/**
 提供thor规范的UA
 
 @return UA
 */
+ (NSString*)thorUserAgent {
    if (_thorUA == nil) {
        _thorUA = [NSString stringWithFormat:@"iOS/%@ WDAPP(%@/%@) Thor/%@",
                   [[UIDevice currentDevice] systemVersion], [WDTNNetwrokConfig sharedInstance].thorAppCode,
                   [GLDeviceInfo appVersion], WDTHOR_SDK_VERSION];
    }
    
    return _thorUA;
}

+ (NSString*)thorPayloadWithContext:(NSDictionary*)context
                              param:(id)jsonParam
                          forConfig:(WDTNRequestConfig *)config
{
    WDTNThorSecurityItem *item = [WDTNNetwrokConfig sharedInstance].thorSecurityItems[config.configType];
    if (item == nil) {
        return nil;
    }
    
    // context
    NSString *contextIM = [WDTNUtils stringFromJSONObject:context];
    if (config.reqEncryStatus != 0) { // 需要加密context
        contextIM = [WDTNThorProtocolImp thorEncrypt:contextIM withAESKey:item.thorAesKey];
        
        if (contextIM == nil) {
            return nil;
        }
    }

    // param
    // thor 后端需要保证params非空，因此当没有参数时，param上传空字典
    NSString *paramIM = (jsonParam == nil) ? @"{}" : [WDTNUtils stringFromJSONObject:jsonParam];
    if (config.reqEncryStatus != 0) { // 需要加密param
        paramIM = [WDTNThorProtocolImp thorEncrypt:paramIM withAESKey:item.thorAesKey];
        
        if (paramIM == nil) {
            return nil;
        }
    }
    
    // appkey
    NSString *appKey = item.thorAppKey;
    
    // v
    NSString *v = WDTHOR_NETWORKING_VERSION;
    
    // timestamp
    long long serverTime = [[WDTNServerClockProofreader sharedInstance] currentServerTime];
    NSString *timestamp = [NSString stringWithFormat:@"%lld", serverTime];
    
    // sign
    // 签名过程
    // 1. 所有相关请求参数(appkey，context，param，timestamp，v)除去sign后排序，key之间用分隔符&区分，
    //    结果为：appkey=${appkey}&context=${contextM}&param=${paramM}&timestamp=${timestamp}&v=${v}
    // 2. 在拼装的字符串后加上app secret后进行摘要，
    //    结果为：sign1=md5(appkey=${appkey}&context=${contextM}&param=${paramM}&timestamp=${timestamp}&v=${v}&app secret)，
    //    将摘要得到的字节流结果使用十六进制表示，转为大写
    // 3. 将第四步得到的sign1追加app secret加盐后进行摘要，结果为sign=md5(sign1+app secret)
    // 4. 将摘要得到的字节流结果使用十六进制表示，转为大写，即为sign
    
    NSString *rawPayload = [NSString stringWithFormat:@"appkey=%@&context=%@&param=%@&timestamp=%@&v=%@",
                         appKey, contextIM, paramIM, timestamp, v];
    
    NSString *rawSign1 = [NSString stringWithFormat:@"%@&%@", rawPayload, item.thorAppSecret];
    NSString *sign1 = [[CryptUtil md5:rawSign1] uppercaseString];

    NSString *rawSign = [NSString stringWithFormat:@"%@%@", sign1, item.thorAppSecret];
    NSString *sign = [[CryptUtil md5:rawSign] uppercaseString];
    
    // 由于服务端tomcat会自动做一次urldecode，导致+号变成空格，所以在这里对复杂参数文本做一次urlencode
    NSString *payload = [NSString stringWithFormat:@"appkey=%@&context=%@&param=%@&timestamp=%@&v=%@&sign=%@",
                         [appKey urlEncode], [contextIM urlEncode], [paramIM urlEncode], timestamp, [v urlEncode], [sign urlEncode]];
    
    return payload;
}

/**
 对指定参数字典进行thor协议加密处理
 input json string -> utf8 data -> gzip data -> aes data -> base64 output
 
 @param jsonStr 要加密的json字符串
 @return 加密完成后的base64字符串
 */
+ (NSString*)thorEncrypt:(NSString*)jsonStr withAESKey:(NSString*)aesKey {
    // json string -> utf8 data
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData == nil) {
        WDTNLog(@"Error happend when convering input dict %@ to json data for thor protocol.", jsonStr);
        return nil;
    }

    // utf8 data -> gzip data
    NSData* gzipData = [WDTNThorGZip gzipCompress:jsonData];

    if (gzipData == nil) {
        WDTNLog(@"Error happend when gziping data %ld for thor protocol.", [jsonData length]);
        return nil;
    }

    // gzip data -> aes data
    NSData* aesData = [WDTNThorAES thorAESEncrypt:gzipData withAESKey:aesKey];
    
    if (aesData == nil) {
        WDTNLog(@"Error happend when encrypting(aes) data %ld for thor protocol.", [gzipData length]);
        return nil;
    }
    
    // aes data -> base64 output
    NSString* base64Str = [GLCharCodecUtil base64Encoding:aesData];
    if (base64Str == nil) {
        WDTNLog(@"Error happend when encoding(base64) data %ld for thor protocol.", [aesData length]);
        return nil;
    }
    
    return base64Str;
}

/**
 对数据进行thor协议的解密和验证
 input aes data -> gzip data -> origin data -> crc32 check
 
 @param data 要解密的数据
 @param options 是否加密，是否压缩，crc32等
 @return 解密后数据
 */
+ (NSData*)thorDecrypt:(NSData*)data
            withAESKey:(NSString*)aesKey
            andOptions:(NSDictionary*)options
{
    NSString* gzip = options[@"Content-Encoding"];
    NSString* encrypted = options[@"X-Encrypt"];
    NSString* crc32Checksum = options[@"X-Checksum"];

    NSData* thorData = data;
    
    // 需要校验
    if (crc32Checksum != nil) { // crc32 check
        uLong crcValue = crc32(0L, Z_NULL, 0);
        crcValue = crc32(crcValue, [thorData bytes], (uInt)[thorData length]);
        
        NSString* checksum = [[crc32Checksum componentsSeparatedByString:@";"] lastObject];
        uLong checksumValue = (uLong)[checksum longLongValue];
        if (checksumValue != crcValue) {
            WDTNLog(@"Crc32 check failed for thor response.");
            
            return nil;
        }
    }
    
    // 需要解密
    if ([encrypted boolValue]) {
        // aes data -> gzip data
        NSData* aesData = [WDTNThorAES thorAESDecrypt:data withAESKey:aesKey];
        
        if (aesData == nil) {
            WDTNLog(@"Decrypt failed for thor response.");
            
            return nil;
        } else {
            thorData = aesData;
        }
    }
    
    // 需要解压
    if ([gzip isEqualToString:@"GLZip"]) {
        NSData* unzipedData = [WDTNThorGZip gzipUncompress:thorData];
        
        if (thorData == nil) {
            WDTNLog(@"Unzip failed for thor response.");
            
            return nil;
        } else {
            thorData = unzipedData;
        }
    }
    
    return thorData;
}

@end
