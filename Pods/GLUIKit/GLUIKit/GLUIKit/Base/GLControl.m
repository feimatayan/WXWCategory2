//
//  GLControl.m
//  GLUIKit
//
//  Created by xiaofengzheng on 11/26/15.
//  Copyright © 2015 koudai. All rights reserved.
//

#import "GLControl.h"
#import "UIView+GLFrame.h"

@implementation GLControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self glSetup];
        [self glCustomLayoutFrame:frame];
    }
    return self;
}


- (void)glSetup
{
    //  SUBCLASS TODO
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self glCustomLayoutFrame:frame];
    
}

- (void)glCustomLayoutFrame:(CGRect)frame
{
    //  SUBCLASS TODO
}


@end
