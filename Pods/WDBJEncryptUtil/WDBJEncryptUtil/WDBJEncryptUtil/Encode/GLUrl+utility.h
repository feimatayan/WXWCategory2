//
//  GLURL+Utility.h
//  iShoppingCommon
//
//  Created by 赵 一山 on 14-5-28.
//  Copyright © 2011-2014 Koudai Corp. All rights reserved.
//

#import <Foundation/Foundation.h>


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/*************************************************
 @Description: NSURL (queryPairs)：对字符串本身做url encode
 直接调用类方法获取输入输出
 *************************************************/
@interface NSURL (queryPairs)

/*************************************************
 @method: queryValue:
 @description:对url解析query对应key的value
 
 @param akey query查询的key值
 @output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*) queryValue:(NSString*)akey;

/*************************************************
 @method: queryPairs:
 @description:对url解析query对应key的value
 
 @param
 @output: 无
 @return: url query中key，value键值对的map
 @others:
 *************************************************/
- (NSDictionary*) queryPairs;

/*************************************************
 @method: compare:
 @description:比较两个对象是否相等，主要比较主健值url absoluteString即可
 
 @param
 @output: 无
 @return: 比较的结果，YES：相等，NO：不想等
 @others:
 *************************************************/
- (BOOL)compare:(NSURL*)url;

@end


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/*************************************************
 @Description:
 NSString (URLUtility)：对字符串本身做url相关的操作
 直接调用类方法获取输入输出
 *************************************************/
@interface NSString (URLUtility)

/*************************************************
 @method: urlEncode:
 @description:对字符串本身做url encode
 
 @output: 无
 @return: url encode后的value值
 @others:
 *************************************************/
- (NSString*) urlEncode;

/*************************************************
 @method: urlDecode:
 @description:对字符串本身做url decode
 
 @output: 无
 @return: url decode后的value值
 @others:
 *************************************************/
- (NSString*) urlDecode;


/*************************************************
 @method: urlQueryValue:
 @description:对url解析query对应key的value
 
 @param akey query查询的key值
 @output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*) urlQueryValue:(NSString*)akey;

/*************************************************
 @method: appendQueryKey:
 @description:追加url的query键值对,不排重
 
 @param akey query查询的key值
 output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*)appendQueryKey:(NSString*)akey value:(NSString*)avalue;

/*************************************************
 @method: appendQueryKey:
 @description:追加url的query键值对,不排重
 
 @param aPair query查询的键值对字符串
 output: 无
 @return: url query 对应key的value
 @others:
 *************************************************/
- (NSString*)appendQueryString:(NSString*)aPair;


/*************************************************
 @method: isURL:
 @description:判断是否合法的url，一般url长度大于4.
 
 @output: 无
 @return: YES，合法url；NO，非法url
 @others:
 *************************************************/
- (BOOL)isURL;

@end

