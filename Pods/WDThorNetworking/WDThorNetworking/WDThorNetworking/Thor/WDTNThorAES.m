//
//  WDTNThorAES.m
//  WDThorNetworking
//
//  Created by zephyrhan on 2017/9/29.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import "WDTNThorAES.h"
#import "aes.h"
#import <CommonCrypto/CommonCryptor.h>


#pragma mark -

#ifdef __cplusplus
#define OFFOF(p, n) ((typeof(p)) ((char *) (p) + (n)))
#else
#define OFFOF(p, n) ((typeof(p)) ((void *) (p) + (n)))
#endif

#define AES_BLOCK_SIZE 16


static int getStrIndex(char c) {
    if (c > '9') {
        return 10 + (c - 'a');
    } else {
        return c - '0';
    }
}

NSData* mbedtls_aes_crypt_ecb_pkcs5padding(int mode, const char *in, int inLen, NSString* aesKey) {
    //hex2bytes
    unsigned char key[[aesKey length] / 2];
    int i = 0;
    for (i = 0; i < [aesKey length] / 2; ++i) {
        char c = (char) ((((getStrIndex([aesKey characterAtIndex:2 * i])) & 0x0f) << 4)
                         | ((getStrIndex([aesKey characterAtIndex:2 * i + 1])) & 0x0f));
        key[i] = (unsigned char) c;
    }
    
    mbedtls_aes_context aes_ctx;
    mbedtls_aes_init(&aes_ctx);
    NSData* result = nil;
    
    if (mode == MBEDTLS_AES_ENCRYPT) {
        if (mbedtls_aes_setkey_enc(&aes_ctx, key, 128) != 0) {   //  set encrypt key
            fprintf(stderr, "Unable to set encryption key in AES\n");
            mbedtls_aes_free(&aes_ctx);
            return nil;
        }

        /* calc block num, should add a '\0' at last */
        size_t text_len = inLen;
        size_t blk_num = (text_len / AES_BLOCK_SIZE) + 1;
        
        /*
         * copy text to align buffer
         * and pad by PKCS5Padding
         *
         * pad by algin_len - text_len
         * if text_len % AES_BLOCK_SIZE == 0, should add a
         * block at last and pad by 0x16
         *
         * if diff 1, pad { ... , ...., 0x01 }
         * if diff 2, pad { ...., 0x02, 0x02 }
         * if diff 3, pad { 0x03, 0x03, 0x03 }
         */
        size_t alg_len = blk_num * AES_BLOCK_SIZE;
        uint8_t *alg_s = (typeof(alg_s)) malloc(alg_len);
        memcpy(alg_s, in, text_len);
        
        size_t i;
        int pad = AES_BLOCK_SIZE - text_len % AES_BLOCK_SIZE;
        for (i = text_len; i < alg_len; i++) {
            alg_s[i] = pad;
        }
        
        /*
         * encrypt every block
         */
        size_t enc_len = alg_len;
        char* out = (char *) malloc(enc_len);
        
        uint8_t *enc_s = (uint8_t *) (out);
        for (i = 0; i < blk_num; i++) {
            mbedtls_aes_crypt_ecb(&aes_ctx, MBEDTLS_AES_ENCRYPT, OFFOF(alg_s, i * AES_BLOCK_SIZE),
                                  OFFOF(enc_s, i * AES_BLOCK_SIZE));
        }
        
        free(alg_s);
        alg_s = NULL;
        
        result = [NSData dataWithBytes:out length:enc_len];
        free(out);
        out = NULL;
    } else {
        if (mbedtls_aes_setkey_dec(&aes_ctx, key, 128) != 0) {   //  set decrypt key
            
            fprintf(stderr, "Unable to set decryption key in AES\n");
            mbedtls_aes_free(&aes_ctx);
            return nil;
        }
        
        /*
         * decrypt every block
         */
        size_t text_len = inLen;
        size_t blk_num = (text_len / AES_BLOCK_SIZE);
        
        size_t dec_len = text_len;
        uint8_t *dec_s = (typeof(dec_s)) malloc(dec_len);
        size_t i;
        for (i = 0; i < blk_num; i++) {
            mbedtls_aes_crypt_ecb(&aes_ctx, MBEDTLS_AES_DECRYPT,
                                  OFFOF((uint8_t *) in, i * AES_BLOCK_SIZE),
                                  OFFOF(dec_s, i * AES_BLOCK_SIZE));
        }
        
        size_t length = dec_len;
        if (dec_s[dec_len - 1] <= AES_BLOCK_SIZE) {
            length = dec_len - dec_s[dec_len - 1];
        }
        
        char* out = (char *) malloc(length + 1);
        memcpy(out, dec_s, length);
        (out)[length] = '\0';
        
        free(dec_s);
        dec_s = NULL;
        
        result = [NSData dataWithBytes:out length:length];
        free(out);
        out = NULL;
    }
    
    mbedtls_aes_free(&aes_ctx);
    
    return result;
}


@implementation WDTNThorAES

+ (NSData*)thorAESEncrypt:(NSData*)inputData withAESKey:(NSString*)aesKey {
    const char* input = [inputData bytes];

    NSData* outputData = mbedtls_aes_crypt_ecb_pkcs5padding(MBEDTLS_AES_ENCRYPT, input, (int)[inputData length], aesKey);
    
    return outputData;
}

+ (NSData*)thorAESDecrypt:(NSData*)inputData withAESKey:(NSString*)aesKey {
    const char* input = [inputData bytes];
    
    NSData* outputData = mbedtls_aes_crypt_ecb_pkcs5padding(MBEDTLS_AES_DECRYPT, input, (int)[inputData length], aesKey);
    
    return outputData;
}


/**
 * 使用系统库进行AES加密kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES128
 * 也能够与服务端PKCS5兼容，在此保留代码，以备后用
 */
//+ (NSData*)thorAESEncrypt:(NSData*)data withAESKey:(NSString*)key {
//    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
////    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
////    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
////    
////    // fetch key data
////    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    
//    //hex2bytes
//    unsigned char keyPtr[[key length] / 2];
//    int i = 0;
//    for (i = 0; i < [key length] / 2; ++i) {
//        char c = (char) ((((getStrIndex([key characterAtIndex:2 * i])) & 0x0f) << 4)
//                         | ((getStrIndex([key characterAtIndex:2 * i + 1])) & 0x0f));
//        keyPtr[i] = (unsigned char) c;
//    }
//    
//    NSUInteger dataLength = [data length];
//    
//    //See the doc: For block ciphers, the output size will always be less than or
//    //equal to the input size plus the size of one block.
//    //That's why we need to add the size of one block here
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//    
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode,
//                                          keyPtr, kCCKeySizeAES128,
//                                          NULL /* initialization vector (optional) */,
//                                          [data bytes], dataLength, /* input */
//                                          buffer, bufferSize, /* output */
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        //the returned NSData takes ownership of the buffer and will free it on deallocation
//        
//        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
//    } else {
//        free(buffer); //free the buffer;
//        NSLog(@"Error happend when aes encrypting data");
//        
//        return nil;
//    }
//}

@end
