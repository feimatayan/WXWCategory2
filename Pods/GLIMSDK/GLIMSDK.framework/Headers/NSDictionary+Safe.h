//
//  NSDictionary+Safe.h
//  GLIMSDK
//
//  Created by 六度 on 2017/2/20.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Safe)
/**
 *    从字典中获取指定的字符串字段，保证返回的值是字符串类型。
 *    如果值可以响应description方法, 则调用改值得description方法转换成字符串返回。
 *    如果值为空，或既不是NSString也不是NSNumber，则返回 nil
*/
- (NSString *)safeStringForKey:(NSString *)key;
/**
 *    从字典中获取指定的数字字段，保证返回的值是数字类型。
 *    如果值为空，或不是NSNumber，则返回 nil
*/
- (NSNumber *)safeNumberForKey:(NSString *)key;

/**
 *  @author huangbiao, 17-02-22 16:30:00
 *
 *  从字典中获取数组
 *
 *  @param  key     关键字
 *
 *  @return 数组对象或nil
 */
- (NSArray *)safeArrayForKey:(NSString *)key;

/**
 *  @author huangbiao, 17-02-22 16:30:00
 *
 *  从字典中获取字典
 *
 *  @param  key     关键字
 *
 *  @return 字典对象或nil
 */
- (NSDictionary *)safeDictionaryForKey:(NSString *)key;

@end
