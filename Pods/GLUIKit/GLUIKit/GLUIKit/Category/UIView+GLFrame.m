//
//  UIView+GLFrame.m
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "UIView+GLFrame.h"

@implementation UIView (GLFrame)

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (void)setX:(CGFloat)x
{
    if (self.x != x)
    {
        CGRect rect = self.frame;
        rect.origin.x = x;
        self.frame = rect;
    }
}

- (CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

- (void)setY:(CGFloat)y
{
    if (self.y != y)
    {
        CGRect rect = self.frame;
        rect.origin.y = y;
        self.frame = rect;
    }
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    if (self.width != width)
    {
        CGRect rect = self.frame;
        rect.size.width = width;
        self.frame = rect;
    }
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    if (self.height != height)
    {
        CGRect rect = self.frame;
        rect.size.height = height;
        self.frame = rect;
    }
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGSize)size
{
    return self.bounds.size;
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(size, self.size))
    {
        CGRect rect = self.frame;
        rect.size = size;
        self.frame = rect;
    }
}

- (CGPoint)orgin
{
    return self.frame.origin;
}

- (void)setOrgin:(CGPoint)orgin
{
    if (!CGPointEqualToPoint(orgin, self.orgin))
    {
        CGRect rect = self.frame;
        rect.origin = orgin;
        self.frame = rect;
    }
}

+ (CGFloat)viewHeight
{
    return 0;
}

+ (CGFloat)viewWidth
{
    return 0;
}

/**
 *  all subview call “removeFromSuperview”
 *  所有的subview都会从superview中移除
 */
- (void)safeRemoveAllSubviews {
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
}

/**
 *  按照逆序，对所有的subview遍历
 *
 */
- (void)safeEnumerateSubviewsUsingBlock:(void (NS_NOESCAPE ^)(UIView* view, BOOL *stop))block {
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        block(subview, stop);
    }];
}

@end
