//
//  WDUTMethodSwizzle.h
//  WDUT
//
//  Created by WeiDian on 16/3/11.
//  Copyright © 2018 WeiDian. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WDUTMethodSwizzle : NSObject

/**
 *  替换两个实例方法的实现
 *
 *  @param originalSelector 原来的方法
 *  @param swizzledSelector 替换后的方法
 *  @param cls              方法所在的类
 */
+ (void)swizzleInstanceMethod:(SEL)originalSelector
             toInstanceMethod:(SEL)swizzledSelector
                     forClass:(Class)cls;

/**
 *  替换两个类方法的实现
 *
 *  @param originalSelector 原来的方法
 *  @param swizzledSelector 替换后的方法
 *  @param cls              方法所在的类
 */
+ (void)swizzleClassMethod:(SEL)originalSelector
             toClassMethod:(SEL)swizzledSelector
                  forClass:(Class)cls;

@end