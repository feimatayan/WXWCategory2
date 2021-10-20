//
//  WDTNMultipartFormData.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/15.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const WDTNFromPartKey;
FOUNDATION_EXPORT NSString * const WDTNFromPartFilename;
FOUNDATION_EXPORT NSString * const WDTNFromPartFileData;
FOUNDATION_EXPORT NSString * const WDTNFromPartFileType;

@interface WDTNMultipartFormData : NSObject <NSCoding>

@property (nonatomic, strong) NSString *url;
/// return Function, 口袋的业务需要用到retFunction，并用它作为结果的裁剪标志.
@property (nonatomic, strong) NSString *retFunction;
/// HTTPHeader 设置的参数
@property (nonatomic,strong) NSDictionary *HTTPHeader;

/// 请求body的 key:value 字符串参数
@property (nonatomic, readonly) NSMutableDictionary *params;
/// 请求body的 data 参数
@property (nonatomic, readonly) NSMutableArray *partArray;

- (instancetype)initWithURL:(NSString *)strURL;

/**
 form 表单字符串参数
 */
- (void)appendParamWithKey:(NSString *)key value:(NSString *)value;

/**
 appendParamWithKey:value: 的快捷方式
 */
- (void)appendParams:(NSDictionary *)params;

/**
 不指定 key 时，默认指定 key 为 "data"
 */
- (void)appendPartWithData:(NSData *)data;

- (void)appendPartWithKey:(NSString *)key data:(NSData *)data;

/**
 上传文件并且需要指定文件类型

 @param key form-data 对应的 nama,如果为 nil,默认值为 "data"
 @param data value 值
 @param type 文件类型,默认值 image/jpeg
 */
- (void)appendPartWithKey:(NSString *)key data:(NSData *)data fileType:(NSString *)type;

/**
 上传文件并且需要指定 filename
 */
- (void)appendPartWithKey:(NSString *)key fileName:(NSString *)fileName data:(NSData *)data;

/**
 @param type 文件类型,默认值 image/jpeg
 */
- (void)appendPartWithKey:(NSString *)key fileName:(NSString *)fileName data:(NSData *)data fileType:(NSString *)type;

@end
