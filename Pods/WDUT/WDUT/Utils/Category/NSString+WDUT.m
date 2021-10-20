//
//  NSString+WDUT.m
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+WDUT.h"
#import "NSData+WDUT.h"

@implementation NSString (WDUT)

+ (NSString *)wdutStringWithBase64EncodedString:(NSString *)string {
    NSData *data = [NSData wdutDataWithBase64EncodedString:string];
    if (data) {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];

#if !__has_feature(objc_arc)
        [result autorelease];
#endif

        return result;
    }
    return nil;
}

- (NSString *)wdutMD5 {
    if (self.length == 0) {
        return nil;
    }

    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

- (BOOL)wdutIsInteger {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end