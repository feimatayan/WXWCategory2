//
// Created by 陈岳燊 on 16/8/3.
//

#import <Foundation/Foundation.h>

@interface NSString (WDURL)

- (NSString *)wd_encodeURL;
- (NSString *)wd_decodeURL;
- (NSString *)wd_encodeChineseString;

- (NSURL *)wd_addQuery:(NSDictionary *)queryDictionary;

// 获取url中的参数值，参数开始符号默认为"?"
+ (NSString *)wd_paramValueOfGetForKey:(NSString *)key ofURL:(NSString *)url;
+ (NSString *)wd_paramDecValueOfGetForKey:(NSString *)key ofURL:(NSString *)url;

//解析URL中的参数的函数
- (NSDictionary *)wd_params;
+ (NSDictionary *)wd_params:(NSString *)sUrl;
+ (NSArray *)wd_getParamComponentsByUrl:(NSString *)sUrl __attribute__((deprecated("wd_params")));
+ (NSString *)wd_getParamValue:(NSString *)strKey params:(NSArray *)arrParam;

@end
