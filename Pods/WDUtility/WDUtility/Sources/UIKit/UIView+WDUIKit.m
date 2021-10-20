//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import "UIView+WDUIKit.h"

@implementation UIView (WDUIKit)

- (CGFloat)wd_originX {
    return self.frame.origin.x;
}

- (CGFloat)wd_originY {
    return self.frame.origin.y;
}

- (CGFloat)wd_width {
    return self.frame.size.width;
}

- (CGFloat)wd_height {
    return self.frame.size.height;
}

- (CGFloat)wd_rightX {
    return (self.wd_originX + self.wd_width);
}

- (CGFloat)wd_bottomY {
    return (self.wd_originY + self.wd_height);
}

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)rightX {
    return (self.wd_originX + self.wd_width);
}

- (CGFloat)bottomY {
    return (self.wd_originY + self.wd_height);
}

- (void)wd_setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)wd_setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)wd_setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)wd_setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)wd_addBottomLineWithLineHeight:(CGFloat)lineHeight
                             lineColor:(UIColor *)color {
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - lineHeight, self.width, lineHeight)];
    bottomLine.backgroundColor = color;
    [self addSubview:bottomLine];
}

@end
