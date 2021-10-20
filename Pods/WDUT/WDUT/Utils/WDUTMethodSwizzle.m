//
//  WDUTMethodSwizzle.m
//  WDUT
//
//  Created by WeiDian on 16/3/11.
//  Copyright © 2018 WeiDian. All rights reserved.
//


#import "WDUTMethodSwizzle.h"
#import <objc/runtime.h>

@implementation WDUTMethodSwizzle

+ (void)swizzleClassMethod:(SEL)originalSelector
             toClassMethod:(SEL)swizzledSelector
                  forClass:(Class)cls {
    Class class = object_getClass(cls);
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector
             toInstanceMethod:(SEL)swizzledSelector
                     forClass:(Class)cls {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);

    BOOL didAddMethod = class_addMethod(cls,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(cls,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
