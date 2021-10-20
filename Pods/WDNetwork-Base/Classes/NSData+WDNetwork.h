//
//  NSData+WDNetwork.h
//  Pods
//
//  Created by yangxin02 on 15/11/9.
//
//

#import <Foundation/Foundation.h>

@interface NSData (WDNetwork)

/**
 *  Base64
 */
- (NSString *)wdn_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)wdn_base64EncodedString;

- (NSString *)wdn_crc32;

- (NSString *)wdn_MD5;

@end
