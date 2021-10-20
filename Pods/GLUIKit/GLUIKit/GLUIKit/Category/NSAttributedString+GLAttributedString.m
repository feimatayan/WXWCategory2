//
//  NSAttributedString+GLAttributedString.m
//  GLUIKit
//
//  Created by yanglei on 2017/10/20.
//  Copyright © 2017年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "NSAttributedString+GLAttributedString.h"

@implementation NSAttributedString (GLAttributedString)

- (CGSize)glSizeWithConstrainedSize:(CGSize)csize
{
    CGSize size = CGSizeZero;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        // NSString class method:
        CGRect rect = [self boundingRectWithSize:csize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        size = rect.size;
    }
    
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
@end
