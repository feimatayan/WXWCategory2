//
//  GLHtmlElement.m
//  GLHtmlLabel
//
//  Created by Acorld on 14-11-25.
//  Copyright (c) 2014年 Acorld. All rights reserved.
//

#import "GLHtmlElement.h"
#import <objc/runtime.h>
@interface GLHtmlElement ()

/**
 *  子类的属性值生成的属性字符串
 */
@property (nonatomic,copy) NSString *attributeString;

/**
 *  默认文字颜色
 */
@property (nonatomic,copy) NSString *defaultColor;

/**
 *  默认字体大小
 */
@property (nonatomic,copy) NSString *defaultSize;
@end

@implementation GLHtmlElement

+ (id)element
{
    GLHtmlElement *element = [[self alloc] init];
    element.defaultColor = @"black";
    element.defaultSize = @"16";
    return element;
}

- (NSString *)htmlString
{
    if (self.content.length == 0 || self.name.length == 0)
    {
        return @"";
    }
    
    NSMutableDictionary *items = [NSMutableDictionary dictionaryWithDictionary:_otherAttributes];
    NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendFormat:@"<%@",self.name];
    
    if (_attributeString)
    {
        [htmlString appendFormat:@" %@",_attributeString];
    }
    
    for (NSString *key in items.allKeys)
    {
        @autoreleasepool {
            NSString *value = items[key];
            [htmlString appendFormat:@" %@=%@",key,value];
        }
    }
    
    /*if ([self isKindOfClass:[GLLinkElement class]])
    {
        GLLinkElement *link = (GLLinkElement *)self;
        if (link.downloadLineEnable)
        {
            [htmlString appendFormat:@" style='text-decoration:underline;'>%@</%@>",self.content,self.name];
        }else [htmlString appendFormat:@">%@</%@>",self.content,self.name];
    }else */[htmlString appendFormat:@">%@</%@>",self.content,self.name];
    
    return htmlString;
}




@end



/*******************************************************************************************************/
/*******************************************************************************************************/
#pragma mark- GLTextElement


@interface GLTextElement ()

/**
 *  字体颜色
 */
@property (nonatomic,copy) NSString *color;

/**
 *  字体大小
 */
@property (nonatomic,copy) NSString *size;

@end

@implementation GLTextElement

- (id)init
{
    if (self = [super init])
    {
        self.name = @"font";
    }
    return self;
}

+ (id)element
{
    GLLinkElement *element = [super element];
    element.name = @"font";
    return element;
}

+ (id)elementWithContent:(NSString *)content color:(NSString *)color size:(NSString *)size
{
    GLTextElement *element = [GLTextElement element];
    
    //格式校验
    if (!content) content = @"";
    if (!color) color = element.defaultColor;
    if (!size) size = element.defaultSize;
    
    
    element.content = content;
    element.color = color;
    element.size = size;
    element.attributeString =
    [NSString stringWithFormat:@"%@=%@ %@=%@",@"color",color,@"size",size];
    return element;
}

@end




/*******************************************************************************************************/
/*******************************************************************************************************/
#pragma mark- GLLinkElement


@interface GLLinkElement ()

/**
 *  实际的链接地址
 */
@property (nonatomic,copy) NSString *href;

@end

@implementation GLLinkElement

- (id)init
{
    if (self = [super init])
    {
        self.name = @"a";
    }
    return self;
}

+ (id)element
{
    GLLinkElement *element = [super element];
    element.name = @"a";
    return element;
}

+ (id)elementWithContent:(NSString *)content href:(NSString *)href
{
    //格式校验
    if (!href) href = @"";
    if (!content) content = @"";
    
    GLLinkElement *element = [GLLinkElement element];
    element.content = content;
    element.href = href;
    element.attributeString = [NSString stringWithFormat:@"%@=%@",@"href",href];
    return element;
}

+ (id)elementWithContent:(NSString *)content target:(NSObject *)target selector:(SEL)selector
{
    //格式校验
    if (!content) content = @"";
    
    GLLinkElement *element = [GLLinkElement element];
    element.content = content;
    element.selector = selector;
    element.target = target;
    element.attributeString = [NSString stringWithFormat:@"%@=%@",@"href",@"action"];
    return element;
}

@end
