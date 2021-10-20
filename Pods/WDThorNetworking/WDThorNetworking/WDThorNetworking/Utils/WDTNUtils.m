//
//  WDTNUtils.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/9.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNUtils.h"
#import "WDTNPrivateDefines.h"
#import "WDTNUT.h"

#import <YYModel/YYModel.h>


@implementation WDTNUtils

+ (NSString*)safeString:(NSString*)str {
    return (str == nil) ? @"" : str;
}

+ (id)safeObjectFromDict:(NSDictionary*)dict forKey:(NSString*)key {
    if (![dict isKindOfClass:[NSDictionary class]] || (key == nil)) {
        return nil;
    } else {
        return dict[key];
    }
}

+ (id)jsonParse:(id)jsonstr {
    if (jsonstr == nil ||
        ([jsonstr isKindOfClass:[NSString class]] || [jsonstr isKindOfClass:[NSData class]]) == NO) {
        return nil;
    }
    NSData *data = jsonstr;
    if ([jsonstr isKindOfClass:[NSString class]]) {
        data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        WDTNLog(@"JSON Parsing Exception: %@", error.domain);
        return nil;
    } else {
        return result;
    }
}

+ (NSString *)stringFromJSONObject:(id)object {
    NSString *jsonString = nil;
    @try {
        jsonString = [object yy_modelToJSONString];
    } @catch (NSException *exception) {
        NSInteger dataLength = [object yy_modelToJSONData].length;
        [WDTNUT commitException:@"[WDTNUtils stringFromJSONObject]"
                           arg1:exception.name
                           arg2:exception.reason
                           arg3:[NSString stringWithFormat:@"%ld", (long)dataLength]
                           args:exception.userInfo];
    } @finally {
        return jsonString;
    }
    
    /*
    if (object == nil || ![NSJSONSerialization isValidJSONObject:object]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
    if (error) {
        WDTNLog(@"NSJSONSerialization dataWithJSONObject failed:%@", error.domain);
        
        return nil;
    } else {
        if (jsonData && ![jsonData isKindOfClass:[NSNull class]]) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            WDTNLog(@"NSJSONSerialization dataWithJSONObject failed: jsonData is null or NSNull!");
            
            return nil;
        }
    }*/
}

#pragma mark - ** 过滤处理后，返回字符串对象 **

+ (NSString *)parserNSStringWithValue:(id)value
{
    if (!value) {
        return @"";
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", value];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    else if ([value isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else{
        return @"";
    }
}

+ (void)logTechEvent:(NSString *)eventId paramsDic:(NSDictionary *)paramsDic {
    NSAssert(eventId.length > 0, @"event id 不能未空，请确认!");
    NSArray *eventItems = [eventId componentsSeparatedByString:@";"];
    NSAssert(eventItems.count == 3, @"event id 格式不合法，请确认!");
    
    NSString *moduleName = [self parserNSStringWithValue:[eventItems objectAtIndex:0]];
    // NSString *typeStr  = [WDSDataSecurityManager parserNSStringWithValue:[eventItems objectAtIndex:1]]; // 没有用到
    NSString *eventName = [self parserNSStringWithValue:[eventItems objectAtIndex:2]];
    
    [self logTechEvent:eventName fromModule:moduleName withParams:paramsDic];
}

+ (void)logTechEvent:(NSString *)eventName
          fromModule:(NSString *)moduleName
          withParams:(NSDictionary *)paramsDic
{
    NSString *level = @"debug"; // log level 默认 为 debug
    NSDictionary *businessArgs = [self normalizeArgs:paramsDic];
    NSDictionary *utArgs = @{ @"module": moduleName, @"trackId": eventName, @"level": level, @"bizArgs": businessArgs };
    
    [WDTNUT commitEvent:@"9999" args:(NSDictionary *)utArgs];
}


/**
 在上报时我们做一个自定义key到约定key的转换
 统计模块约定，args1到args6为String类型，args7到args10为数字类型
 @param args 上报的参数
 @return 序列化后的参数
 */
+ (NSDictionary *)normalizeArgs:(NSDictionary *)args {
    if (args.count == 0) {
        return args;
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:args];
    
    NSMutableDictionary *argsDict = [NSMutableDictionary dictionaryWithCapacity:args.count];
    
    NSMutableArray *stringArgKeys = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger i = 6; i > 0 ; i--) {
        [stringArgKeys addObject:[NSString stringWithFormat:@"arg%@", @(i)]];
    }
    NSMutableArray *numberArgKeys = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 10; i >= 7; i--) {
        [numberArgKeys addObject:[NSString stringWithFormat:@"arg%@", @(i)]];
    }
    
    NSArray *sortedKeys = [self getSortedKeysFromArgs:args];
    for (NSString *key in sortedKeys) {
        id value = [args valueForKey:key];
        if (value == nil) {
            continue;
        }
        if ([value isKindOfClass:[NSString class]]) {
            if (stringArgKeys.count == 0) {
                [argsDict setValue:value forKey:key];
                continue;
            } else {
                [argsDict setValue:key forKey:stringArgKeys.lastObject];
                [stringArgKeys removeLastObject];
            }
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            if (numberArgKeys.count == 0) {
                [argsDict setValue:value forKey:key];
                continue;
            } else {
                [argsDict setValue:key forKey:numberArgKeys.lastObject];
                [numberArgKeys removeLastObject];
            }
        }
    }
    
    [result setValue:argsDict forKey:@"_keys_"];
    return result;
}

+ (NSArray *)getSortedKeysFromArgs:(NSDictionary *)args {
    NSArray *keys = [args allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return sortedKeys;
}


@end
