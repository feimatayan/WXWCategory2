//
//  NSObject+gljson.h
//  iShoppingCommon
//
//  Created by 赵 一山 on 14-8-1.
//
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/*************************************************
 @Description:
 NSDictionary (ReadonlyInsensitiveStringKey)：对字符串本身做url encode
 *************************************************/
@interface NSDictionary (ReadonlyInsensitiveStringKey_jsonString)

/*************************************************
 @method: objectForInsensitiveKey:
 @description:读取value时，忽略字符串key的大小写情况
 
 @param key 的key值；
 @output: 无
 @return: key对应的value值
 @others:
 *************************************************/
- (id) objectForInsensitiveKey:(id)key;


/*************************************************
 @method: jsonStringForGL
 @description:按照json格式输出字符串
 
 @output: 无
 @return: json格式字符串
 @others:
 *************************************************/
- (NSString*)jsonStringForGL;

/*************************************************
 @method: httpBodyForGL
 @description:按照http query的格式输出字符串，不做url encode
 
 @output: 无
 @return: http url query格式字符串
 @others:
 *************************************************/
- (NSString*)httpBodyForGL;

/*************************************************
 @method: httpUrlForGL
 @description:按照http query的格式输出字符串，需要做url encode
 
 @output: 无
 @return: http url query格式字符串
 @others:
 *************************************************/
- (NSString*)httpUrlForGL;

@end

@interface NSMutableDictionary (kdsetobject)

/*************************************************
 @method: glSetObject:forKey:
 @description:对setObject:forKey:做参数判断，避免crash。
 
 @param
 @output: 无
 @others
 *************************************************/
- (void)glSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/*************************************************
 @Description:
 NSArray (Readonly_jsonString)：对数组做json格式转换
 *************************************************/
@interface NSArray (Readonly_jsonString)

/*************************************************
 @method: jsonStringForGL
 @description:按照json格式输出字符串
 
 @output: 无
 @return: json格式字符串
 @others:
 *************************************************/
- (NSString*)jsonStringForGL;

@end


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/*************************************************
 @Description:
 NSString (GLJSONDecoder)：对字符串做json格式解码
 *************************************************/
@interface NSString (GLJSONDecoder)

/*************************************************
 @method: jsonParse
 @description:对字符串做json格式解码
 
 @output: 无
 @return: json格式的数据结构，可能是dictionary，array等
 @others:
 *************************************************/
- (id)jsonParse;

@end


