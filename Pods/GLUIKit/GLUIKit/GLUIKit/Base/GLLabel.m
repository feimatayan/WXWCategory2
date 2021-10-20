//
//  GLLabel.m
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLLabel.h"

@implementation GLLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // for iOS 6.0
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
