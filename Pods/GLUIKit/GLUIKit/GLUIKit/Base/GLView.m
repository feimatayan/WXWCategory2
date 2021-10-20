//
//  GLView.m
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLView.h"

@implementation GLView

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
