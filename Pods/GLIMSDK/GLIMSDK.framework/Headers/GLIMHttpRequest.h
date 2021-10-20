//
//  GLIMHttpRequest.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WDThorNetworking/WDThorNetworking.h>

#pragma mark - 扩展请求类型
/// 适用于配置请求
FOUNDATION_EXPORT NSString * const GLIMRequestConfigForHTTP;

#pragma mark - 请求实现

#define kGLIMHttpResultKey @"result"
#define kGLIMHttpStatusKey @"status"

@interface GLIMHttpRequest : NSObject

/// 接口名称
@property (nonatomic, strong) NSString* serviceName;

/// 接口参数字典
@property (nonatomic, strong) NSMutableDictionary* params;

//@property (nonatomic) WDSHttpRequestType requestType;

/**
 *    发起请求
 *
 *    @param success 成功回调
 *    @param failure 失败回调
 */
- (void)sendRequestWithSuccess:(void(^)(id result))success andFailure:(void(^)(id error))failure;

/**
 *    从数据字典中取字段值, 通过类型验证保证数据是字典类型，主要用于服务器容错
 *
 *    @param dict 字典
 *    @param key  字段值
 *
 *    @return 值
 */
- (id)safeValueFromDictionary:(NSDictionary*)dict forKey:(NSString*)key;

#pragma mark - to be implemented by subclasses

/**
 *    组装参数字典
 *
 *    子类需重写此函数，将所有需要上传的参数放入参数字典params中
 */
- (void)assembleParams;

/**
 *    检查请求参数
 *    如果参数不符合要求，则不会发起接口请求。
 *
 *    子类需重写此函数，检查相应的参数值。
 *
 *    @return 参数是否有误
 */
- (BOOL)illegalParams;

/**
 *    重置所有接口数据到初始值
 *    当接口请求需要复用时，可在每次请求前调用此函数，重置所有参数状态。
 *
 *    子类需重写此函数，将不同的参数设置为需要的默认值。
 */
- (void)reset;

/**
 *    取消请求
 */
- (void)cancel;

/**
 *    解析返回数据
 *
 *    子类需重写此函数，对接口返回进行解析处理。如不处理则直接将数据字典返回给请求回调函数。
 *
 *    param respData 返回数据转化的字段字典
 *
 *    @return 解析后的结果
 */
- (id)parseResponseData:(NSDictionary*)respData;

- (NSMutableDictionary*)deviceParams;

#pragma mark - Thor网关
/// 获取网关地址
- (NSString *)getThorWithPort:(NSString *)port;
/// 默认的Thor请求配置
- (NSString *)thorRequestConfigType;

@end

/**
 简单的Get请求
 默认的Thor请求都是Post，但有部分IM接口需要Get方法
 */
@interface GLIMHttpGetRequest : GLIMHttpRequest

/**
 解析返回的数据
 
 子类需重写此函数，对接口返回进行解析处理。如不处理则直接将数据返回给请求回调函数。

 @param respData 直接返回语法数据
 @return 解析后的结果
 */
- (id)parseResponseDataWithData:(NSData *)respData;

@end
