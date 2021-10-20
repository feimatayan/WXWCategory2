//
//  GLDataSignContainer.h
//  GLOpensourceLib
//
//  Created by 赵 一山 on 15/5/20.
//  Copyright (c) 2015年 赵 一山. All rights reserved.
//

#import <Foundation/Foundation.h>

/*************************************************
 @description:
 GLDataSignKeyContainer：管理和匹配口袋网络请求的数字签名信息；
 直接调用类方法获取输入输出
 @history:
 1.
 @date:
 @modifier:
 @modification:
 
 *************************************************/
@interface GLDataSignKeyContainer : NSObject {
    //交互的签名ID和签名串
    NSMutableDictionary* _mapSignKeyByID;
}

/*************************************************
 * 读取app与proxy服务器网络交互使用的签名ID
 *************************************************/
@property (atomic, copy) NSString* defaultSignIDForProxy;


/*************************************************
 * 读取app与升级服务器网络交互使用的签名ID
 *************************************************/
@property (atomic, copy) NSString* defaultSignIDForUpgrade;

/*************************************************
 * 读取app与升级服务器网络交互使用的签名ID
 *************************************************/
@property (atomic, copy) NSString* defaultSignIDForCommon;

/*************************************************
 @method: sharedManager
 @description:单例
 @return: 自身对象的单例
 *************************************************/
+ (GLDataSignKeyContainer*)sharedManager;

/*************************************************
 @method: setSignKey:forID:
 @description:添加签名id和签名串
 
 @param signKey 中key，对应签名串；
 @param signID 密钥
 @output: 无
 *************************************************/
- (void)setSignKey:(NSString*)signKey forID:(NSString*)signID;

/*************************************************
 @method: signKeyByID:
 @description:读取app与proxy服务器交互使用的签名串
 
 @param signID map中key的id，对应签名串；
 @output: 无
 @return: 返回key对应的签名串，否则返回nil；
 @others:
 *************************************************/
- (NSString*)signKeyByID:(NSString*)signID;

@end
