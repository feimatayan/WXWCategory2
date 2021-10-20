//
//  NSString+WDNetwork.m
//  Pods
//
//  Created by yangxin02 on 15/11/9.
//
//

#import "NSString+WDNetwork.h"

#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (WDNetwork)

#pragma mark - HexString

+ (NSString *)wdn_hexString:(NSData *)data {
    
    NSInteger length = data.length;
    unsigned char *buffer = (unsigned char*)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (int ii = 0; ii < length; ++ii) {
        [hexString appendFormat:@"%02x", buffer[ii]];
    }
    return hexString;
}

#pragma mark - Url Encode

- (NSString *)wdn_URLEncode {

    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
}

- (NSString *)wdn_queryEncode {

    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - MD5

- (NSString *)wdn_MD5 {
    if (self.length == 0) {
        return nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (BOOL)wdn_isNotEmpty:(NSString *)aString {
    return aString != nil && aString.length > 0;
}

@end
