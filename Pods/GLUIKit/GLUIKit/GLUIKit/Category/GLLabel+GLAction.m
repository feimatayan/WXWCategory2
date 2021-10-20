//
//  GLLabel+GLAction.m
//  GLUIKit
//
//  Created by Kevin on 15/10/10.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLLabel+GLAction.h"

@implementation GLLabel (GLAction)

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
    UIControl *control = (UIControl *)[self viewWithTag:890];
    
    if (control) {
        control.frame = self.bounds;
    }
    else {
        control = [[UIControl alloc] initWithFrame:self.bounds];
        control.tag = 890;
        [self addSubview:control];
    }
    
    [self bringSubviewToFront:control];
    [control addTarget:target action:action forControlEvents:controlEvents];
    
    self.userInteractionEnabled = YES;
}

@end
