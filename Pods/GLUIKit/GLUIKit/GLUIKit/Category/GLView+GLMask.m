//
//  GLView+GLMask.m
//  GLUIKit
//
//  Created by smallsao on 2018/11/26.
//  Copyright © 2018 weidian. All rights reserved.
//

#import "GLView+GLMask.h"

@implementation GLView (GLMask)


- (void)gl_addMask {
    // 缺点，必须要先 addSubview 之后才能使用
//    self.layer.masksToBounds = YES;
//
//    CALayer *shadowLayer      = [CALayer layer];
//    shadowLayer.shadowColor   = [UIColor lightGrayColor].CGColor;
//    shadowLayer.shadowOffset  = CGSizeMake(0, 0);
//    shadowLayer.shadowOpacity = 0.8;
//    shadowLayer.shadowRadius  = 5;
//    shadowLayer.frame         = CGRectMake(0, 0, 200, 200);
//
//    [self.superview.layer addSublayer:shadowLayer];
//    [shadowLayer addSublayer:self.layer];
    
    
//    self.layer.masksToBounds = NO;
//
//    self.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
//    self.layer.shadowOffset  = CGSizeMake(0, 0);
//    self.layer.shadowOpacity = 0.8;
//    self.layer.shadowRadius  = 5;
    
    [self gl_addMask:[UIColor lightGrayColor] width:5 opacity:0.8];
}

- (void)gl_addMask:(UIColor *)color width:(CGFloat)width opacity:(CGFloat)opacity {
    [self gl_addMask:color width:width opacity:opacity offsetX:0 offsetY:0];
}

- (void)gl_addMask:(UIColor *)color width:(CGFloat)width opacity:(CGFloat)opacity offsetX:(CGFloat)x offsetY:(CGFloat)y {
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(x, y);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = width;
}


@end
