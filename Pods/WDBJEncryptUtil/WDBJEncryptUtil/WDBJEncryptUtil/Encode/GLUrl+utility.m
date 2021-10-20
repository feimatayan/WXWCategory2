//
//  GLURL+Utility.m
//  iShoppingCommon
//
//  Created by 赵 一山 on 14-5-28.
//  Copyright © 2011-2014 Koudai Corp. All rights reserved.
//

#import "GLUrl+utility.h"

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
#pragma mark - NSURL (queryPairs)

@implementation NSURL (queryPairs)

/*************************************************
 @method: queryValue:
 @description:对url解析query对应key的value
 
 @param: akey query查询的key值
 @output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*) queryValue:(NSString*)akey {
    //url query
    NSString* queryString = [self query];
    NSArray* queryArray = [queryString componentsSeparatedByString:@"&"];
    
    //遍历单个query，获取akey对应的value值（忽略akey的大小写情况）
    for (NSString* aQuery in queryArray ) {
        NSArray* pair = [aQuery componentsSeparatedByString:@"="];
        if ([pair count] > 1) {
            NSString* key = [pair objectAtIndex:0];
            key = [key urlDecode];
            if (NSOrderedSame == [key compare:akey options:NSCaseInsensitiveSearch]) {
                NSString* value = [pair objectAtIndex:1];
                return [value urlDecode];
            }
        }
    }
    return nil;
}

/*************************************************
 @method: queryPairs:
 @description:对url解析query对应key的value
 
 @param: 无
 @output: 无
 @return: url query中key，value键值对的map
 @others:
 *************************************************/
- (NSDictionary*) queryPairs
{
    //url query
    NSString* queryString = [self query];
    NSArray* queryArray = [queryString componentsSeparatedByString:@"&"];
    
    NSMutableDictionary* queryPairs = [NSMutableDictionary dictionaryWithCapacity:5];
    //遍历单个query，获取key, value键值对.重复的key值前面的会被覆写。
    for (NSString* aQuery in queryArray ) {
        NSArray* pair = [aQuery componentsSeparatedByString:@"="];
        if ([pair count] > 1) {
            NSString* key = [pair objectAtIndex:0];
            key = [key urlDecode];
            NSString* value = [pair objectAtIndex:1];
            value = [value urlDecode];
            [queryPairs setObject:value forKey:key];
        }
    }
    return queryPairs;
}

/*************************************************
 @method: compare:
 @description:比较两个对象是否相等，主要比较主健值url absoluteString即可
 
 @param:
 rxData 比较的对象
 @output: 无
 @return: 比较的结果，YES：相等，NO：不想等
 @others:
 *************************************************/
- (BOOL)compare:(NSURL*)url {
    if ( url ) {
        NSComparisonResult result = [[self absoluteString] compare:[url absoluteString] options:NSCaseInsensitiveSearch];
        return (NSOrderedSame == result);
    }
    return NO;
}

@end

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
#pragma mark - NSString (URLUtility)
@implementation NSString (URLUtility)

/*************************************************
 @method: urlEncode:
 @description:对字符串本身做url decode
 
 @param: 字符串本身
 @output: 无
 @return: url encode后的value值
 @others:
 *************************************************/
- (NSString*) urlEncode {
    
    NSString * srtD = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8));
    
    return srtD;
}


/*************************************************
 @method: urlDecode:
 @description:对字符串本身做url decode
 
 @param: 字符串本身
 @output: 无
 @return: url decode后的value值
 @others:
 *************************************************/
- (NSString*) urlDecode{
    NSString * srtD = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)[self mutableCopy], CFSTR(""), kCFStringEncodingUTF8));
    
    return srtD;
    
    //return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/*************************************************
 @method: urlQueryValue:
 @description:对url解析query对应key的value
 
 @param: akey query查询的key值
 @output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*) urlQueryValue:(NSString*)akey {
    NSURL* tempUrl = [NSURL URLWithString:self];
    return [tempUrl queryValue:akey];
}

/*************************************************
 @method: appendQueryKey:
 @description:追加url的query键值对
 
 @param:
 input:akey query查询的key值
 input:akey query查询的value值
 output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*)appendQueryKey:(NSString*)akey value:(NSString*)avalue {
    if ([akey length] > 0) {
        if ( nil == avalue ) {
            avalue = @"";
        }
        if( [self rangeOfString:@"?"].location != NSNotFound ) {
            return [NSString stringWithFormat:@"%@&%@=%@",self, [akey urlEncode], [avalue urlEncode]];
        } else {
            return [NSString stringWithFormat:@"%@?%@=%@",self, [akey urlEncode], [avalue urlEncode]];
        }
    }
    return self;
}

/*************************************************
 @method: appendQueryKey:
 @description:追加url的query键值对,不排重
 
 @param:
 input:aPair query查询的键值对字符串
 output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*)appendQueryString:(NSString*)aPair {
    if ([aPair length] > 0) {
        if( [self rangeOfString:@"?"].location != NSNotFound ) {
            return [NSString stringWithFormat:@"%@&%@",self, aPair];
        } else {
            return [NSString stringWithFormat:@"%@?%@",self, aPair];
        }
    }
    return self;
}

/*************************************************
 @method: isURL:
 @description:判断是否合法的url，一般url长度大于4.
 
 @param:
 @output: 无
 @return: YES，合法url；NO，非法url
 @others:
 *************************************************/
- (BOOL)isURL {
    return [self length] > 4;
}

@end

