//
//  GLCodecProvider.m
//  GLAESGzipProvider
//
//  Created by 赵 一山 on 14/12/29.
//  Copyright (c) 2014年 赵 一山. All rights reserved.
//

#import "GLCodeUtil.h"
//#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GLCharCodecUtil

#pragma -mark  base64 codec
+ (NSString*)base64Encoding:(NSData*)srcData {
    //base64 编码
    if ( nil == srcData ) {
        return nil;
    }
//    NSData* data = [GTMBase64 encodeData:srcData];
    NSData* data = [srcData base64EncodedDataWithOptions:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
}

+ (NSData*)base64Decoding:(NSString*)srcString {
    if ([srcString length] <= 0) {
        return nil;
    }
    return  [[NSData alloc] initWithBase64EncodedString:srcString options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    return [GTMBase64 decodeString:srcString];
}

#pragma -mark  md5 codec
+ (NSString*)md5:(NSString*)str {
    if ([str length] <= 0) {
        return str;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)md5WithBytes:(char *)bytes length:(NSUInteger)length
{
    unsigned char result[16];
    CC_MD5( bytes, (CC_LONG)length, result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (NSString*)md5WithData:(NSData*)data {
    if (nil == data) {
        return nil;
    }
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [GLCharCodecUtil md5:str];
}

+ (NSData*)md5Data:(NSData*)data {
    return [[GLCharCodecUtil md5WithData:data] dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma -mark  password codec
+ (NSString*)encodePasswordForBuyer:(NSString*)srcString {
    //对买家类的各app做变形处理
    //base64编码
    NSData* srcData = [srcString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* strBase64 = [GLCharCodecUtil base64Encoding:srcData];
    NSInteger length = [strBase64 length];
    NSMutableString* strDone = [NSMutableString stringWithCapacity:length];
    //逐个字符做计算
    for (int index = 0; index < length; ++index) {
        unichar ch = [strBase64 characterAtIndex:index];
        int chOffset = index%3;
        ch += chOffset;
        [strDone appendFormat:@"%C", ch];
    }
    
    //尾部追加常量字符串"koudai_gouwu_is_success_for_ever"
    [strDone appendFormat:@"koudai_gouwu_is_success_for_ever"];
    
    //md5编码
    NSString* strResult = [GLCharCodecUtil md5:strDone];
    
    return strResult;
}

+ (NSString*)encodePasswordForSeller:(NSString*)srcString {
    //前插入常量字符串“_Wedian&&Is##Wonderful**@~0_”后md5编码
    NSString* strResult = [GLCharCodecUtil md5:[NSString stringWithFormat:@"_Wedian&&Is##Wonderful**@~0_%@", srcString]];
    return strResult;
}

@end
