//
//  GLAESProvider.h
//  GLAESProvider
//
//  Created by 赵 一山 on 14/12/29.
//  Copyright (c) 2014年 赵 一山. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma -mark  GLAESProvider
@interface GLAESProvider : NSObject

+ (NSData *)AESEncrypt:(NSData*)srcData withPassphrase:(NSData*)pass;
+ (NSData *)AESEncrypt:(NSData*)srcData withPassphraseID:(NSString*)passID;

+ (NSData *)AESDecrypt:(NSData*)srcData withPassphrase:(NSData*)pass;
+ (NSData *)AESDecrypt:(NSData*)srcData withPassphraseID:(NSString*)passID;


@end


