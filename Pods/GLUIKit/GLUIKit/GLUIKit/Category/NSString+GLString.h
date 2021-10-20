//
//  NSString+GLString.h
//  GLUIKit
//
//  Created by xiaofengzheng on 1/18/16.
//  Copyright © 2016 koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (GLString)



#pragma mark- Size

/**
 *  计算字体 size AVAILABLE iOS7.0.0 later
 *
 *  @param font Single line, no wrapping.
 *
 *  @return size
 */
- (CGSize)glSizeWithFont:(UIFont *)font;


/**
 *  计算字体 size AVAILABLE iOS7.0.0 later
 *
 *  @return size
 */
- (CGSize)glSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)csize;

/**
 *  计算字体 size AVAILABLE iOS7.0.0 later
 *
 *  @return size
 */
- (CGSize)glSizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font numberOfLines:(NSUInteger)numberOfLines;



#pragma mark- Draw



/**
 *  绘制 AVAILABLE iOS7.0.0 later
 *
 */
- (void)glDrawAtPoint:(CGPoint)point withFont:(UIFont *)font withColor:(UIColor *)textColor;


/**
 *  绘制 AVAILABLE iOS7.0.0 later
 *
 */
- (void)glDrawInRect:(CGRect)rect withFont:(UIFont *)font withColor:(UIColor *)textColor;


#pragma mark- 

@end
