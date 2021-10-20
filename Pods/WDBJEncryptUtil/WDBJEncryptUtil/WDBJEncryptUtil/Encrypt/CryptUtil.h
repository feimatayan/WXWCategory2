//
//  CryptUtil.h
//  RSSReader
//
//  Created by hanchao on 10-7-19.
//  Copyright 2010 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CryptUtil : NSObject {

}

+ (NSString*)md5:(NSString*)str;
+ (NSString *)md5WithBytes:(char *)bytes length:(NSUInteger)length;
+ (NSData*)md5Data:(NSData*)data;
+ (NSString*)md5WithData:(NSData*)data;

+ (NSData*)gzipCompress:(NSData*)inData;
+ (NSData*)gzipExtract:(NSData*)inData;

+ (NSString *)getJsonStringWithObject:(id)object;

@end

