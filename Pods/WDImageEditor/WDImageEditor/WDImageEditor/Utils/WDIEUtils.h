//
//  WDIEUtils.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDIEUtils : NSObject

+ (UIColor *)wdie_colorFromRGB:(int)rgbValue;

+ (UIImage *)wdie_copyImage:(UIImage *)image;

+ (CGSize)wdie_sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)csize;

@end
