//
//  NSObject+arraydicjson.m
//  iShoppingCommon
//
//  Created by 赵 一山 on 14-8-1.
//
//

#import "NSObject+gljson.h"
#import "CryptUtil.h"
#import "GLCodeUtil.h"
#import "GLUrl+utility.h"

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
#pragma mark - NSDictionary (ReadonlyInsensitiveStringKey_jsonString)

@implementation NSDictionary (ReadonlyInsensitiveStringKey_jsonString)

/*************************************************
 @method: objectForInsensitiveKey:
 @description:读取value时，忽略字符串key的大小写情况，取正向第一个匹配key的value
 
 @param key 的key值；
 @output: 无
 @return: key对应的value值
 @others:
 *************************************************/
- (id) objectForInsensitiveKey:(id)akey {
    
    if ( [akey isKindOfClass:[NSString class]] ) {
        //字符串key值，不区分大小写读取value
        NSArray*keys = [self allKeys];
        for (NSString* tmpkey in keys) {
            if( NSOrderedSame == [tmpkey caseInsensitiveCompare:akey] ) {
                return [self objectForKey:tmpkey];
            }
        }
        
        return nil;
    } else {
        //非字符串类型，调用标准objectForKey
        return [self objectForKey:akey];
    }
}

/*************************************************
 @method: jsonStringForGL:
 @description:按照json格式输出字符串
 
 @output: 无
 @return: json格式字符串
 @others:
 *************************************************/
- (NSString*)jsonStringForGL {
    //jsonkit库格式化json串
    ;
    NSString * strJson = [CryptUtil getJsonStringWithObject:self];
    if ( nil == strJson) {
        NSString * seperateStr = @":";
        NSMutableArray *pairs = [NSMutableArray array];
        for (NSString *key in [self keyEnumerator]) {
            id value = [self valueForKey:key];
            if (([value isKindOfClass:[NSString class]])) {
                [pairs addObject:[NSString stringWithFormat:@"\"%@\"%@%@", key, seperateStr, [CryptUtil getJsonStringWithObject:value]]];
            } else if (([value isKindOfClass:[NSNumber class]])) {
                //[pairs addObject:[NSString stringWithFormat:@"\"%@\"%@\"%@\"", key, seperateStr, [value stringValue] ]];
                [pairs addObject:[NSString stringWithFormat:@"\"%@\"%@\"%@\"", key, seperateStr, (value == (id)kCFBooleanTrue)?@"true":( (value == (id)kCFBooleanFalse)?@"false":[value stringValue])]];
            } else if (([value isKindOfClass:[NSArray class]])){
                [pairs addObject:[NSString stringWithFormat:@"\"%@\"%@%@", key, seperateStr, [value jsonStringForGL] ]];
            } else if (([value isKindOfClass:[NSDictionary class]])){
                [pairs addObject:[NSString stringWithFormat:@"\"%@\"%@%@", key, seperateStr, [value jsonStringForGL] ] ];
            } else if (([value isKindOfClass:[NSData class]])) {
                [pairs addObject:[NSString stringWithFormat:@"\"%@\"%@%@", key, seperateStr, [GLCharCodecUtil base64Encoding:value]] ];
            } else {
                continue;
            }
        }
        
        strJson = [NSString stringWithFormat:@"{%@}", [pairs componentsJoinedByString:@","] ];
    }
    return strJson;
}

/*************************************************
 @method: httpBodyForGL
 @description:按照http query的格式输出字符串，不做url encode
 
 @output: 无
 @return: http url query格式字符串
 @others:
 *************************************************/
- (NSString*)httpBodyForGL {
    NSMutableString *tempBodyStr = [[NSMutableString alloc] init];
    for (NSString *key in [self keyEnumerator]) {
        id value = [self valueForKey:key];
        NSString *str = [NSString stringWithFormat:@"%@=%@&", key, value];
        [tempBodyStr appendString:str];
    }
    return [tempBodyStr substringToIndex:tempBodyStr.length - 1];
}

/*************************************************
 @method: httpUrlForGL
 @description:按照http query的格式输出字符串，需要做url encode

 @output: 无
 @return: http url query格式字符串
 @others:
 *************************************************/
- (NSString*)httpUrlForGL {
    NSMutableString *tempBodyStr = [[NSMutableString alloc] init];
    for (NSString *key in [self keyEnumerator]) {
        id value = [self valueForKey:key];
        NSString* strValue = [NSString stringWithFormat:@"%@", value];
        NSString *str = [NSString stringWithFormat:@"%@=%@&", key, [strValue urlEncode] ];
        [tempBodyStr appendString:str];
    }
    return [tempBodyStr substringToIndex:tempBodyStr.length - 1];
}

@end

@implementation NSMutableDictionary (kdsetobject)

/*************************************************
 @method: glSetObject:forKey:
 @description:对setObject:forKey:做参数判断，避免crash。
 
 @output: 无
 @others:
 *************************************************/
- (void)glSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
#pragma mark - NSArray (Readonly_jsonString)

@implementation NSArray (Readonly_jsonString)

/*************************************************
 @method: jsonStringForGL:
 @description:按照json格式输出字符串
 
 @output: 无
 @return: json格式字符串
 @others:
 *************************************************/
- (NSString*)jsonStringForGL {
    //jsonkit库格式化json串
    NSString * strJson = [CryptUtil getJsonStringWithObject:self];
    if ( nil == strJson) {
        NSMutableArray *pairs = [NSMutableArray array];
        for (id value in self) {
            if (([value isKindOfClass:[NSString class]])) {
                [pairs addObject:[NSString stringWithFormat:@"%@", [CryptUtil getJsonStringWithObject:value]]];
            } else if (([value isKindOfClass:[NSNumber class]])) {
                //[pairs addObject:[NSString stringWithFormat:@"\"%@\"", [value stringValue] ]];
                [pairs addObject:[NSString stringWithFormat:@"\"%@\"", (value == (id)kCFBooleanTrue)?@"true":( (value == (id)kCFBooleanFalse)?@"false":[value stringValue])]];
            } else if (([value isKindOfClass:[NSArray class]])){
                [pairs addObject:[value jsonStringForGL] ];
            } else if (([value isKindOfClass:[NSDictionary class]])){
                [pairs addObject:[value jsonStringForGL] ];
            } else {
                continue;
            }
        }
        strJson = [NSString stringWithFormat:@"[%@]", [pairs componentsJoinedByString:@","] ];
    }
    return strJson;
}

@end


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
#pragma mark - NSString (GLJSONDecoder)
////////////////////////////////////////////////////////////////////////////
/*************************************************
 @Description:
 NSString (GLJSONDecoder)：对字符串做json格式解码
 *************************************************/
@implementation NSString (GLJSONDecoder)
/*************************************************
 @method: jsonParse
 @description:对字符串做json格式解码
 
 @output: 无
 @return: json格式的数据结构，可能是dictionary，array等
 @others:
 *************************************************/
- (id)jsonParse {
    //jsonkit parserjs
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

@end

