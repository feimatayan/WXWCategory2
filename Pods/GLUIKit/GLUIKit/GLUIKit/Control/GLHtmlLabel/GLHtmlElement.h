//
//  GLHtmlElement.h
//  GLHtmlLabel
//
//  Created by Acorld on 14-11-25.
//  Copyright (c) 2014年 Acorld. All rights reserved.
//




#import <Foundation/Foundation.h>




//----------------------------------------------------------------------------
//-------------------------GLHtmlElement  Class-------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------



@interface GLHtmlElement : NSObject

/**
 *  节点的名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  节点的值/内容
 */
@property (nonatomic,copy) NSString *content;

/**
 *  将节点转换成html字符串
 */
@property (nonatomic,readonly,copy) NSString *htmlString;

/**
 *  节点的属性值
 */
@property (nonatomic,strong) NSDictionary *otherAttributes;

/**
 *  自定义初始化方法
 *
 */
+ (id)element;

@end







//----------------------------------------------------------------------------
//-------------------------GLTextElement  Class-------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
/**
 *  纯文字节点
 */
@interface GLTextElement : GLHtmlElement

+ (id)elementWithContent:(NSString *)content color:(NSString *)color size:(NSString *)size;
@end






//----------------------------------------------------------------------------
//-------------------------GLLinkElement  Class-------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
/**
 *  超链接节点
 */
@interface GLLinkElement : GLHtmlElement

/**
 *  实际的链接地址
 */
@property (nonatomic,readonly,copy) NSString *href;

/**
 *  如果规定点击超链接是响应一个方法的话
 *  超链接将会执行这个方法
 */
@property (nonatomic,assign) SEL selector;

@property (nonatomic,strong) NSObject *target;

/// 是否支持下划线，默认NO
@property (nonatomic,assign) BOOL downloadLineEnable;

+ (id)elementWithContent:(NSString *)content href:(NSString *)href;

+ (id)elementWithContent:(NSString *)content target:(NSObject *)target selector:(SEL)selector;

@end


