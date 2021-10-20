//
//  NSString+WDSize.h
//  WDUtility
//
//  Created by yuping on 17/2/16.
//  Copyright (c) 2017年 yuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WDSize)

- (NSInteger)wd_caculatelineCountWithSize:(CGSize)size
                                     font:(UIFont *)font;

- (NSInteger)wd_caculatelineCountWithSize:(CGSize)size
                                     font:(UIFont *)font
                               lineHeight:(CGFloat)lineHeight;

- (CGRect)wd_boundingRectWithSize:(CGSize)size
                          options:(NSStringDrawingOptions)options
                       attributes:(NSDictionary *)attributes
                          context:(NSStringDrawingContext *)context;

- (CGSize)wd_sizeWithFont:(UIFont *)font;

- (CGSize)wd_sizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size;

- (CGSize)wd_drawAtPoint:(CGPoint)point
                withFont:(UIFont *)font;

- (void)wd_drawInRect:(CGRect)rect
             withFont:(UIFont *)font
        lineBreakMode:(NSLineBreakMode)lineBreakMode
            alignment:(NSTextAlignment)alignment;

- (NSMutableAttributedString *)wd_getMutableAttributeOfPrice:(UIFont *)largeFont
                                                   smallFont:(UIFont *)smallFont;

- (CGFloat)wd_getHeightWithLimitHeight:(CGFloat)limitHeight
                              fontSize:(CGFloat)fontSize
                              maxWidth:(CGFloat)maxWidth;

@end
