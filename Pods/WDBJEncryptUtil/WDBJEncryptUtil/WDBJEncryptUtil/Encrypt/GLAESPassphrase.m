//
//  GLAESPassphrase.m
//  iShoppingCommon
//
//  Created by 赵 一山 on 14-5-24.
//  Copyright © 2011-2014 Koudai Corp. All rights reserved.
//

#import "GLAESPassphrase.h"

#define kDefaultProxyKid             @"1.0.1"            //默认的proxy密钥id
#define kDefaultProxyKey             @"52e5dcc0909da93b729e542fb6cec6f6"            //默认的proxy密钥
#define kDefaultUpdateKid            @"3.0.0"      //默认的升级服务器密钥id
#define kDefaultUpdateKey            @"ae78d9d869da70c6b4d3112561defffd"      //默认的升级服务器密钥

#define kDefaultAnalysisKid            @"10.1"      //默认的升级服务器密钥id
#define kDefaultAnalysisKey            @"4ef6e7744b3341debb5c98bc0db8337d"


@implementation GLAESPassphrase

/*************************************************
 @method: sharedManager
 @description:单例
 @return: 自身对象的单例
 @others:
 *************************************************/
+ (GLAESPassphrase*)sharedManager {
    static GLAESPassphrase *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[GLAESPassphrase alloc] init];
    }
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        //密钥ID和密钥对
        _mapPassphraseByID = [[NSMutableDictionary alloc] initWithCapacity:5];
        [_mapPassphraseByID setObject:[GLAESPassphrase aesPassphraseByCommand:kDefaultProxyKey] forKey:kDefaultProxyKid];
        [_mapPassphraseByID setObject:[GLAESPassphrase aesPassphraseByCommand:kDefaultUpdateKey] forKey:kDefaultUpdateKid];
        
        [_mapPassphraseByID setObject:[GLAESPassphrase aesPassphraseByCommand:kDefaultAnalysisKey] forKey:kDefaultAnalysisKid];
        
        self.defaultAesPassphraseIDForProxy = kDefaultProxyKid;
        self.defaultAesPassphraseIDForUpgrade = kDefaultUpdateKid;
        self.defaultAesPassphraseIDForCommon = kDefaultUpdateKid;
    }
    return self;
}

- (void) dealloc {
    
    self.defaultAesPassphraseIDForProxy = nil;
    self.defaultAesPassphraseIDForUpgrade = nil;
    self.defaultAesPassphraseIDForCommon = nil;
    _mapPassphraseByID = nil;

}


#pragma mark -EncryptKey method
- (void)setAesPassphrase:(NSString*)passphrase forKeyID:(NSString*)akeyid {
    if (passphrase && akeyid ) {
        [_mapPassphraseByID setObject:[GLAESPassphrase aesPassphraseByCommand:passphrase] forKey:akeyid];
    }
}

- (NSData*)aesPassphraseByID:(NSString*)akeyid
{
    NSData* pass = nil;
    if ( nil != akeyid ) {
        pass = [_mapPassphraseByID objectForKey:akeyid];
    }
    return pass;
}

+ (NSMutableData*)aesPassphraseByCommand:(NSString*)command {
    // encrypt key
    NSMutableData * encryptKey = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < 16; i++)
    {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [encryptKey appendBytes:&whole_byte length:1];
    }
    return encryptKey;
 }

@end
