//
//  NSObject+Runtime.m
//  WDUtility
//
//  Created by HamGuy on 2021/4/29.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

- (NSArray *)getAllIvar {
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *keyChar = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        [array addObject:keyStr];
    }
    return [array copy];
}

- (NSArray *)getAllProperty {
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *nameChar = property_getName(property);
        NSString *nameStr = [NSString stringWithCString:nameChar encoding:NSUTF8StringEncoding];
        [array addObject:nameStr];
    }
    return [array copy];
}


@end
