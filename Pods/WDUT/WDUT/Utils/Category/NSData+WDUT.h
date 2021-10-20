//
//  NSData+WDUT.h
//  WDUT
//
//  Created by WeiDian on 16/01/06.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WDUT)

+ (NSData *)wdutDataWithBase64EncodedString:(NSString *)string;

- (NSString *)wdutBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)wdutBase64EncodedString;

- (NSData *)wdutGzipDeflate;

- (NSData *)wdutAes256EncryptWithKey:(NSString *)key;

- (NSData *)wdutAes256DecryptWithKey:(NSString *)key;

@end