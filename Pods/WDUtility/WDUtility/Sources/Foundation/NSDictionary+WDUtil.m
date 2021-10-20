//
//  NSDictionary+WDUtil.m
//  KouDai
//
//  Created by Fnoz on 16/4/20.
//
//

#import "NSDictionary+WDUtil.h"
#import "NSString+WDFoundation.h"

@implementation NSDictionary (WDUtil)

//和原有API相比，其中有值为nil时，后面的项仍会添加进去
+ (NSDictionary *)wd_dictionaryKeysAndObjects:(NSObject *)obj, ...NS_REQUIRES_NIL_TERMINATION {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSObject *tempObj = obj;
    NSString *key;
    NSInteger i = 0;
    va_list list;
    va_start(list, obj);
    while (tempObj != nil || key != nil) {
        if (0 == i % 2) {
            key = (NSString *) tempObj;
        } else if (tempObj) {
            dic[(NSString *) key] = tempObj;
            key = nil;
        } else {
            //当最后的一个键值对的值为空时，没有将key设为空，导致下一次取到value为脏数据，而key为空，导致crash
            key = nil;
        }
        tempObj = va_arg(list, NSObject*);
        i++;
    }
    va_end(list);
    return dic;
}

- (NSString *)wd_stringObjectForKey:(NSString *)key {
    NSString *value = nil;
    NSString *tmpString = [self objectForKey:key];
    if ([tmpString isKindOfClass:[NSString class]]) {
        value = tmpString;
    } else if ([tmpString isKindOfClass:[NSNumber class]]) {
        NSNumber* number = (NSNumber*)tmpString;
        value = [number stringValue];
    }
    
    return value;
}

- (NSNumber *)wd_numberObjectForKey:(NSString *)key {
    NSNumber *number = nil;
    NSNumber *tmpNumber = [self objectForKey:key];
    if ([tmpNumber isKindOfClass:[NSNumber class]]) {
        number = tmpNumber;
    } else if ([tmpNumber isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)tmpNumber;
        number = [NSNumber numberWithLongLong:[str wd_longLongValue]];
    }
    
    return number;
}

@end
