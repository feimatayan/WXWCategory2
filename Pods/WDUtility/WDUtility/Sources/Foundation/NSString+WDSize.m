//
//  NSString+WDSize.m
//  WDUtility
//
//  Created by yuping on 17/2/16.
//  Copyright (c) 2017年 yuping. All rights reserved.
//

#import "NSString+WDSize.h"
#import <objc/runtime.h>
#import "UIFont+WDHelper.h"

@implementation NSString (WDSize)

- (NSInteger)wd_caculatelineCountWithSize:(CGSize)size
                                     font:(UIFont *)font {
    int rTextHeight = (int)lroundf([self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{ NSFontAttributeName: font } context:nil].size.height);
    int rLineHeight = (int)lroundf(font.lineHeight);
    return rTextHeight / rLineHeight;
}

- (NSInteger)wd_caculatelineCountWithSize:(CGSize)size
                                     font:(UIFont *)font
                               lineHeight:(CGFloat)lineHeight {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineHeight];
    int rTextHeight = (int)lroundf([self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{
                                                                NSFontAttributeName: font,
                                                                NSParagraphStyleAttributeName: paragraphStyle
                                                                } context:nil].size.height);
    int rLineHeight = (int)lroundf(font.lineHeight);
    return rTextHeight / rLineHeight;
}

- (CGRect)wd_boundingRectWithSize:(CGSize)size
                          options:(NSStringDrawingOptions)options
                       attributes:(NSDictionary *)attributes
                          context:(NSStringDrawingContext *)context
{
    CGRect rect = CGRectZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        rect = [self boundingRectWithSize:size options:options attributes:attributes context:context];
    }
    
    if (CGRectGetHeight(rect) > size.height && size.height > 0) {
        rect.size = CGSizeMake(rect.size.width, size.height);
    }
    if (CGRectGetWidth(rect) > size.width && size.height > 0) {
        rect.size = CGSizeMake(size.width, rect.size.height);
    }
    
    return rect;
}

- (CGSize)wd_sizeWithFont:(UIFont *)font
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, @"boundingRectDictionary");

    if(!dictionary){
       dictionary = [NSMutableDictionary dictionary];
    } else{
        NSValue *rectValue = dictionary[font.copy];
        if(rectValue){
            return rectValue.CGRectValue.size;
        }
    }
    
    CGRect rect= [self wd_boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    dictionary[font] = [NSValue valueWithCGRect:rect];
    objc_setAssociatedObject(self, @"boundingRectDictionary", dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return rect.size;
}

- (CGSize)wd_sizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size
{
    CGRect rect= [self wd_boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

- (CGSize)wd_drawAtPoint:(CGPoint)point
                withFont:(UIFont *)font
{
    [self drawAtPoint:point
       withAttributes:@{NSFontAttributeName:font}];
    
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (void)wd_drawInRect:(CGRect)rect
             withFont:(UIFont *)font
        lineBreakMode:(NSLineBreakMode)lineBreakMode
            alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = lineBreakMode;
    textStyle.alignment = alignment;
    NSDictionary* dictionary = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:textStyle};
    [self drawInRect:rect withAttributes:dictionary];
}

- (NSMutableAttributedString *)wd_getMutableAttributeOfPrice:(UIFont *)largeFont
                                                   smallFont:(UIFont *)smallFont {
    NSDictionary *largeFontAttributes = @{NSFontAttributeName : largeFont};
    NSDictionary *smallFontAttributes = @{NSFontAttributeName : smallFont};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:largeFontAttributes];
    NSRange range = [self rangeOfString:@"."];
    if (range.location != NSNotFound) {
        range.length = self.length - range.location;
        [attributedString setAttributes:smallFontAttributes range:range];
    }
    
    return attributedString;
}

- (CGFloat)wd_getHeightWithLimitHeight:(CGFloat)limitHeight
                              fontSize:(CGFloat)fontSize
                              maxWidth:(CGFloat)maxWidth {
    CGSize size = [self wd_sizeWithFont:[UIFont systemFontOfSize:fontSize]
                      constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)];
    if (size.height > limitHeight) {
        size.height = limitHeight;
    }
    
    return size.height;
}
@end
