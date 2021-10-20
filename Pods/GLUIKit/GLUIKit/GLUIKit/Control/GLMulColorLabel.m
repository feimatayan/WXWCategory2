//
//  GLMulColorLabel.m
//  GLUIKit
//
//  Created by Kevin on 15/10/9.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLMulColorLabel.h"
#import "GLUIKitUtils.h"
#import "NSString+GLString.h"

//#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation GLMulColorLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textAlignment = GLTextAlignmentLeft;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    switch (_textAlignment) {
            
        case GLTextAlignmentRight:
        {
            UIFont* font = [UIFont systemFontOfSize:15];
            // tail
            CGPoint ptOfTail = rect.origin;
            ptOfTail.x += rect.size.width;
            CGSize tailSize = [_tail glSizeWithFont:font];
            ptOfTail.x -= tailSize.width;
            ptOfTail.y += 8;
//            [[UIColor blackColor] set];
            //[UIColorFromRGB(0x969696) set];
            [_tail glDrawAtPoint:ptOfTail withFont:font withColor:nil];
            
            // mid
            CGPoint ptOfMid = ptOfTail;
            UIFont* midFont = [UIFont boldSystemFontOfSize:17.5];
            CGSize midSize = [_mid glSizeWithFont:midFont];
            ptOfMid.x -= (midSize.width + 2);
            ptOfMid.y = rect.origin.y + 2;
            //[[UIColor darkdarkGrayColor] set];
//            [UIColorFromRGB(0xd7323d) set];
            [_mid glDrawAtPoint:ptOfMid withFont:midFont withColor:UIColorFromRGB(0xd7323d)];
            
            // head
            UIColor* headColor = [UIColor blackColor];
//            [headColor set];
            UIFont* headFont = [UIFont systemFontOfSize:17.5];
            CGSize headSize = [_head glSizeWithFont:headFont];
            
            CGPoint ptOfHead = ptOfMid;
            ptOfHead.x -= (headSize.width + 2);
            ptOfHead.y = rect.origin.y + 8;
            [_head glDrawAtPoint:ptOfHead withFont:font withColor:headColor];
        }
            break;
            
        case GLTextAlignmentCenter:
        {
            UIFont* headFont    = [UIFont systemFontOfSize:11.5];
            UIFont* midFont     = [UIFont boldSystemFontOfSize:11.5];
            UIFont* tailFont    = [UIFont systemFontOfSize:11.5];
            
            CGSize headSize = [_head glSizeWithFont:headFont];
            CGSize midSize  = [_mid glSizeWithFont:midFont];
            CGSize tailSize = [_tail glSizeWithFont:tailFont];
            
            CGFloat textWidth = headSize.width + 2 + midSize.width + 2 + tailSize.width;
            CGFloat xStart = (rect.size.width - textWidth) / 2;
            
            // head
            UIColor* headColor = UIColorFromRGB(0x969696);
//            [headColor set];
            CGPoint ptOfHead = rect.origin;
            ptOfHead.x = xStart;
            ptOfHead.y = ptOfHead.y + 8;
            [_head glDrawAtPoint:ptOfHead withFont:headFont withColor:headColor];
            headSize = [_head glSizeWithFont:headFont];
            
            // mid
            CGPoint ptOfMid = ptOfHead;
            ptOfMid.x += (headSize.width + 2);
            ptOfMid.y = rect.origin.y + 2;
//            [UIColorFromRGB(0xd7323d) set];
            [_mid glDrawAtPoint:ptOfMid withFont:midFont withColor:UIColorFromRGB(0xd7323d)];
            midSize = [_mid glSizeWithFont:midFont];
            // tail
            CGPoint ptOfTail = ptOfMid;
            ptOfTail.x += (midSize.width + 2);
            ptOfTail.y = rect.origin.y + 8;
//            [UIColorFromRGB(0x969696) set];
            [_tail glDrawAtPoint:ptOfTail withFont:tailFont withColor:UIColorFromRGB(0x969696)];
        }
            break;
            
        case GLTextAlignmentLeft:
        {
            // head
            UIColor* headColor = UIColorFromRGB(0x707070);
//            [headColor set];
            UIFont* font = [GLUIKitUtils transferToiOSFontSize:22];
            CGPoint ptOfHead = rect.origin;
            [_head glDrawAtPoint:ptOfHead withFont:font withColor:headColor];
            CGSize sz = [_head glSizeWithFont:font];
            
            // mid
            CGPoint ptOfMid = rect.origin;
            ptOfMid.x += sz.width + 2;
            ptOfMid.y -= 2;
            UIColor *midCol = UIColorFromRGB(0xc60a1e);
//            [midCol set];
            UIFont *midFont = [GLUIKitUtils transferToiOSFontSize:26];
            [_mid glDrawAtPoint:ptOfMid withFont:midFont withColor:midCol];
            sz = [_mid glSizeWithFont:midFont];
            
            // tail
            CGPoint ptOfTail = ptOfMid;
            ptOfTail.x += sz.width + 2;
            ptOfTail.y += 2;
//            [headColor set];
            [_tail glDrawAtPoint:ptOfTail withFont:font withColor:headColor];
        }
            break;
            
        case GLTextAlignmentExpand:
        {
            UIFont* headFont    = [UIFont systemFontOfSize:10.0];
            UIFont* midFont     = [UIFont boldSystemFontOfSize:17.5];
            UIFont* tailFont    = [UIFont systemFontOfSize:10.0];
            
            CGSize headSize = [_head glSizeWithFont:headFont];
            CGSize midSize  = [_mid glSizeWithFont:midFont];
            CGSize tailSize = [_tail glSizeWithFont:tailFont];
            
            CGFloat textWidth = headSize.width + 2 + midSize.width + 2 + tailSize.width;
            CGFloat xStart = (rect.size.width - textWidth) / 2;
            
            // head
            UIColor* headColor = [UIColor darkGrayColor];
//            [headColor set];
            CGPoint ptOfHead = rect.origin;
            ptOfHead.x = xStart;
            ptOfHead.y = ptOfHead.y + 8;
            [_head glDrawAtPoint:ptOfHead withFont:headFont withColor:headColor];
            headSize = [_head glSizeWithFont:headFont];
            
            // mid
            CGPoint ptOfMid = ptOfHead;
            ptOfMid.x = (rect.size.width + headSize.width - tailSize.width - midSize.width) / 2;
            ptOfMid.y = rect.origin.y + 2;
//            [UIColorFromRGB(0xd7323d) set];
            [_mid glDrawAtPoint:ptOfMid withFont:midFont withColor:UIColorFromRGB(0xd7323d)];
            
            // tail
            CGPoint ptOfTail = rect.origin;
            ptOfTail.x += rect.size.width;
            ptOfTail.x -= tailSize.width;
            ptOfTail.y += 8;
//            [[UIColor darkGrayColor] set];
            [_tail glDrawAtPoint:ptOfTail withFont:tailFont withColor:[UIColor darkGrayColor]];
        }
            break;
            
        default:
            break;
    }
}

-(void)setHead:(NSString *)head
{
    if (![_head isEqual:head]) {
        
        _head = head;
        [self setNeedsDisplay];
    }
}

-(void)setMid:(NSString *)mid
{
    if (![_mid isEqual:mid]) {

        _mid = mid;
        [self setNeedsDisplay];
    }
}

-(void)setTail:(NSString *)tail
{
    if (![_tail isEqual:tail]) {

        _tail = tail;
        [self setNeedsDisplay];
    }
}

@end
