//
//  NSData+WDUT.m
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import "NSData+WDUT.h"
#include <zlib.h>
#include <CommonCrypto/CommonCrypto.h>

@implementation NSData (WDUT)

+ (NSData *)wdutDataWithBase64EncodedString:(NSString *)string {
    const char lookup[] =
            {
                    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
                    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
                    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
                    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
                    99, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
                    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
                    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
                    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
            };

    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];

    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *) [outputData mutableBytes];

    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++) {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99) {
            accumulated[accumulator] = decoded;
            if (accumulator == 3) {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }

    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;

    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength ? outputData : nil;
}

- (NSString *)wdutBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;

    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];

    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth ? (maxOutputLength / wrapWidth) * 2 : 0;
    unsigned char *outputBytes = (unsigned char *) malloc(maxOutputLength);

    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3) {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];

        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0) {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }

    //handle left-over data
    if (i == inputLength - 2) {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] = '=';
    } else if (i == inputLength - 1) {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }

    //truncate data to match actual output length
    outputBytes = realloc(outputBytes, outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:outputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];

#if !__has_feature(objc_arc)
    [result autorelease];
#endif

    return (outputLength >= 4) ? result : nil;
}

- (NSString *)wdutBase64EncodedString {
    return [self wdutBase64EncodedStringWithWrapWidth:0];
}

- (NSData *)wdutGzipDeflate {
    if ([self length] == 0) return self;

    z_stream strm;

    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *) [self bytes];
    strm.avail_in = (uInt) [self length];

    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION

    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15 + 16),
            8, Z_DEFAULT_STRATEGY) != Z_OK)
        return nil;

    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];

    do {
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy:16384];

        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt) ([compressed length] - strm.total_out);

        deflate(&strm, Z_FINISH);
    } while (strm.avail_out == 0);

    deflateEnd(&strm);

    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

- (NSData *)wdutAes256EncryptWithKey:(NSString *)key {
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];

    if (keyData.length != 16 && keyData.length != 24 && keyData.length != 32) {
        return nil;
    }

//    Byte *byteArray[16] = {0};
//    NSData *data = [NSData dataWithBytes:byteArray length:16];

    NSData *result = nil;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding, // 系统默认使用 CBC，然后指明使用 PKCS7Padding
            keyData.bytes,
            keyData.length,
            NULL,
            self.bytes,
            self.length,
            buffer,
            bufferSize,
            &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

- (NSData *)wdutAes256DecryptWithKey:(NSString *)key {
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (keyData.length != 16 && keyData.length != 24 && keyData.length != 32) {
        return nil;
    }

//    Byte *byteData = (Byte *) malloc(16);
//    NSData *data = [NSData dataWithBytes:byteData length:16];

    NSData *result = nil;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding, // 系统默认使用 CBC，然后指明使用 PKCS7Padding
            keyData.bytes,
            keyData.length,
            NULL,
            self.bytes,
            self.length,
            buffer,
            bufferSize,
            &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

@end
