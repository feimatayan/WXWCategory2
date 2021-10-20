//
//  GLImageProcessor.h
//  GLImageProcessor
//
//  Created by Kevin on 15/6/17.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for GLImageProcessor.
FOUNDATION_EXPORT double GLImageProcessorVersionNumber;

//! Project version string for GLImageProcessor.
FOUNDATION_EXPORT const unsigned char GLImageProcessorVersionString[];

@interface GLImageProcessor : NSObject


/******************************************
 *
 * jpeg压缩
 *
 * @param image 要处理的图片
 * @param quality 图片质量，0-100
 *
 * @return 处理后的图片二进制数据
 *
 *****************************************/
+ (NSData *)jpegCompress:(UIImage *) image quality:(int) quality;


/******************************************
 *
 * 按照图片的原始比例，根据指定的图片宽度缩放图片
 *
 * @param image 图片
 * @param width 指定的图片宽度
 *
 * @return 压缩后的图片
 *
 *****************************************/
+ (UIImage *)scaleImageByOriginalProportion:(UIImage *)image width:(CGFloat)width;


@end
