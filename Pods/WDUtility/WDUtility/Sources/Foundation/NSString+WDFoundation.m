//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import "NSString+WDFoundation.h"
#import <CommonCrypto/CommonDigest.h>


int const GGCharacterIsNotADigit = 10;

@implementation NSString (WDFoundation)

- (NSString *)wd_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)wd_containsString:(NSString *)string {
    return [self wd_containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)wd_containsString:(NSString *)string options:(NSStringCompareOptions)options {
    return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

- (long)wd_longValue {
    return (long) [self longLongValue];
}

- (long long)wd_longLongValue {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    long long valueToGet;
    return [scanner scanLongLong:&valueToGet] ? valueToGet : 0;
}

- (unsigned)digitValue:(unichar)c {
    if ((c > 47) && (c < 58)) {
        return (unsigned int) (c - 48);
    }

    return GGCharacterIsNotADigit;
}

- (unsigned long long)wd_unsignedLongLongValue {
    unsigned long n = [self length];
    unsigned long long v, a;
    unsigned small_a, j;

    v = 0;
    for (j = 0; j < n; j++) {
        unichar c = [self characterAtIndex:j];
        small_a = [self digitValue:c];
        if (small_a == GGCharacterIsNotADigit) continue;
        a = (unsigned long long) small_a;
        v = (10 * v) + a;
    }

    return v;
}

- (NSString *)wd_md5 {
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t) strlen(str), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }

    return ret;
}

- (NSString *)wd_SHA1 {
    const char *cstr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t) data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)wd_URLEncodedString {
    return [self wd_URLEncodedStringWithEncoding:kCFStringEncodingUTF8];
}

- (NSString *)wd_URLEncodedStringWithEncoding:(CFStringEncoding)stringEncoding {
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
            (__bridge CFStringRef) self,
            NULL,
            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
            stringEncoding);
}

- (NSString *)wd_URLDecodedString {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)wd_isBlank {
    if ([self length] == 0) {
        return YES;
    }

    return [[self wd_trim] length] == 0;
}

- (BOOL)wd_isNotBlank {
    return ![self wd_isBlank];
}

- (NSString *)wd_replaceString:(NSString *)target withString:(NSString *)replacement {
    if (!target || !replacement) {
        return target;
    }

    NSMutableString *string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:target
                            withString:replacement
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, string.length)];
    return string;
}

- (CGSize)wd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attributes = @{NSFontAttributeName : font};
        CGRect rect = [self boundingRectWithSize:size
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:attributes
                                         context:nil];
        if (CGRectGetHeight(rect) > size.height && size.height > 0) {
            rect.size = CGSizeMake(rect.size.width, size.height);
        }
        if (CGRectGetWidth(rect) > size.width && size.width > 0) {
            rect.size = CGSizeMake(size.width, rect.size.height);
        }
        return rect.size;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
}

- (CGSize)wd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attributes = @{NSFontAttributeName : font};
        CGRect rect = [self boundingRectWithSize:size
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:attributes
                                         context:nil];
        return rect.size;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

@end

