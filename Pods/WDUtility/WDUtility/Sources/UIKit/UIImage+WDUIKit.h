//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (WDUIKit)

+ (UIImage *)wd_imageWithFileName:(NSString *)fileName;

+ (UIImage *)wd_imageWithColor:(UIColor *)color;

+ (UIImage *)wd_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)wd_scaleImageWithWidth:(CGFloat)width height:(CGFloat)height image:(UIImage *)image;

- (UIImage *)wd_scaleToSize:(CGSize)size;

- (UIImage *)wd_aspectScaleToSize:(CGSize)size;

- (UIImage *)wd_aspectFillScaleToSize:(CGSize)size;

- (UIImage*)wd_scaleToFitMaxWidth:(CGFloat)width;

- (UIImage*)wd_scaleToFitMaxHeight:(CGFloat)height;

@end
