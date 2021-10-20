//
//  GLDataSignContainer.m
//  GLOpensourceLib
//
//  Created by 赵 一山 on 15/5/20.
//  Copyright (c) 2015年 赵 一山. All rights reserved.
//

#import "GLDataSignKeyContainer.h"

#define kDefaultProxySignID              @"1.1"            //默认的proxy签名ID
#define kDefaultProxySignKey             @"58089c93b2f84312ade818c85cf7dc23"            //默认的proxy签名串
#define kDefaultUpdateSignID             @"1.1"      //默认的升级服务器签名ID
#define kDefaultUpdateSignKey            @"58089c93b2f84312ade818c85cf7dc23"      //默认的升级服务器签名串
#define kDefaultAnalysisSignKid            @"10.1"      //默认的升级服务器密钥id
#define kDefaultAnalysisSignKey            @"4ef6e7744b3341debb5c98bc0db8337d"

@implementation GLDataSignKeyContainer

/*************************************************
 @method: sharedManager
 @description:单例
 
 @param:
 input: 无
 @return: 自身对象的单例
 @others:
 *************************************************/
+ (GLDataSignKeyContainer*)sharedManager {
    static GLDataSignKeyContainer *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[GLDataSignKeyContainer alloc] init];
    }
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        //签名ID和签名串
        _mapSignKeyByID = [[NSMutableDictionary alloc] initWithCapacity:5];
        [_mapSignKeyByID setObject:kDefaultProxySignKey forKey:kDefaultProxySignID];
        [_mapSignKeyByID setObject:kDefaultUpdateSignKey forKey:kDefaultUpdateSignID];
        [_mapSignKeyByID setObject:kDefaultAnalysisSignKey forKey:kDefaultAnalysisSignKid];
        
        self.defaultSignIDForProxy = kDefaultProxySignID;
        self.defaultSignIDForUpgrade = kDefaultUpdateSignID;
        self.defaultSignIDForCommon = kDefaultUpdateSignID;
    }
    return self;
}

- (void) dealloc {
    
    self.defaultSignIDForProxy = nil;
    self.defaultSignIDForUpgrade = nil;
    self.defaultSignIDForCommon = nil;
    _mapSignKeyByID = nil;
    
}


#pragma mark -EncryptKey method

/*************************************************
 @method: setSignKey:forID:
 @description:添加签名id和签名串
 
 @param:
 akeyid：map中key，对应签名串；
 passphrase：密钥
 @output: 无
 @return: ；
 @others:
 *************************************************/
- (void)setSignKey:(NSString*)passphrase forID:(NSString*)akeyid {
    if (passphrase && akeyid ) {
        [_mapSignKeyByID setObject:passphrase forKey:akeyid];
    }
}


/*************************************************
 @method: signKeyByID:
 @description:读取app与proxy服务器交互使用的签名串
 
 @param:
 akeyid：map中key，对应签名串；
 @output: 无
 @return: 返回key对应的签名串，否则返回nil；
 @others:
 *************************************************/
- (NSString*)signKeyByID:(NSString*)akeyid
{
    NSData* pass = nil;
    if ( nil != akeyid ) {
        pass = [_mapSignKeyByID objectForKey:akeyid];
    }
    return (NSString *)pass;
}

@end
