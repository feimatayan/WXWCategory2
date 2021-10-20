//
//  GLIPUTUtil.m
//  GLImagePicker
//
//  Created by zhangylong on 2021/1/26.
//

#import "GLIPUTUtil.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation GLIPUTUtil

+ (NSString *)getCuid {
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(getCuid);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        return ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelector);
    }
    
    return nil;
}

+ (NSString *)getSuid {
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(getSuid);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        return ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelector);
    }
    
    return nil;
}

+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args {
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(commitEvent:args:);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        ((void (*)(id, SEL, NSString *, NSDictionary *)) objc_msgSend)(utClass, utSelector, eventId, args);
    }
}

+ (void)commitTechEvent:(NSString *)pageName
                   arg1:(NSString *)arg1
                   arg2:(NSString *)arg2
                   arg3:(NSString *)arg3
                   args:(NSDictionary *)args
{
    Class utClass = NSClassFromString(@"WDUT");
    SEL utSelector = @selector(commitEvent:pageName:arg1:arg2:arg3:args:);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        ((void (*)(id, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, NSDictionary *)) objc_msgSend)
        (utClass, utSelector, @"9999", pageName, arg1, arg2, arg3, args);
    }
}


@end
