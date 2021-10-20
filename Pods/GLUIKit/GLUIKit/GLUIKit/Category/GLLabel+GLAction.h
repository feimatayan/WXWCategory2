//
//  GLLabel+GLAction.h
//  GLUIKit
//
//  Created by Kevin on 15/10/10.
//  Copyright (c) 2015年 koudai. All rights reserved.
//



#import "GLLabel.h"



@interface GLLabel (GLAction)

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
