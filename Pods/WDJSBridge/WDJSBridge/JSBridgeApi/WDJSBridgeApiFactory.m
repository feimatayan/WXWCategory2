//
//  WDJSBridgeApiFactory.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2017/12/22.
//  Copyright © 2017年 WangYiqiao. All rights reserved.
//

#import "WDJSBridgeApiFactory.h"
#import "WDJSBridgeBaseApi.h"
#import <objc/runtime.h>
#import "WDJSBridgeMacros.h"
#import "WDJSBridgeLogger.h"
#import "WDJSBridgeApiUtils.h"

@implementation WDJSBridgeApiFactory

#pragma mark - Public

+ (BOOL)apiExistsInModule:(NSString *)module identifier:(NSString *)identifier {
	
	if([WDJSBridgeApiUtils jsbridge_isNullStr:module] || [WDJSBridgeApiUtils jsbridge_isNullStr:identifier]) {
		return NO;
	}
	
	NSString *className = [NSString stringWithFormat:@"%@_%@_%@", kWDJSBridgeAPIPrefix, module, identifier];
	Class apiClass = NSClassFromString(className);
	
	return apiClass != nil;
}

+ (WDJSBridgeBaseApi *)apiWithModule:(NSString *)module identifier:(NSString *)identifier params:(NSDictionary *)params {
	
	if (![WDJSBridgeApiFactory apiExistsInModule:module identifier:identifier]) {
		return nil;
	}
	
	NSString *className = [NSString stringWithFormat:@"%@_%@_%@", kWDJSBridgeAPIPrefix, module, identifier];
	Class apiClass = NSClassFromString(className);
	
	WDJSBridgeBaseApi *api = [[apiClass alloc] init];
	[api setValue:params forKey:@"params"];
	
	NSDictionary *propertyMap = @{};
	NSArray *mapToKeys = propertyMap.allValues;
	for (NSString *datakey in params.allKeys) {
		@autoreleasepool {
			__block NSString *propertyKey = datakey;
			if (propertyMap && [mapToKeys containsObject:datakey]) {
				[propertyMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
					if (key.length && [obj isEqualToString:datakey]) {
						propertyKey = key;
						*stop = YES;
					}
				}];
			}
			
			objc_property_t property = class_getProperty([api class], [propertyKey UTF8String]);
			if (!property) {
				WDJSBridgeLog(@"找不到对应的属性，需要留意...");
				continue;
			}
			
			id value = [params objectForKey:datakey];
			id safetyValue = [self parseFromKeyValue:value];
			if (safetyValue) {
				[api setValue:safetyValue forKey:propertyKey];
			}
		}
	}
	
	return api;
}

#pragma mark - Private Helper


/**
 对任意对象作空值过滤处理
 */
+ (id)parseFromKeyValue:(id)value {
	//值无效
	if ([value isKindOfClass:[NSNull class]]) {
		return nil;
	}
	
	if ([value isKindOfClass:[NSNumber class]]) { //统一处理为字符串
		value = [NSString stringWithFormat:@"%@",value];
	} else if ([value isKindOfClass:[NSArray class]]) { //数组
		value = [self parseFromArray:value];
	} else if ([value isKindOfClass:[NSDictionary class]]) { //字典
		value = [self parseFromDictionary:value];
	}
	
	return value;
}

/**
 对字典作空值过滤处理
 */
+ (NSDictionary *)parseFromDictionary:(NSDictionary *)container {
	if ([container isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *result = [NSMutableDictionary new];
		for (id key in container.allKeys) {
			@autoreleasepool {
				id value = container[key];
				
				id safetyValue = [self parseFromKeyValue:value];
				if (!safetyValue)
				{
					safetyValue = @"";
				}
				[result setObject:safetyValue forKey:key];
			}
		}
		return result;
	}
	return container;
}


/**
 对数组作空值过滤处理
 */
+ (NSArray *)parseFromArray:(NSArray *)container {
	if ([container isKindOfClass:[NSArray class]]) {
		NSMutableArray *result = [NSMutableArray new];
		for (int i = 0; i < container.count; i++) {
			@autoreleasepool {
				id value = container[i];
				
				id safetyValue = [self parseFromKeyValue:value];
				if (!safetyValue) {
					safetyValue = @"";
				}
				
				[result addObject:safetyValue];
			}
		}
		
		return result;
	}
	
	return container;
}

@end
