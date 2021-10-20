//
//  GLHtmlLabel.m
//  GLHtmlLabel
//
//  Created by Acorld on 14-11-25.
//  Copyright (c) 2014年 Acorld. All rights reserved.
//

#import "GLHtmlLabel.h"
#import "GLHtmlElement.h"

@interface GLHtmlLabel ()

/**
 *  存储需要显示的字符串
 */
@property (nonatomic,copy) NSString *toOperateString;


@property (nonatomic,strong) NSMutableArray *items;
@end

@implementation GLHtmlLabel

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //Default
        self.linkAttributes = [NSDictionary dictionaryWithObject:@"#3b7dc1" forKey:@"color"];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initGLHtmlLabelWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //Default
        self.linkAttributes = [NSDictionary dictionaryWithObject:@"#3b7dc1" forKey:@"color"];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 *  over father method
 *
 */
- (void)onButtonPressed:(UIButton *)sender
{
    id componentIndex = [sender valueForKey:@"_componentIndex"];
    if (!componentIndex) return;
    
    int index = [componentIndex intValue];
    if (index > self.items.count - 1)
        return;
    
    GLLinkElement *element = self.items[index];
	[self setCurrentSelectedButtonComponentIndex:-1];
	[self setNeedsDisplay];

    if (element.selector && element.target)
    {
        [element.target performSelector:element.selector withObject:nil afterDelay:0.0];
    }
    
	if ([self.glDelegate respondsToSelector:@selector(htmlLabel:didTapLink:)])
	{
		[self.glDelegate htmlLabel:self didTapLink:element];
	}
}

- (NSString *)toOperateString
{
    if (!_toOperateString)
    {
        NSString *preText = self.text;
        if (!preText) preText = @"";
        _toOperateString = [preText copy];
    }
    return _toOperateString;
}

//- (void)setText:(NSString *)text
//{
//    NSLog(@"如果使用本类，不支持直接调用此方法！");
//}

#pragma mark - 业务方法
#pragma mark -

- (void)addElement:(GLHtmlElement *)element
{
    if (!_items)
    {
        _items = [NSMutableArray new];
    }
    
    NSMutableString *text = [NSMutableString stringWithString:self.toOperateString];
    [text appendString:element.htmlString];
    self.toOperateString = text;
    
    [_items addObject:element];
}

- (void)addElements:(NSArray *)elements
{
    for (int i = 0; i < elements.count; i++)
    {
        GLHtmlElement *element = elements[i];
        [self addElement:element];
    }
}

- (void)drawText
{
    [super setText:self.toOperateString];
    
    //relayout view frame
//    CGRect rect = self.frame;
//    rect.size.height = self.optimumSize.height;
//    self.frame = rect;
    
    //reset
    self.toOperateString = nil;
}

@end
