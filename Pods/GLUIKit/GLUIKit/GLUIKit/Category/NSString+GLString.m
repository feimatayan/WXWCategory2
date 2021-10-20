//
//  NSString+GLString.m
//  GLUIKit
//
//  Created by xiaofengzheng on 1/18/16.
//  Copyright © 2016 koudai. All rights reserved.
//

#import "NSString+GLString.h"


@implementation NSString (GLString)



- (CGSize)glSizeWithFont:(UIFont *)font
{
    return [self glSizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight)];
}


- (CGSize)glSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)csize
{
    CGSize size = CGSizeZero;
    if (!font) {
        return size;
    }
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [self boundingRectWithSize:csize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        size = rect.size;
    }
//    else {
        // 升级iOS7.0
//        size = [self sizeWithFont:font constrainedToSize:csize lineBreakMode:NSLineBreakByWordWrapping];
//    }
    
    NSInteger labWidth,labHeight;
    labWidth = (NSInteger)size.width;
    labHeight = (NSInteger)size.height;
    
    if (size.width > labWidth) {
        labWidth = (NSInteger)size.width + 1;
    }
    if (size.height > labHeight) {
        labHeight = (NSInteger)size.height + 1;
    }
    
    CGSize lableNewSize = CGSizeMake(labWidth, labHeight);
    
    return lableNewSize;
}

- (CGSize)glSizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font numberOfLines:(NSUInteger)numberOfLines
{
    CGSize size = [self glSizeWithFont:font constrainedToSize:CGSizeMake(maxWidth,numberOfLines * font.lineHeight)];
    return size;
}


#pragma mark- Draw

- (void)glDrawAtPoint:(CGPoint)point withFont:(UIFont *)font withColor:(UIColor *)textColor
{
    if (font && [self respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        UIColor *color = [UIColor blackColor];
        if (textColor) {
            color = textColor;
        }
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:color};
        [self drawAtPoint:point withAttributes:attributes];
    }
}


- (void)glDrawInRect:(CGRect)rect withFont:(UIFont *)font withColor:(UIColor *)textColor
{
    if (font && [self respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        UIColor *color = [UIColor blackColor];
        if (textColor) {
            color = textColor;
        }
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:color};
        [self drawInRect:rect withAttributes:attributes];
    }
}


@end
