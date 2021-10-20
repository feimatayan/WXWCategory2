//
//  WDJSBridgeStatisticsManager.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/3/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeStatisticsManager.h"
#import "WDJSBridgeStatisticsProtocol.h"
#import "WDJSBridgeItem.h"
#import "WDJSBridgeLogger.h"

@implementation WDJSBridgeStatisticsManager

+ (instancetype)sharedManager
{
    static WDJSBridgeStatisticsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WDJSBridgeStatisticsManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)logWithEvent:(NSString *)event param:(NSDictionary *)param
{
    [self logWithEvent:event param:param item:nil];
}

- (void)logWithEvent:(NSString *)event item:(WDJSBridgeItem *)item {
    [self logWithEvent:event param:nil item:item];
}

- (void)logWithEvent:(NSString *)event param:(NSDictionary *)param item:(WDJSBridgeItem *)item
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
        dic[@"event"] = event ?: @"";
        
        if (item) {
            
            NSString *module = item.module ?: @"";
            dic[@"module"] = module;
            
            NSString *identifier = item.identifier ?: @"";
            dic[@"identifier"] = identifier;
            
            NSString *contextID = item.contextID ?: @"";
            dic[@"contextID"] = contextID;
            
            NSDictionary *param = [NSDictionary dictionaryWithDictionary:item.parsedParam];
            // 过滤敏感信息
            // UNISDKPayService 金融相关数据
            
            // test
//            param = @{
//                @"idNo": @"330721199008104419",
//                @"userName": @"杨鑫",
//                @"idNo2": @"330721199008104419",
//                @"inputData": @{
//                        @"idNo": @"330721199008104419",
//                        @"userName": @"杨鑫",
//                },
//            };
            
            if ([@"UNISDKPayService" isEqual:identifier]) {
                param = [self removeSensitive:param depth:3];
            }
            dic[@"param"] = param;
            
            NSDictionary *bridgeParam = [NSDictionary dictionaryWithDictionary:item.bridgeParam];
            dic[@"bridgeParam"] = bridgeParam;
        }
        
        WDJSBridgeLog(@"log event: %@, param: %@", event, dic);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(logEventWithParam:)]) {
            [self.delegate logEventWithParam:dic];
        }
    });
}

- (NSDictionary *)removeSensitive:(NSDictionary *)data depth:(NSUInteger)depth {
    if (depth == 0) {
        return data;
    }
    
    NSArray *keys = data.allKeys;
    if (keys.count == 0) {
        return data;
    }
    
    bool hasEdit = NO;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id key in keys) {
        id value = data[key];
        
        if ([value isKindOfClass:NSString.class]) {
            NSUInteger length = [(NSString *)value length];
            NSString *stringValue;
            if ([@"idNo" isEqual:key]) {
                stringValue = [self removeSensitiveString:value prefixCount:4];
                
                hasEdit = stringValue != nil ? YES : NO ;
            } else if ([@"userName" isEqual:key]) {
                stringValue = [self removeSensitiveString:value prefixCount:1];
                
                hasEdit = stringValue != nil ? YES : NO ;
            } else if (length > 8 && length < 20) {
                if ([self.class checkUserIdCard:value]) {
                    stringValue = [self removeSensitiveString:value prefixCount:4];
                    
                    hasEdit = stringValue != nil ? YES : NO ;
                }
            }
            
            value = stringValue ?: value;
        } else if ([value isKindOfClass:NSDictionary.class]) {
            NSDictionary *dictValue = [self removeSensitive:value depth:depth - 1];
            if (dictValue != value) {
                value = dictValue;
                
                hasEdit = YES;
            }
        }
        
        result[key] = value;
    }
    
    return hasEdit ? result.copy : data;
}

- (NSString *)removeSensitiveString:(NSString *)aString prefixCount:(NSUInteger)prefixCount {
    if (aString.length <= prefixCount) {
        return nil;
    }
    
    if (aString.length <= prefixCount * 2) {
        return [[aString substringToIndex:prefixCount] stringByAppendingString:[self createStarString:prefixCount]];
    }
    
    NSMutableString *editValue = [NSMutableString string];
    
    NSString *prefix = [aString substringToIndex:prefixCount];
    NSString *suffix = [aString substringFromIndex:aString.length - prefixCount];
    
    [editValue appendString:prefix];
    [editValue appendString:[self createStarString:aString.length - prefixCount * 2]];
    [editValue appendString:suffix];
    
    return editValue.copy;
}

- (NSString *)createStarString:(NSUInteger)count {
    if (count == 0) {
        return @"";
    }
    
    NSMutableString *mutString = [NSMutableString string];
    for (NSUInteger index = 0; index < count; index++) {
        [mutString appendString:@"*"];
    }
    return mutString.copy;
}

#pragma mark - Regx

+ (BOOL)checkUserIdCard:(NSString *)idCard {
    if (idCard.length <= 0) {
        return NO;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:idCard];
}

@end
