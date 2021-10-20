//
//  NSString+WDNetwork.h
//  Pods
//
//  Created by yangxin02 on 15/11/9.
//
//

#import <Foundation/Foundation.h>

@interface NSString (WDNetwork)

/**
 *  HexString
 */
+ (NSString *)wdn_hexString:(NSData *)data;

/**
 *  URL Encode
 */
- (NSString *)wdn_URLEncode;
- (NSString *)wdn_queryEncode;

/**
 *  MD5
 */
- (NSString *)wdn_MD5;

+ (BOOL)wdn_isNotEmpty:(NSString *)aString;

@end
