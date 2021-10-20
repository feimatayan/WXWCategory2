//
//  GLAESPassphraseManager.h
//  iShoppingCommon
//
//  Created by 赵 一山 on 14-5-24.
//  Copyright © 2011-2014 Koudai Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

/*************************************************
 @description:
 GLAESPassphraseManager：管理和匹配口袋网络请求的密钥；
 口袋网络请求和响应，一般采用aes加密。
 直接调用类方法获取输入输出
 @history:
 1.
 @date:
 @modifier:
 @modification:
 
 *************************************************/
@interface GLAESPassphrase : NSObject {
    //交互的ID和密钥对
    NSMutableDictionary* _mapPassphraseByID;
}

/*************************************************
 * 读取app与proxy服务器网络交互使用的密钥ID
 *************************************************/
@property (atomic, copy) NSString* defaultAesPassphraseIDForProxy;

/*************************************************
 * 读取app与升级服务器网络交互使用的密钥ID
 *************************************************/
@property (atomic, copy) NSString* defaultAesPassphraseIDForUpgrade;

/*************************************************
 * 读取app与升级服务器网络交互使用的密钥ID
 *************************************************/
@property (atomic, copy) NSString* defaultAesPassphraseIDForCommon;

/*************************************************
 @method: sharedManager
 @description:单例

 @return: 自身对象的单例
 @others:
 *************************************************/
+ (GLAESPassphrase*)sharedManager;

/*************************************************
 @method: setAesPassphrase:forKeyID:
 @description:添加keyid和密钥
 
 @param passphrase map中key，对应密钥
 @param akeyid 密钥
 @output: 无
 *************************************************/
- (void)setAesPassphrase:(NSString*)passphrase forKeyID:(NSString*)akeyid;

/*************************************************
 @method: aesPassphraseByID:
 @description:读取app与proxy服务器交互使用的密钥
 
 @param akeyid map中key，对应密钥；
 @output: 无
 @return: 返回key对应的密钥，否则返回nil；
 @others:
 *************************************************/
- (NSData*)aesPassphraseByID:(NSString*)akeyid;

@end
