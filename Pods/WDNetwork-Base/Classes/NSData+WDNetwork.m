//
//  NSData+WDNetwork.m
//  Pods
//
//  Created by yangxin02 on 15/11/9.
//
//

#import <zconf.h>
#import <zlib.h>
#import <CommonCrypto/CommonDigest.h>

#import "NSData+WDNetwork.h"

@implementation NSData (WDNetwork)

#pragma mark - Base64

- (NSString *)wdn_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    
    if (![self length]) {
        return nil;
    }
    
    NSString *encoded = nil;
    switch (wrapWidth){
        case 64:{
            return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        case 76:{
            return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        }
        default:{
            encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
        }
    }
    
    if (!wrapWidth || wrapWidth >= [encoded length]) {
        return encoded;
    }
    
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth) {
        if (i + wrapWidth >= [encoded length]) {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    
    return result;
}

- (NSString *)wdn_base64EncodedString {
    return [self wdn_base64EncodedStringWithWrapWidth:0];
}

- (NSString *)wdn_crc32 {
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, self.bytes, (unsigned int) self.length);
    return [NSString stringWithFormat:@"%lu", crc];
}

- (NSString *)wdn_MD5 {
    const char *value = [self bytes];
    NSUInteger length = self.length;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG) length, outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}


@end
