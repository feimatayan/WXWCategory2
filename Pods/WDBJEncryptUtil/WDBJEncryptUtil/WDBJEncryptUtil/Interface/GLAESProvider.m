//
//  GLAESProvider.m
//  GLAESProvider
//
//  Created by 赵 一山 on 14/12/29.
//  Copyright (c) 2014年 赵 一山. All rights reserved.
//

#import "GLAESProvider.h"
#import "NSData-AES.h"

#import "GLAESPassphrase.h"

@implementation GLAESProvider

+ (NSData *)AESEncrypt:(NSData*)srcData withPassphrase:(NSData*)pass
{
    return pass ? [srcData AESEncryptWithPassphrase:pass] : nil;
}

+ (NSData *)AESEncrypt:(NSData*)srcData withPassphraseID:(NSString*)passID
{
    NSData *pass = [[GLAESPassphrase sharedManager] aesPassphraseByID:passID];
    return [GLAESProvider AESEncrypt:srcData withPassphrase:pass];
}

+ (NSData *)AESDecrypt:(NSData*)srcData withPassphrase:(NSData*)pass
{
    return pass ? [srcData AESDecryptWithPassphrase:pass] : nil;
}

+ (NSData *)AESDecrypt:(NSData*)srcData withPassphraseID:(NSString*)passID
{
    NSData *pass = [[GLAESPassphrase sharedManager] aesPassphraseByID:passID];
    return [GLAESProvider AESDecrypt:srcData withPassphrase:pass];
}

@end
